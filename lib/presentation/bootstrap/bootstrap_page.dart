import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/presentation/bootstrap/view_model/bootstrap_page_view_model.dart';
import 'package:weeksalive/presentation/home/home_page.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_page.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/bootstrap/bootstrap_actions.dart';
import 'package:weeksalive/presentation/splash/splas_page.dart';

class BootstrapPage extends StatelessWidget {
  const BootstrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BootstrapPageViewModel>(
      converter: BootstrapPageViewModel.create,
      onInit: (store) => store.dispatch(BootstrapAction()),
      builder: (context, viewModel) {
        return AnimatedSwitcher(
          duration: AnimationDurations.base,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: switch (viewModel.redirect) {
            BootstrapPageRedirect.splash => const SplashPage(),
            BootstrapPageRedirect.onboarding => const OnboardingPage(),
            BootstrapPageRedirect.home => const MyHomePage(title: 'Home'),
          },
        );
      },
    );
  }
}
