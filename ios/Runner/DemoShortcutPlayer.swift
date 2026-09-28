import AVFoundation
import AVKit
import Flutter
import UIKit

/// Inline player for the wallpaper Shortcuts demo, with system Picture in Picture.
///
/// iOS only starts PiP for a playing `AVPlayerLayer` whose controller has
/// `canStartPictureInPictureAutomaticallyFromInline`, and only if the app
/// declares the `audio` background mode. Leaving for Shortcuts calls
/// `startPictureInPicture` while the app is still foregrounded, then opens
/// the Shortcuts URL so the mini player is already up.
final class DemoShortcutPlayerFactory: NSObject, FlutterPlatformViewFactory {
  private let messenger: FlutterBinaryMessenger
  private let registrar: FlutterPluginRegistrar

  init(messenger: FlutterBinaryMessenger, registrar: FlutterPluginRegistrar) {
    self.messenger = messenger
    self.registrar = registrar
    super.init()
  }

  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    DemoShortcutPlayerView(
      frame: frame,
      viewId: viewId,
      args: args as? [String: Any],
      messenger: messenger,
      registrar: registrar
    )
  }

  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    FlutterStandardMessageCodec.sharedInstance()
  }
}

final class DemoShortcutPlayerView: NSObject, FlutterPlatformView, AVPictureInPictureControllerDelegate {
  private static var statusContext = 0

  private let container: PlayerContainerView
  private let channel: FlutterMethodChannel
  private let eventChannel: FlutterEventChannel
  private let events: EventRelay
  private let autoplay: Bool

  private var player: AVPlayer?
  private var pipController: AVPictureInPictureController?
  private var timeObserver: Any?
  private var endObserver: NSObjectProtocol?
  private var backgroundObserver: NSObjectProtocol?
  private var observingStatus = false
  private var isReady = false
  private var hasError = false
  private var wantsPlaying = false
  private var pipStartInFlight = false
  private var pendingPipResult: FlutterResult?
  private var didCleanup = false

  init(
    frame: CGRect,
    viewId: Int64,
    args: [String: Any]?,
    messenger: FlutterBinaryMessenger,
    registrar: FlutterPluginRegistrar
  ) {
    container = PlayerContainerView(frame: frame)
    channel = FlutterMethodChannel(
      name: "com.weeksalive/demo_shortcut_player/\(viewId)",
      binaryMessenger: messenger
    )
    eventChannel = FlutterEventChannel(
      name: "com.weeksalive/demo_shortcut_player/\(viewId)/events",
      binaryMessenger: messenger
    )
    events = EventRelay()
    autoplay = args?["autoplay"] as? Bool ?? true
    super.init()

    eventChannel.setStreamHandler(events)

    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
    container.onLayout = { [weak self] in
      self?.setupPipIfNeeded()
    }
    backgroundObserver = NotificationCenter.default.addObserver(
      forName: UIApplication.didEnterBackgroundNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      self?.handleDidEnterBackground()
    }

    load(asset: args?["asset"] as? String ?? "assets/videos/demo_shortcut.mp4", registrar: registrar)
  }

  func view() -> UIView {
    container
  }

  deinit {
    cleanup()
  }

