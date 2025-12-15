import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fast_template/core/styles/app_colors.dart';
import 'package:flutter_fast_template/core/styles/margins.dart';
import 'package:flutter_fast_template/core/texts/strings.dart';
import 'package:flutter_fast_template/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:flutter_fast_template/presentation/onboarding/widgets/onboarding_step_1.dart';
import 'package:flutter_fast_template/presentation/onboarding/widgets/onboarding_step_2.dart';
import 'package:flutter_fast_template/presentation/onboarding/widgets/onboarding_step_3.dart';
import 'package:flutter_fast_template/presentation/widgets/primary_button.dart';
import 'package:flutter_fast_template/presentation/widgets/texts.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => const OnboardingPage(),
      settings: const RouteSettings(name: 'OnboardingPage'),
    );
  }

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final CarouselSliderController _carouselController;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc(),
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.getBackgroundColor(context),
            floatingActionButton: PrimaryButton(
              backgroundColor: AppColors.content(context),
              textColor: Colors.white,
              text: switch (state.currentPage) {
                OnboardingPageIndex.third => Strings.done,
                _ => Strings.next,
              },
              icon: switch (state.currentPage) {
                OnboardingPageIndex.third => Icons.check,
                _ => Icons.arrow_forward,
              },
              iconRight: true,
              onPressed: () {
                HapticFeedback.mediumImpact();
                final shouldFinishOnboarding = switch (state.currentPage) {
                  OnboardingPageIndex.third => true,
                  _ => false,
                };

                if (shouldFinishOnboarding) {
                  Navigator.of(context).pop();
                } else {
                  _carouselController.nextPage();
                }
              },
            ),
            body: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                _Stepper(),
                const SizedBox(height: Margins.spacingM),
                Expanded(
                  child: CarouselSlider(
                    carouselController: _carouselController,
                    items: const [
                      OnboardingStep1(key: ValueKey("step_0")),
                      OnboardingStep2(key: ValueKey("step_1")),
                      OnboardingStep3(key: ValueKey("step_2")),
                    ],
                    options: CarouselOptions(
                      height: double.infinity,
                      viewportFraction: 1,
                      enableInfiniteScroll: false,
                      disableCenter: true,
                      onPageChanged: (index, _) {
                        context.read<OnboardingBloc>().add(OnboardingEvent.pageChanged(index));
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final visibleSteps = switch (state.currentPage) {
          OnboardingPageIndex.first => 1,
          OnboardingPageIndex.second => 2,
          OnboardingPageIndex.third => 3,
        };
        final visiblesBars = switch (state.currentPage) {
          OnboardingPageIndex.first => 0,
          OnboardingPageIndex.second => 1,
          OnboardingPageIndex.third => 2,
        };
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _stepperBubbleIndex(context, 1, visibleSteps),
              const SizedBox(width: Margins.spacingS),
              _progressBar(context, 1, visiblesBars),
              const SizedBox(width: Margins.spacingS),
              _stepperBubbleIndex(context, 2, visibleSteps),
              const SizedBox(width: Margins.spacingS),
              _progressBar(context, 2, visiblesBars),
              const SizedBox(width: Margins.spacingS),
              _stepperBubbleIndex(context, 3, visibleSteps),
            ],
          ),
        );
      },
    );
  }

  Widget _stepperBubbleIndex(BuildContext context, int index, int currentIndex) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: index <= currentIndex ? AppColors.textColor(context) : Colors.grey,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Texts.primaryXsMedium("$index"),
      ),
    );
  }

  Widget _progressBar(BuildContext context, int index, int currentIndex) {
    return Expanded(
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          color: index <= currentIndex ? AppColors.textColor(context) : Colors.grey,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
