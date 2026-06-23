import 'dart:io';

import 'package:redux/redux.dart';
import 'package:weeksalive/core/app_icon/app_icon_id.dart';
import 'package:weeksalive/data/app_icon/app_icon_repository.dart';
import 'package:weeksalive/data/app_icon/app_icon_service.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';
import 'package:weeksalive/presentation/redux/app_icon/app_icon_actions.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/redux/rewards/rewards_actions.dart';

class AppIconMiddleware extends MiddlewareClass<AppState> {
  AppIconMiddleware({
    required this.appIconRepository,
    AppIconService? appIconService,
  }) : _appIconService = appIconService ?? AppIconService();

  final AppIconRepository appIconRepository;
  final AppIconService _appIconService;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is BootstrapAction) {
      final selectedIcon = await appIconRepository.getSelectedIcon();
      if (Platform.isAndroid) {
        await _appIconService.setIcon(selectedIcon);
      }
      try {
        store.dispatch(
          AppIconLoadedAction(
            selectedIcon: selectedIcon,
            unlockedIcons: store.state.appIconState.unlockedIcons,
          ),
        );
      } catch (_) {
        // Store torn down (e.g. in tests) during the async gap.
      }
    }

    if (action is SetAppIconAction) {
      if (!store.state.appIconState.unlockedIcons.contains(action.iconId)) return;
      await appIconRepository.setSelectedIcon(action.iconId);
      await _appIconService.setIcon(action.iconId);
      try {
        store.dispatch(
          AppIconLoadedAction(
            selectedIcon: action.iconId,
            unlockedIcons: store.state.appIconState.unlockedIcons,
          ),
        );
      } catch (_) {
        // Store torn down (e.g. in tests) during the async gap.
      }
    }

    if (action is RewardsLoadedAction) {
      final unlockedIcons = {
        ...AppIconId.alwaysUnlocked,
        ...rewardIdsToAppIconIds(action.unlocked),
      };
      final selected = store.state.appIconState.selectedIcon;
      try {
        store.dispatch(AppIconsUnlockedAction(unlockedIcons));
        if (!unlockedIcons.contains(selected)) {
          await appIconRepository.setSelectedIcon(AppIconId.composer);
          await _appIconService.setIcon(AppIconId.composer);
          store.dispatch(
            AppIconLoadedAction(
              selectedIcon: AppIconId.composer,
              unlockedIcons: unlockedIcons,
            ),
          );
        }
      } catch (_) {
        // Store torn down (e.g. in tests) during the async gap.
      }
    }
  }
}
