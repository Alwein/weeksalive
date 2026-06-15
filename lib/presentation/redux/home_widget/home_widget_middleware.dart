import 'package:redux/redux.dart';
import 'package:weeksalive/data/home_widget/home_widget_service.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/day/day_actions.dart';
import 'package:weeksalive/presentation/redux/home_widget/home_widget_actions.dart';
import 'package:weeksalive/presentation/redux/theme/theme_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';

/// Re-renders the home-screen widgets whenever the data they display changes:
/// the user profile, recorded days, or the selected theme.
///
/// Runs after the reducer (it calls `next(action)` first), so it reads the
/// already-updated store state.
class HomeWidgetMiddleware extends MiddlewareClass<AppState> {
  final HomeWidgetService homeWidgetService;

  HomeWidgetMiddleware({required this.homeWidgetService});

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    next(action);

    final shouldRefresh = action is DaysLoadedAction ||
        action is SaveDayAction ||
        action is DeleteDayAction ||
        action is UserLoadedAction ||
        action is AppThemeLoadedAction ||
        action is RefreshHomeWidgetsAction;

    if (shouldRefresh) {
      _refresh(store);
    }
  }

  void _refresh(Store<AppState> store) {
    homeWidgetService.updateAll(
      user: store.state.userState.userOrNull,
      entries: store.state.dayState.entries.values,
      selectedTheme: store.state.themeState.selectedTheme,
    );
  }
}
