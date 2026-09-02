import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/wallpaper/wallpaper_actions.dart';
import 'package:weeksalive/presentation/wallpaper/wallpaper_editor_page.dart';
import 'package:weeksalive/presentation/wallpaper/wallpaper_prompt_sheet.dart';

/// Shows the one-time wallpaper setup nudge once the middleware flags it as
/// pending (see [WallpaperPromptRequestedAction]).
class WallpaperPromptListener extends StatefulWidget {
  const WallpaperPromptListener({super.key, required this.child});

  final Widget child;

  @override
  State<WallpaperPromptListener> createState() => _WallpaperPromptListenerState();
}

class _WallpaperPromptListenerState extends State<WallpaperPromptListener> {
  bool _shown = false;

  void _tryShow(Store<AppState> store, {required bool pending}) {
    if (_shown || !pending) return;

    _shown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final accepted = await WallpaperPromptSheet.show(context);

      try {
        store.dispatch(WallpaperPromptResolvedAction(accepted: accepted == true));
      } catch (_) {
        // Store torn down during the async gap.
      }

      if (accepted == true && mounted) {
        await WallpaperEditorPage.show(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
      converter: (store) => store.state.wallpaperState.promptPending,
      distinct: true,
      onInitialBuild: (pending) => _tryShow(StoreProvider.of<AppState>(context), pending: pending),
      onWillChange: (previous, next) {
        if (next && previous != true) {
          _tryShow(StoreProvider.of<AppState>(context), pending: next);
        }
      },
      builder: (context, _) => widget.child,
    );
  }
}
