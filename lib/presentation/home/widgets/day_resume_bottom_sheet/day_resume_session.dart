import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/domain/day/day_entry.dart';

/// Horizontal pager state for the day resume sheet.
///
/// [offset] is in pixels. A positive value reveals the previous day (the finger
/// moved right); a negative value reveals the next day.
///
/// [date] follows the page covering most of the viewport: as soon as a
/// neighbour passes the middle it becomes [date] and [offset] shifts by one
/// page. A new swipe can therefore start from the right day while the previous
/// one is still settling, which lets the user flick through days quickly.
class DayResumeSession extends ChangeNotifier {
  DayResumeSession({
    required DateTime date,
    DateTime? earliestDate,
    DateTime Function()? now,
  }) : date = normalizeDay(date),
       earliestDate = earliestDate == null ? null : normalizeDay(earliestDate),
       _now = now ?? DateTime.now;

  DateTime date;
  final DateTime? earliestDate;
  final DateTime Function() _now;

  double offset = 0;
  double width = 0;
  bool isDragging = false;

  AnimationController? _controller;
  double? _settleTarget;

  /// Difference between [offset] and the controller value, grown each time the
  /// current day changes mid-settle so the spring never has to restart.
  double _settleShift = 0;

  /// Resting offset of the page the drag starts from: where the previous swipe
  /// was heading, or the page under the finger.
  double _dragAnchor = 0;

  /// [offset] when the drag began, in the current day's coordinates.
  double _dragOrigin = 0;

  static const _commitFraction = 0.25;
  static const _flingVelocity = 400.0;
  static const _edgeResistance = 0.16;
  static const _maxSettlePages = 2;

  static final SpringDescription _spring = SpringDescription.withDampingRatio(
    mass: 0.6,
    stiffness: 340,
    ratio: 1,
  );

  bool get canGoToPrevious {
    final earliest = earliestDate;
    if (earliest == null) return true;
    return date.isAfter(earliest);
  }

  bool get canGoToNext => date.isBefore(normalizeDay(_now()));

  DateTime? get previousDate => canGoToPrevious ? _shiftDay(date, -1) : null;

  DateTime? get nextDate => canGoToNext ? _shiftDay(date, 1) : null;

  /// Calendar days, so a DST change does not skip or repeat a date.
  static DateTime _shiftDay(DateTime date, int days) =>
      DateTime(date.year, date.month, date.day + days);

  void attach(TickerProvider vsync) {
    if (_controller != null) return;
    _controller = AnimationController.unbounded(vsync: vsync)
      ..addListener(_onTick);
  }

  void detach() => _releaseController();

  void updateWidth(double value) {
    if (value <= 0 || (value - width).abs() < 0.5) return;
    width = value;
  }

  /// Also called on pointer down, so touching the sheet catches a page that is
  /// still settling.
  void onDragStart() {
    if (isDragging) return;
    _dragAnchor = _settleTarget ?? _nearestPage();
    _settleTarget = null;
    _controller?.stop();
    isDragging = true;
    _dragOrigin = offset;
    notifyListeners();
  }

  void onDragUpdate(double deltaDx) {
    if (!isDragging || width <= 0) return;
    offset = _resisted(deltaDx);
    final shift = _recenter();
    _dragAnchor += shift;
    _dragOrigin += shift;
    notifyListeners();
  }

  void onDragEnd(double velocity) {
    if (!isDragging) return;
    isDragging = false;
    _beginSettle(_targetOffset(velocity), velocity);
  }

  void onDragCancel() {
    if (!isDragging) return;
    isDragging = false;
    _beginSettle(_nearestPage(), 0);
  }

  /// Applies [delta], damping the part that pulls past a missing neighbour.
  double _resisted(double delta) {
    final raw = offset + delta;
    if (delta > 0 && !canGoToPrevious && raw > 0) {
      final from = offset > 0 ? offset : 0.0;
      return from + (raw - from) * _edgeResistance;
    }
    if (delta < 0 && !canGoToNext && raw < 0) {
      final from = offset < 0 ? offset : 0.0;
      return from + (raw - from) * _edgeResistance;
    }
    return raw;
  }

