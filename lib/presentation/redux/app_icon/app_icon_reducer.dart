import 'package:weeksalive/core/app_icon/app_icon_id.dart';
import 'package:weeksalive/presentation/redux/app_icon/app_icon_actions.dart';
import 'package:weeksalive/presentation/redux/app_icon/app_icon_state.dart';

AppIconState appIconReducer(AppIconState state, dynamic action) {
  if (action is AppIconLoadedAction) {
    final selected = action.unlockedIcons.contains(action.selectedIcon)
        ? action.selectedIcon
        : AppIconId.composer;
    return state.copyWith(
      selectedIcon: selected,
      unlockedIcons: action.unlockedIcons,
    );
  }

  if (action is SetAppIconAction) {
    if (!state.unlockedIcons.contains(action.iconId)) return state;
    return state.copyWith(selectedIcon: action.iconId);
  }

  if (action is AppIconsUnlockedAction) {
    final unlocked = {...action.unlockedIcons, ...AppIconId.alwaysUnlocked};
    final selected = unlocked.contains(state.selectedIcon) ? state.selectedIcon : AppIconId.composer;
    return state.copyWith(unlockedIcons: unlocked, selectedIcon: selected);
  }

  return state;
}
