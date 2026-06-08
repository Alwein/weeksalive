import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/l10n/time_utils.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/profile/pages/edit_profile_form_controller.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/user/user_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';
import 'package:weeksalive/presentation/widgets/gender_picker.dart';
import 'package:weeksalive/presentation/widgets/lifespan_slider.dart';
import 'package:weeksalive/presentation/widgets/primary_appbar.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/show_custom_date_picker.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => const EditProfilePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: PrimaryAppBar(title: Strings.editProfilePageTitle),
      body: StoreConnector<AppState, User?>(
        converter: (store) => store.state.userState.userOrNull,
        builder: (context, user) {
          if (user == null) return const SizedBox.shrink();
          final controller = EditProfileFormController(
            originalName: user.name,
            originalDateOfBirth: user.dateOfBirth,
            originalGender: user.gender,
            originalLifespan: user.lifespan,
          );
          return _Form(controller: controller);
        },
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({
    required this.controller,
  });
  final EditProfileFormController controller;

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  EditProfileFormController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: Margins.spacingM),
          _EditProfileInput(
            title: Strings.editProfilePageName,
            input: _NameInput(
              initialValue: _controller.name,
              onChanged: _controller.setName,
            ),
          ),
          const _SectionDivider(),
          _EditProfileInput(
            title: Strings.editProfilePageDateOfBirth,
            input: _DateOfBirthInput(
              initialValue: _controller.dateOfBirth,
              onChanged: _controller.setDateOfBirth,
            ),
          ),
          const _SectionDivider(),
          _EditProfileInput(
            title: Strings.editProfilePageLifespan,
            input: _LifespanInput(
              initialValue: _controller.lifespan,
              min: _controller.currentAge,
              onChanged: _controller.setLifespan,
            ),
          ),
          const _SectionDivider(),
          _EditProfileInput(
            title: Strings.editProfilePageGender,
            input: _GenderInput(
              initialValue: _controller.gender,
              onChanged: _controller.setGender,
            ),
          ),
          const _SectionDivider(),
          PrimaryButton(
            text: Strings.saveChanges,
            onPressed: _controller.isDirty ? _saveChanges : null,
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(
      UpdateUserAction(
        name: _controller.name,
        dateOfBirth: _controller.dateOfBirth,
        gender: _controller.gender,
        lifespan: _controller.lifespan,
      ),
    );
    Navigator.pop(context);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.data);
  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyles.primaryMediumBold,
    );
  }
}

class _EditProfileInput extends StatelessWidget {
  const _EditProfileInput({required this.title, required this.input});
  final String title;
  final Widget input;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(title),
        const SizedBox(height: Margins.spacingBase),
        input,
      ],
    );
  }
}

class _NameInput extends StatefulWidget {
  const _NameInput({required this.initialValue, required this.onChanged});
  final String initialValue;
  final void Function(String) onChanged;

  @override
  State<_NameInput> createState() => _NameInputState();
}

class _NameInputState extends State<_NameInput> {
  late final TextEditingController _textController;
  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      textCapitalization: TextCapitalization.sentences,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: Strings.editProfilePageName,
        hintStyle: TextStyle(color: AppColors.contentSoft(context)),
        filled: true,
        fillColor: AppColors.bgSoft(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusBase),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Margins.spacingBase,
          vertical: Margins.spacingBase,
        ),
      ),
    );
  }
}

class _DateOfBirthInput extends StatefulWidget {
  const _DateOfBirthInput({required this.initialValue, required this.onChanged});
  final DateTime initialValue;
  final void Function(DateTime) onChanged;

  @override
  State<_DateOfBirthInput> createState() => _DateOfBirthInputState();
}

class _DateOfBirthInputState extends State<_DateOfBirthInput> {
  final TextEditingController _textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _textController.text = formatToInput(widget.initialValue);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void selectDate() async {
    final newDate = await showCustomDatePicker(
      context,
      initialDate: widget.initialValue,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (newDate != null) {
      widget.onChanged(newDate);
      _textController.text = formatToInput(newDate);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      readOnly: true,
      onTap: selectDate,
      decoration: InputDecoration(
        hintText: Strings.editProfilePageDateOfBirth,
        hintStyle: TextStyle(color: AppColors.contentSoft(context)),
        filled: true,
        fillColor: AppColors.bgSoft(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusBase),
          borderSide: BorderSide.none,
        ),
        suffixIcon: Icon(MingCuteIcons.mgc_calendar_2_line, color: AppColors.contentSoft(context)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Margins.spacingBase,
          vertical: Margins.spacingBase,
        ),
      ),
    );
  }

  String formatToInput(DateTime date) {
    return TimeUtils.formatDate(context, date);
  }
}

class _GenderInput extends StatefulWidget {
  const _GenderInput({
    required this.initialValue,
    required this.onChanged,
  });

  final Gender initialValue;
  final ValueChanged<Gender> onChanged;

  @override
  State<_GenderInput> createState() => _GenderInputState();
}

class _GenderInputState extends State<_GenderInput> {
  late Gender _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GenderPicker(
      selectedGender: _selectedGender,
      onGenderSelected: (g) {
        setState(() => _selectedGender = g);
        widget.onChanged(g);
      },
    );
  }
}

class _LifespanInput extends StatefulWidget {
  const _LifespanInput({
    required this.initialValue,
    required this.min,
    required this.onChanged,
  });

  final int initialValue;
  final int min;
  final ValueChanged<int> onChanged;

  @override
  State<_LifespanInput> createState() => _LifespanInputState();
}

class _LifespanInputState extends State<_LifespanInput> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  void didUpdateWidget(_LifespanInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    final effectiveMin = widget.min.clamp(0, LifespanSlider.max - 1);
    if (_value < effectiveMin) {
      _value = effectiveMin;
      widget.onChanged(_value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LifespanSlider(
      value: _value,
      min: widget.min,
      label: Strings.value,
      onChanged: (v) {
        setState(() => _value = v);
        widget.onChanged(v);
      },
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: Margins.spacingM),
        SmallDivider(width: double.infinity),
        SizedBox(height: Margins.spacingM),
      ],
    );
  }
}
