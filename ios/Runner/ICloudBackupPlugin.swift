import Flutter
import UIKit

/// Reads and writes the WeeksAlive backup in the app's iCloud container over
/// `com.weeksalive/icloud_backup`.
///
/// The backup lives in `<container>/Backup/`: `manifest.json`, `backup.json`
/// and `images/`. Every access goes through `NSFileCoordinator` so it never
/// races the iCloud daemon. Photos are immutable (timestamped file names), so
/// uploads only copy the new ones and never delete any.
public class ICloudBackupPlugin: NSObject, FlutterPlugin {
    static let containerIdentifier = "iCloud.com.weeksalive"

    private static let manifestFileName = "manifest.json"
    private static let dataFileName = "backup.json"
    private static let imagesDirectoryName = "images"
    private static let archiveDirectoryName = "archive"
    private static let keptArchives = 5

    private let queue = DispatchQueue(label: "com.weeksalive.icloud_backup", qos: .utility)
    private var metadataQueries: [NSMetadataQuery] = []

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.weeksalive/icloud_backup",
            binaryMessenger: registrar.messenger()
        )
        let instance = ICloudBackupPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any]
        switch call.method {
        case "isAvailable":
            run(result) { self.backupDirectory() != nil }
        case "upload":
            guard let documents = arguments?["documentsDirectory"] as? String,
                  let imagePaths = arguments?["imagePaths"] as? [String]
            else { return result(Self.invalidArguments) }
            runInBackgroundTask(result) {
                try self.upload(documentsDirectory: URL(fileURLWithPath: documents), imagePaths: imagePaths)
                return nil
            }
        case "downloadManifest":
            guard let destination = arguments?["destination"] as? String
            else { return result(Self.invalidArguments) }
            run(result) { try self.downloadManifest(to: URL(fileURLWithPath: destination)) }
        case "downloadBackup":
            guard let destination = arguments?["destination"] as? String
            else { return result(Self.invalidArguments) }
            run(result) { try self.downloadBackup(to: URL(fileURLWithPath: destination)) }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Operations

    private func upload(documentsDirectory: URL, imagePaths: [String]) throws {
        let directory = try requireBackupDirectory()
        let images = directory.appendingPathComponent(Self.imagesDirectoryName, isDirectory: true)
        try FileManager.default.createDirectory(at: images, withIntermediateDirectories: true)

        let newManifest = documentsDirectory.appendingPathComponent(Self.manifestFileName)
        try archiveIfShrinking(directory: directory, newManifest: newManifest)

        // Photos first, then the data, then the manifest: a manifest in iCloud
        // always describes a complete backup.
        for path in imagePaths {
            let source = URL(fileURLWithPath: path)
            let destination = images.appendingPathComponent(source.lastPathComponent)
            if existsInCloud(destination) { continue }
            try coordinatedCopy(from: source, to: destination)
        }
        try coordinatedCopy(
            from: documentsDirectory.appendingPathComponent(Self.dataFileName),
            to: directory.appendingPathComponent(Self.dataFileName)
        )
        try coordinatedCopy(from: newManifest, to: directory.appendingPathComponent(Self.manifestFileName))
    }

    private func downloadManifest(to destination: URL) throws -> Bool {
        let directory = try requireBackupDirectory()
        let manifest = directory.appendingPathComponent(Self.manifestFileName)
        guard try ensureDownloaded(manifest, timeout: 20) else { return false }

        try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: true)
        try coordinatedCopy(from: manifest, to: destination.appendingPathComponent(Self.manifestFileName))
        return true
    }

    private func downloadBackup(to destination: URL) throws -> Bool {
        let directory = try requireBackupDirectory()
        let manifest = directory.appendingPathComponent(Self.manifestFileName)
        let data = directory.appendingPathComponent(Self.dataFileName)
        guard try ensureDownloaded(manifest, timeout: 20) else { return false }
        guard try ensureDownloaded(data, timeout: 60) else { return false }

        let images = directory.appendingPathComponent(Self.imagesDirectoryName, isDirectory: true)
        var imageURLs = cloudItems(in: images)
        let expected = expectedImageCount(manifest)
        if imageURLs.count < expected {
            // Right after a reinstall the listing can lag behind the manifest.
            _ = waitForMetadata(fileName: Self.dataFileName, timeout: 15)
            imageURLs = cloudItems(in: images)
        }

        // Start every download up front so they run in parallel, then wait.
        imageURLs.forEach { try? FileManager.default.startDownloadingUbiquitousItem(at: $0) }
        let downloaded = try imageURLs.filter { try ensureDownloaded($0, timeout: 120) }

        let destinationImages = destination.appendingPathComponent(Self.imagesDirectoryName, isDirectory: true)
        try FileManager.default.createDirectory(at: destinationImages, withIntermediateDirectories: true)
        for url in downloaded {
            try coordinatedCopy(from: url, to: destinationImages.appendingPathComponent(url.lastPathComponent))
        }
        try coordinatedCopy(from: data, to: destination.appendingPathComponent(Self.dataFileName))
        try coordinatedCopy(from: manifest, to: destination.appendingPathComponent(Self.manifestFileName))
        return true
    }

    /// Moves the current backup to `archive/<date>/` when the new one holds
    /// fewer days, so an accidental overwrite (e.g. from a device that never
    /// restored) stays recoverable. Photos are never deleted, so an archived
    /// backup keeps all of its photos.
    private func archiveIfShrinking(directory: URL, newManifest: URL) throws {
        let current = directory.appendingPathComponent(Self.manifestFileName)
        let currentData = directory.appendingPathComponent(Self.dataFileName)
        guard existsInCloud(current), existsInCloud(currentData),
              (try? ensureDownloaded(current, timeout: 20)) == true
        else { return }

        guard let currentDays = dayCount(current),
              let newDays = dayCount(newManifest),
              newDays < currentDays
        else { return }

        let archives = directory.appendingPathComponent(Self.archiveDirectoryName, isDirectory: true)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime]
        let archive = archives.appendingPathComponent(formatter.string(from: Date()), isDirectory: true)
        try FileManager.default.createDirectory(at: archive, withIntermediateDirectories: true)
        try coordinatedMove(from: currentData, to: archive.appendingPathComponent(Self.dataFileName))
        try coordinatedMove(from: current, to: archive.appendingPathComponent(Self.manifestFileName))

        let existing = (try? FileManager.default.contentsOfDirectory(
            at: archives,
            includingPropertiesForKeys: nil
        )) ?? []
        let sorted = existing.sorted { $0.lastPathComponent > $1.lastPathComponent }
        for old in sorted.dropFirst(Self.keptArchives) {
            try? coordinatedDelete(old)
        }
    }

    // MARK: - iCloud helpers

    private func backupDirectory() -> URL? {
        guard FileManager.default.ubiquityIdentityToken != nil,
              let container = FileManager.default.url(forUbiquityContainerIdentifier: Self.containerIdentifier)
        else { return nil }
        return container.appendingPathComponent("Backup", isDirectory: true)
    }

    private func requireBackupDirectory() throws -> URL {
        guard let directory = backupDirectory() else {
            throw PluginError(code: "UNAVAILABLE", message: "iCloud is not available")
        }
        return directory
    }

    /// Whether [url] exists in iCloud, downloaded or not. A file not yet
    /// downloaded shows up as a hidden `.<name>.icloud` placeholder.
    private func existsInCloud(_ url: URL) -> Bool {
        FileManager.default.fileExists(atPath: url.path)
            || FileManager.default.fileExists(atPath: placeholder(for: url).path)
    }

    private func placeholder(for url: URL) -> URL {
        url.deletingLastPathComponent().appendingPathComponent(".\(url.lastPathComponent).icloud")
    }

    /// The logical URLs of the files in [directory], placeholders included.
    private func cloudItems(in directory: URL) -> [URL] {
        let names = (try? FileManager.default.contentsOfDirectory(atPath: directory.path)) ?? []
        let resolved = names.compactMap { name -> String? in
            if name.hasPrefix("."), name.hasSuffix(".icloud") {
                return String(name.dropFirst().dropLast(".icloud".count))
            }
            return name.hasPrefix(".") ? nil : name
        }
        return Set(resolved).sorted().map { directory.appendingPathComponent($0) }
    }

    /// Downloads [url] if needed and waits for it. Returns false when the file
    /// does not exist in iCloud.
    private func ensureDownloaded(_ url: URL, timeout: TimeInterval) throws -> Bool {
        if !existsInCloud(url) {
            // Not listed yet: ask iCloud directly before concluding it is absent.
            guard waitForMetadata(fileName: url.lastPathComponent, timeout: 10) else { return false }
        }

        try? FileManager.default.startDownloadingUbiquitousItem(at: url)
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            let status = try? url.resourceValues(forKeys: [.ubiquitousItemDownloadingStatusKey])
                .ubiquitousItemDownloadingStatus
            if status == .current, FileManager.default.fileExists(atPath: url.path) { return true }
            if status == nil, FileManager.default.fileExists(atPath: url.path) { return true }
            Thread.sleep(forTimeInterval: 0.25)
        }
        throw PluginError(code: "TIMEOUT", message: "Timed out downloading \(url.lastPathComponent)")
    }

    /// Runs an `NSMetadataQuery` for [fileName] in the backup folder. It forces
    /// iCloud to fetch the container's metadata, which a fresh install may not
    /// have yet. Blocks the calling (background) queue.
    private func waitForMetadata(fileName: String, timeout: TimeInterval) -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var found = false

        DispatchQueue.main.async {
            let query = NSMetadataQuery()
            query.searchScopes = [NSMetadataQueryUbiquitousDataScope]
            query.predicate = NSPredicate(format: "%K == %@", NSMetadataItemFSNameKey, fileName)
            var observer: NSObjectProtocol?
            observer = NotificationCenter.default.addObserver(
                forName: .NSMetadataQueryDidFinishGathering,
                object: query,
                queue: .main
            ) { [weak self] _ in
                query.disableUpdates()
                found = query.results.contains { item in
                    let path = (item as? NSMetadataItem)?.value(forAttribute: NSMetadataItemPathKey) as? String
                    return path?.contains("/Backup/") == true
                }
                query.stop()
                if let observer { NotificationCenter.default.removeObserver(observer) }
                self?.metadataQueries.removeAll { $0 === query }
                semaphore.signal()
            }
            self.metadataQueries.append(query)
            query.start()
        }

        _ = semaphore.wait(timeout: .now() + timeout)
        return found
    }

    private func dayCount(_ manifest: URL) -> Int? {
        guard let data = try? Data(contentsOf: manifest),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { return nil }
        return json["dayCount"] as? Int
    }

    private func expectedImageCount(_ manifest: URL) -> Int {
        guard let data = try? Data(contentsOf: manifest),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { return 0 }
        return json["imageCount"] as? Int ?? 0
    }

    // MARK: - Coordinated file access

    private func coordinatedCopy(from source: URL, to destination: URL) throws {
        var coordinationError: NSError?
        var operationError: Error?
        NSFileCoordinator(filePresenter: nil).coordinate(
            readingItemAt: source,
            options: [],
            writingItemAt: destination,
            options: .forReplacing,
            error: &coordinationError
        ) { readURL, writeURL in
            do {
                if FileManager.default.fileExists(atPath: writeURL.path) {
                    try FileManager.default.removeItem(at: writeURL)
                }
                try FileManager.default.copyItem(at: readURL, to: writeURL)
            } catch {
                operationError = error
            }
        }
        if let error = coordinationError ?? operationError { throw error }
    }

    private func coordinatedMove(from source: URL, to destination: URL) throws {
        var coordinationError: NSError?
        var operationError: Error?
        NSFileCoordinator(filePresenter: nil).coordinate(
            writingItemAt: source,
            options: .forMoving,
            writingItemAt: destination,
            options: .forReplacing,
            error: &coordinationError
        ) { sourceURL, destinationURL in
            do {
                try FileManager.default.moveItem(at: sourceURL, to: destinationURL)
            } catch {
                operationError = error
            }
        }
        if let error = coordinationError ?? operationError { throw error }
    }

    private func coordinatedDelete(_ url: URL) throws {
        var coordinationError: NSError?
        var operationError: Error?
        NSFileCoordinator(filePresenter: nil).coordinate(
            writingItemAt: url,
            options: .forDeleting,
            error: &coordinationError
        ) { deleteURL in
            do {
                try FileManager.default.removeItem(at: deleteURL)
            } catch {
                operationError = error
            }
        }
        if let error = coordinationError ?? operationError { throw error }
    }

    // MARK: - Channel plumbing

    private static let invalidArguments = FlutterError(
        code: "INVALID_ARGUMENTS",
        message: "Missing or invalid arguments",
        details: nil
    )

    private func run(_ result: @escaping FlutterResult, _ work: @escaping () throws -> Any?) {
        queue.async {
            let value: Any?
            do {
                value = try work()
            } catch let error as PluginError {
                value = FlutterError(code: error.code, message: error.message, details: nil)
            } catch {
                value = FlutterError(code: "FAILED", message: error.localizedDescription, details: nil)
            }
            DispatchQueue.main.async { result(value) }
        }
    }

    /// Like [run], but keeps the app alive long enough to finish when it is
    /// being backgrounded, which is when most backups start.
    private func runInBackgroundTask(_ result: @escaping FlutterResult, _ work: @escaping () throws -> Any?) {
        var task: UIBackgroundTaskIdentifier = .invalid
        task = UIApplication.shared.beginBackgroundTask(withName: "iCloudBackup") {
            UIApplication.shared.endBackgroundTask(task)
            task = .invalid
        }
        run({ value in
            result(value)
            if task != .invalid {
                UIApplication.shared.endBackgroundTask(task)
                task = .invalid
            }
        }, work)
    }
}

private struct PluginError: Error {
    let code: String
    let message: String
}