  private func load(asset: String, registrar: FlutterPluginRegistrar) {
    let key = registrar.lookupKey(forAsset: asset)
    guard let path = Bundle.main.path(forResource: key, ofType: nil) else {
      hasError = true
      emit()
      return
    }

    let item = AVPlayerItem(url: URL(fileURLWithPath: path))
    let player = AVPlayer(playerItem: item)
    player.actionAtItemEnd = .none
    player.preventsDisplaySleepDuringVideoPlayback = true
    self.player = player
    container.playerLayer.player = player

    item.addObserver(
      self,
      forKeyPath: #keyPath(AVPlayerItem.status),
      options: [.initial, .new],
      context: &DemoShortcutPlayerView.statusContext
    )
    observingStatus = true

    let interval = CMTime(seconds: 0.2, preferredTimescale: 600)
    timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] _ in
      self?.emit()
    }
    endObserver = NotificationCenter.default.addObserver(
      forName: .AVPlayerItemDidPlayToEndTime,
      object: item,
      queue: .main
    ) { [weak self] _ in
      guard let self, self.wantsPlaying else { return }
      self.player?.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero) { _ in
        DispatchQueue.main.async {
          self.player?.play()
          self.emit()
        }
      }
    }
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "play":
      play()
      result(nil)
    case "pause":
      pause()
      result(nil)
    case "seek":
      let ms = (call.arguments as? [String: Any])?["positionMs"] as? Int ?? 0
      seek(toMs: ms)
      result(nil)
    case "startPictureInPicture":
      startPictureInPicture(result: result)
    case "stopPictureInPicture":
      pipController?.stopPictureInPicture()
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func play(exclusiveAudio: Bool = false) {
    wantsPlaying = true
    configureAudioSession(exclusive: exclusiveAudio)
    player?.play()
    setupPipIfNeeded()
    emit()
  }

  private func pause() {
    wantsPlaying = false
    player?.pause()
    if pipController?.isPictureInPictureActive != true {
      try? AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
    }
    emit()
  }

  private func seek(toMs ms: Int) {
    let time = CMTime(value: CMTimeValue(max(ms, 0)), timescale: 1000)
    let shouldResume = wantsPlaying
    player?.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
      DispatchQueue.main.async {
        if shouldResume {
          self?.player?.play()
        }
        self?.emit()
      }
    }
  }

  private func startPictureInPicture(result: @escaping FlutterResult) {
    guard AVPictureInPictureController.isPictureInPictureSupported() else {
      result(false)
      return
    }
    guard pendingPipResult == nil else {
      result(false)
      return
    }
    play(exclusiveAudio: true)
    attemptStartPip(triesLeft: 8, result: result)
  }

  private func attemptStartPip(triesLeft: Int, result: @escaping FlutterResult) {
    setupPipIfNeeded()
    guard let pip = pipController else {
      result(false)
      return
    }
    if pip.isPictureInPictureActive {
      result(true)
      return
    }
    if pip.isPictureInPicturePossible {
      pipStartInFlight = true
      pendingPipResult = result
      pip.startPictureInPicture()
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
        guard let self else { return }
        self.finishPipStart(pip.isPictureInPictureActive)
      }
      return
    }
    if triesLeft <= 0 {
      result(false)
      return
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) { [weak self] in
      guard let self else {
        result(false)
        return
      }
      self.attemptStartPip(triesLeft: triesLeft - 1, result: result)
    }
  }

  private func finishPipStart(_ success: Bool) {
    guard let pending = pendingPipResult else { return }
    pendingPipResult = nil
    if !success {
      pipStartInFlight = false
    }
    pending(success)
  }

  private func setupPipIfNeeded() {
    guard pipController == nil,
      AVPictureInPictureController.isPictureInPictureSupported(),
      container.window != nil,
      container.playerLayer.bounds.width > 0,
      container.playerLayer.bounds.height > 0
    else { return }

    let pip = AVPictureInPictureController(playerLayer: container.playerLayer)
    pip?.delegate = self
    pip?.canStartPictureInPictureAutomaticallyFromInline = true
    pipController = pip
    emit()
  }

  /// Inline playback mixes with other audio, since the demo is silent.
  /// PiP needs an exclusive playback session or iOS will not detach the video.
  private func configureAudioSession(exclusive: Bool) {
    let session = AVAudioSession.sharedInstance()
    if exclusive {
      try? session.setCategory(.playback, mode: .moviePlayback)
    } else {
      try? session.setCategory(.playback, mode: .moviePlayback, options: [.mixWithOthers])
    }
    try? session.setActive(true)
  }

  private func handleDidEnterBackground() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
      guard let self else { return }
      let pipActive = self.pipController?.isPictureInPictureActive ?? false
      if pipActive || self.pipStartInFlight {
        return
      }
      self.pause()
    }
  }

  private func handleStatusChange() {
    guard !didCleanup, let item = player?.currentItem else { return }
    switch item.status {
    case .readyToPlay:
      guard !isReady else { return }
      isReady = true
      if autoplay {
        play()
      } else {
        emit()
      }
    case .failed:
      hasError = true
      emit()
    default:
      break
    }
  }

  override func observeValue(
    forKeyPath keyPath: String?,
    of object: Any?,
    change: [NSKeyValueChangeKey: Any]?,
    context: UnsafeMutableRawPointer?
  ) {
    guard context == &DemoShortcutPlayerView.statusContext else {
      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
      return
    }
    DispatchQueue.main.async { [weak self] in
      self?.handleStatusChange()
    }
  }

  func pictureInPictureControllerWillStartPictureInPicture(
    _ pictureInPictureController: AVPictureInPictureController
  ) {
    pipStartInFlight = true
  }

  func pictureInPictureControllerDidStartPictureInPicture(
    _ pictureInPictureController: AVPictureInPictureController
  ) {
    pipStartInFlight = false
    finishPipStart(true)
    emit()
  }

  func pictureInPictureController(
    _ pictureInPictureController: AVPictureInPictureController,
    failedToStartPictureInPictureWithError error: Error
  ) {
    pipStartInFlight = false
    finishPipStart(false)
    if UIApplication.shared.applicationState != .active {
      pause()
    } else {
      configureAudioSession(exclusive: false)
      emit()
    }
  }

  func pictureInPictureControllerDidStopPictureInPicture(
    _ pictureInPictureController: AVPictureInPictureController
  ) {
    if UIApplication.shared.applicationState != .active {
      pause()
    } else {
      configureAudioSession(exclusive: false)
      emit()
    }
  }

  func pictureInPictureController(
    _ pictureInPictureController: AVPictureInPictureController,
    restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void
  ) {
    completionHandler(true)
  }

  private func emit() {
    guard !didCleanup else { return }
    let durationSeconds = player?.currentItem?.duration.seconds ?? 0
    let durationMs = durationSeconds.isFinite ? Int((durationSeconds * 1000).rounded()) : 0
    let positionSeconds = player?.currentTime().seconds ?? 0
    let positionMs = positionSeconds.isFinite ? Int((positionSeconds * 1000).rounded()) : 0
    events.emit([
      "isReady": isReady,
      "hasError": hasError,
      "durationMs": durationMs,
      "positionMs": positionMs,
      "isPlaying": wantsPlaying,
      "isPipActive": pipController?.isPictureInPictureActive ?? false,
      "pipSupported": AVPictureInPictureController.isPictureInPictureSupported(),
    ])
  }

  private func cleanup() {
    guard !didCleanup else { return }
    didCleanup = true
    container.onLayout = nil
    channel.setMethodCallHandler(nil)
    eventChannel.setStreamHandler(nil)
    if observingStatus {
      player?.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), context: &DemoShortcutPlayerView.statusContext)
      observingStatus = false
    }
    if let timeObserver {
      player?.removeTimeObserver(timeObserver)
    }
    if let endObserver {
      NotificationCenter.default.removeObserver(endObserver)
    }
    if let backgroundObserver {
      NotificationCenter.default.removeObserver(backgroundObserver)
    }
    pipController?.delegate = nil
    if pipController?.isPictureInPictureActive == true {
      pipController?.stopPictureInPicture()
    }
    player?.pause()
    player?.replaceCurrentItem(with: nil)
    container.playerLayer.player = nil
    try? AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
  }
}

private final class PlayerContainerView: UIView {
  var onLayout: (() -> Void)?
  let playerLayer = AVPlayerLayer()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .black
    isOpaque = true
    isUserInteractionEnabled = false
    playerLayer.videoGravity = .resizeAspect
    playerLayer.backgroundColor = UIColor.black.cgColor
    layer.addSublayer(playerLayer)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    nil
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    playerLayer.frame = bounds
    onLayout?()
  }

  override func didMoveToWindow() {
    super.didMoveToWindow()
    onLayout?()
  }
}

private final class EventRelay: NSObject, FlutterStreamHandler {
  private var sink: FlutterEventSink?
  private var latest: [String: Any]?

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    sink = events
    if let latest {
      events(latest)
    }
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    sink = nil
    return nil
  }

  func emit(_ event: [String: Any]) {
    latest = event
    sink?(event)
  }
}
