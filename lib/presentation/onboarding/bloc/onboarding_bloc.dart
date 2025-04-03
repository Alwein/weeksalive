import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_bloc.freezed.dart';
part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState()) {
    on<OnboardingEvent>(
      (event, emit) => event.map(
        pageChanged: (event) => _onPageChanged(event, emit),
      ),
    );
  }

  _onPageChanged(_PageChanged event, Emitter<OnboardingState> emit) {
    final currentPage = OnboardingPageIndex.values[event.index];
    emit(state.copyWith(currentPage: currentPage));
  }
}
