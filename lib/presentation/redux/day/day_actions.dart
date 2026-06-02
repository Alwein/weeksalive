import 'package:weeksalive/domain/day/day_entry.dart';

class DaysLoadedAction {
  final List<DayEntry> entries;
  const DaysLoadedAction(this.entries);
}

class SaveDayAction {
  final DayEntry entry;
  const SaveDayAction(this.entry);
}
