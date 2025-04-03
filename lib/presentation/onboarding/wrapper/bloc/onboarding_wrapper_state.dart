part of 'onboarding_wrapper_bloc.dart';

@freezed
class OnboardingWrapperState with _$OnboardingWrapperState {
  const factory OnboardingWrapperState({@Default(false) bool shouldShowOnboarding}) = _OnboardingWrapperState;
}
