part of 'onboarding_wrapper_bloc.dart';

@freezed
class OnboardingWrapperEvent with _$OnboardingWrapperEvent {
  const factory OnboardingWrapperEvent.init() = _Init;
  const factory OnboardingWrapperEvent.completeOnboarding() = _CompleteOnboarding;
}
