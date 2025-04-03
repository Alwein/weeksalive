part of 'onboarding_bloc.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(OnboardingPageIndex.first) OnboardingPageIndex currentPage,
  }) = _OnboardingState;
}

enum OnboardingPageIndex {
  first,
  second,
  third,
}
