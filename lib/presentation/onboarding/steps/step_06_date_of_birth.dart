import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_form_controller.dart';
import 'package:weeksalive/presentation/onboarding/onboarding_scope.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_staggered_animations.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class Step06DateOfBirth extends OnboardingStep {
  const Step06DateOfBirth();

  @override
  String primaryLabel(BuildContext context) => Strings.continueString;

  @override
  bool canContinue(OnboardingFormController controller) => controller.dateOfBirth != null;

  @override
  Widget buildContent(BuildContext context) => const _Step06DateOfBirthContent();
}

class _Step06DateOfBirthContent extends StatefulWidget {
  const _Step06DateOfBirthContent();

  @override
  State<_Step06DateOfBirthContent> createState() => _Step06DateOfBirthContentState();
}

class _Step06DateOfBirthContentState extends State<_Step06DateOfBirthContent> {
  late final FileLoader _fileLoader;

  ViewModelInstance? _vmi;
  Brightness? _lastBrightness;

  @override
  void initState() {
    super.initState();
    _fileLoader = FileLoader.fromAsset(
      "assets/animations/outline_birth.riv",
      riveFactory: Factory.flutter,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = Theme.of(context).brightness;
    if (_lastBrightness != brightness) {
      _lastBrightness = brightness;
      _applyTheme(brightness);
    }
  }

  @override
  void dispose() {
    _vmi?.dispose();
    _fileLoader.dispose();
    super.dispose();
  }

  void _onRiveLoaded(RiveWidgetController riveController) {
    _vmi = riveController.dataBind(DataBind.auto());
    if (_lastBrightness != null) {
      _applyTheme(_lastBrightness!);
    }
  }

  void _applyTheme(Brightness brightness) {
    final vmi = _vmi;
    if (vmi == null) return;
    final isDark = brightness == Brightness.dark;
    final color = isDark ? AppColors.content(context) : AppColors.contentSoft(context);
    vmi.color('theme')?.value = color;
  }

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingScope.of(context);
    final date = controller.dateOfBirth;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: RiveWidgetBuilder(
                fileLoader: _fileLoader,
                onLoaded: (state) => _onRiveLoaded(state.controller),
                builder: (context, state) => switch (state) {
                  RiveLoading() => const SizedBox.expand(),
                  RiveFailed() => const SizedBox.shrink(),
                  RiveLoaded(:final controller) => RiveWidget(
                    controller: controller,
                    fit: Fit.contain,
                  ),
                },
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: OnboardingStaggeredColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Texts.xlBold(Strings.onboarding06Title),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: Margins.spacingM),
                      Texts.primaryMediumSoft(
                        context,
                        Strings.onboarding06Subtitle,
                      ),
                      const SizedBox(height: Margins.spacingM),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Texts.primaryMedium(Strings.onboarding06DateOfBirth),
                      const SizedBox(height: Margins.spacingS),
                      _DateOfBirthPicker(
                        value: date,
                        onChanged: controller.setDateOfBirth,
                      ),
                      const SizedBox(height: Margins.spacingM),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateOfBirthPicker extends StatefulWidget {
  const _DateOfBirthPicker({required this.value, required this.onChanged});

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  @override
  State<_DateOfBirthPicker> createState() => _DateOfBirthPickerState();
}

class _DateOfBirthPickerState extends State<_DateOfBirthPicker> {
  static final DateTime _initialDate = DateTime(1995);
  static final DateTime _firstDate = DateTime(1900);
  static final DateTime _lastDate = DateTime.now();

  late final FixedExtentScrollController _scrollController;
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.value ?? _initialDate;
    _scrollController = FixedExtentScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.strokeColor(context),
        borderRadius: BorderRadius.circular(Dimens.radiusBase),
      ),
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: _selected,
        minimumDate: _firstDate,
        maximumDate: _lastDate,
        onDateTimeChanged: (date) {
          _selected = date;
          widget.onChanged(date);
        },
      ),
    );
  }
}
