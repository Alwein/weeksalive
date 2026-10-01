import 'package:redux/redux.dart';
import 'package:weeksalive/data/tiktok_events/tiktok_events_repository.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/attribution/attribution_actions.dart';

class AttributionMiddleware extends MiddlewareClass<AppState> {
  final TikTokEventsRepository tikTokEventsRepository;

  AttributionMiddleware({required this.tikTokEventsRepository});

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is AttPermissionResolvedAction) {
      await tikTokEventsRepository.onAttResolved();
    }
  }
}
