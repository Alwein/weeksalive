import 'package:weeksalive/core/app_icon/app_icon_id.dart';

class SetAppIconAction {
  final AppIconId iconId;
  const SetAppIconAction(this.iconId);
}

class AppIconLoadedAction {
  final AppIconId selectedIcon;
  final Set<AppIconId> unlockedIcons;
  const AppIconLoadedAction({
    required this.selectedIcon,
    required this.unlockedIcons,
  });
}

class AppIconsUnlockedAction {
  final Set<AppIconId> unlockedIcons;
  const AppIconsUnlockedAction(this.unlockedIcons);
}
