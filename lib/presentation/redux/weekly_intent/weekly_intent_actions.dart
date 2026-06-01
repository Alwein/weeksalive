import 'package:weeksalive/presentation/redux/weekly_intent/weekly_intent_state.dart';

class WeeklyIntentLoadedAction {
  final WeeklyIntentState state;
  const WeeklyIntentLoadedAction(this.state);
}

class ToggleWeeklyIntentAction {
  final List<String> ids;
  const ToggleWeeklyIntentAction(this.ids);
}

class AddWeeklyIntentAction {
  final String label;
  const AddWeeklyIntentAction(this.label);
}

class RemoveWeeklyIntentAction {
  final String id;
  const RemoveWeeklyIntentAction(this.id);
}

class SetWeekKeyAction {
  final String weekKey;
  const SetWeekKeyAction(this.weekKey);
}
