import 'package:weeksalive/core/app_icon/app_icon_id.dart';

class AppIconState {
  final AppIconId selectedIcon;
  final Set<AppIconId> unlockedIcons;

  const AppIconState({
    this.selectedIcon = AppIconId.defaultIcon,
    Set<AppIconId>? unlockedIcons,
  }) : unlockedIcons = unlockedIcons ?? const {AppIconId.defaultIcon, AppIconId.light};

  AppIconState copyWith({
    AppIconId? selectedIcon,
    Set<AppIconId>? unlockedIcons,
  }) {
    return AppIconState(
      selectedIcon: selectedIcon ?? this.selectedIcon,
      unlockedIcons: unlockedIcons ?? this.unlockedIcons,
    );
  }
}
