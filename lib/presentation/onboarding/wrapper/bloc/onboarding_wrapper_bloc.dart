import 'package:bloc/bloc.dart';
import 'package:flutter_fast_template/data/onboarding/onboarding_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_wrapper_bloc.freezed.dart';
part 'onboarding_wrapper_event.dart';
part 'onboarding_wrapper_state.dart';

class OnboardingWrapperBloc extends Bloc<OnboardingWrapperEvent, OnboardingWrapperState> {
  OnboardingWrapperBloc(this._onboardingRepository) : super(const OnboardingWrapperState()) {
    on<OnboardingWrapperEvent>(
      (event, emit) => event.map(
        init: (_) => _onInit(emit),
        completeOnboarding: (_) => _onCompleteOnboarding(emit),
      ),
    );
  }

  final OnboardingRepository _onboardingRepository;

  _onInit(Emitter<OnboardingWrapperState> emit) async {
    final shouldShowOnboarding = await _onboardingRepository.shouldShowOnboarding();
    emit(OnboardingWrapperState(shouldShowOnboarding: shouldShowOnboarding));
  }

  _onCompleteOnboarding(Emitter<OnboardingWrapperState> emit) async {
    await _onboardingRepository.setOnboardingDone();
    emit(const OnboardingWrapperState(shouldShowOnboarding: false));
  }
}