  /// Makes the neighbour covering more than half the viewport the current
  /// day. Returns how much [offset] moved.
  double _recenter() {
    if (width <= 0) return 0;
    final half = width / 2;
    var shift = 0.0;
    while (offset + shift < -half && nextDate != null) {
      date = nextDate!;
      shift += width;
    }
    while (offset + shift > half && previousDate != null) {
      date = previousDate!;
      shift -= width;
    }
    if (shift != 0) {
      offset += shift;
      SensorialFeedback.navigationChanged();
    }
    return shift;
  }

  double _nearestPage() =>
      width <= 0 ? 0 : (offset / width).roundToDouble() * width;

  double _targetOffset(double velocity) {
    if (width <= 0) return 0;
    final displacement = offset - _dragOrigin;
    final double direction;
    if (velocity.abs() >= _flingVelocity) {
      direction = velocity.sign;
    } else if (displacement.abs() >= width * _commitFraction) {
      direction = displacement.sign;
    } else {
      direction = 0;
    }

    double target;
    if (direction == 0) {
      target = _nearestPage();
    } else {
      // Next resting position in the gesture's direction.
      final boundary =
          (offset / width + direction * 0.5).roundToDouble() * width;
      if (displacement.sign == direction) {
        // A swipe always moves one page from where the finger landed, even if
        // that page was still settling from the previous swipe.
        final fromAnchor = _dragAnchor + direction * width;
        target = direction < 0
            ? (fromAnchor < boundary ? fromAnchor : boundary)
            : (fromAnchor > boundary ? fromAnchor : boundary);
      } else {
        // The finger reversed before letting go: stop at the nearest page.
        target = boundary;
      }
    }

    final min = -_pagesAvailable(forward: true) * width;
    final max = _pagesAvailable(forward: false) * width;
    return target.clamp(min, max);
  }

  /// Days reachable from [date] in one settle, capped because a single swipe
  /// never moves more than [_maxSettlePages].
  int _pagesAvailable({required bool forward}) {
    final limit = forward ? normalizeDay(_now()) : earliestDate;
    if (limit == null) return _maxSettlePages;
    final days = forward
        ? _daysBetween(date, limit)
        : _daysBetween(limit, date);
    return days.clamp(0, _maxSettlePages);
  }

  static int _daysBetween(DateTime from, DateTime to) => DateTime.utc(
    to.year,
    to.month,
    to.day,
  ).difference(DateTime.utc(from.year, from.month, from.day)).inDays;

  void _beginSettle(double target, double velocity) {
    _settleTarget = target;
    _settleShift = 0;
    final controller = _controller;
    if (controller == null || (target - offset).abs() < 0.5) {
      _finishSettle();
      return;
    }
    final cappedVelocity = velocity.clamp(-4000.0, 4000.0);
    controller.animateWith(
      SpringSimulation(_spring, offset, target, cappedVelocity),
    );
  }

  void _onTick() {
    final controller = _controller;
    final target = _settleTarget;
    if (target == null || controller == null) return;
    if (controller.isCompleted) {
      _finishSettle();
      return;
    }
    offset = controller.value + _settleShift;
    final shift = _recenter();
    _settleShift += shift;
    _settleTarget = target + shift;
    notifyListeners();
  }

  void _finishSettle() {
    final target = _settleTarget;
    _settleTarget = null;
    if (target == null) return;
    offset = target;
    _recenter();
    offset = 0;
    notifyListeners();
  }

  void _releaseController() {
    _settleTarget = null;
    final controller = _controller;
    _controller = null;
    controller?.removeListener(_onTick);
    controller?.dispose();
  }

  @override
  void dispose() {
    _releaseController();
    super.dispose();
  }
}
