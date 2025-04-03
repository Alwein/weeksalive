import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fast_template/core/dependency_injection/locator.dart';
import 'package:flutter_fast_template/presentation/onboarding/onboarding_page.dart';
import 'package:flutter_fast_template/presentation/onboarding/wrapper/bloc/onboarding_wrapper_bloc.dart';

class OnboardingWrapper extends StatefulWidget {
  const OnboardingWrapper({super.key, required this.child});
  final Widget child;

  @override
  State<OnboardingWrapper> createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends State<OnboardingWrapper> {
  late OnboardingWrapperBloc onboardingWrapperBloc;

  @override
  initState() {
    super.initState();
    onboardingWrapperBloc = Locator.get<OnboardingWrapperBloc>()..add(const OnboardingWrapperEvent.init());
  }

  @override
  void dispose() {
    onboardingWrapperBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: onboardingWrapperBloc,
      child: BlocListener<OnboardingWrapperBloc, OnboardingWrapperState>(
        listener: (context, state) {
          if (state.shouldShowOnboarding) {
            Navigator.of(context).push(OnboardingPage.route()).then((value) {
              onboardingWrapperBloc.add(const OnboardingWrapperEvent.completeOnboarding());
            });
          }
        },
        child: widget.child,
      ),
    );
  }
}
