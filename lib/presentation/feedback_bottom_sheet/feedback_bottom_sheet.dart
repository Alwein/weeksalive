import 'package:flutter/material.dart';
import 'package:flutter_fast_template/core/dependency_injection/locator.dart';
import 'package:flutter_fast_template/core/styles/app_colors.dart';
import 'package:flutter_fast_template/core/styles/dimens.dart';
import 'package:flutter_fast_template/core/styles/margins.dart';
import 'package:flutter_fast_template/core/styles/text_styles.dart';
import 'package:flutter_fast_template/core/texts/strings.dart';
import 'package:flutter_fast_template/data/feedback/create_feedback_request.dart';
import 'package:flutter_fast_template/data/feedback/feedback_repository.dart';
import 'package:flutter_fast_template/presentation/auth/bloc/auth_bloc.dart';
import 'package:flutter_fast_template/presentation/widgets/custom_text_field.dart';
import 'package:flutter_fast_template/presentation/widgets/form_title.dart';
import 'package:flutter_fast_template/presentation/widgets/primary_button.dart';
import 'package:flutter_fast_template/presentation/widgets/show_custom_bottom_sheet.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

class FeedbackBottomSheet extends StatefulWidget {
  const FeedbackBottomSheet({super.key});

  static Future<void> show(BuildContext context) async {
    return showCustomBottomSheet(
      context,
      (_) => const FeedbackBottomSheet(),
    );
  }

  @override
  State<FeedbackBottomSheet> createState() => _FeedbackBottomSheetState();
}

class _FeedbackBottomSheetState extends State<FeedbackBottomSheet> {
  bool showConfirmation = false;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedSwitcher(
                duration: AnimationDurations.short,
                child: showConfirmation
                    ? const _Confirmation()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FormTitle(text: Strings.inAppFeedbackTitle, icon: MingCuteIcons.mgc_pencil_fill),
                          const SizedBox(height: Margins.spacingS),
                          Text(
                            Strings.inAppFeedbackSubtitle,
                            style: TextStyles.primaryXSRegular.copyWith(color: AppColors.content(context)),
                          ),
                          const SizedBox(height: Margins.spacingBase),
                          CustomTextField(
                            controller: textController,
                            autofocus: true,
                            hintText: Strings.inAppFeedbackHint,
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                          const SizedBox(height: Margins.spacingBase),
                          PrimaryButton(
                            onPressed: textController.text.isEmpty
                                ? null
                                : () {
                                    Locator.get<FeedbackRepository>().uploadFeedback(
                                      CreateFeedbackRequest(
                                        userId: Locator.get<AuthBloc>().state.userIdOrNull() ?? '',
                                        positive: false,
                                        suggestions: textController.text,
                                      ),
                                    );

                                    setState(() {
                                      showConfirmation = true;
                                    });
                                  },
                            text: Strings.done,
                          ),
                          const SizedBox(height: Margins.spacingM),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Confirmation extends StatelessWidget {
  const _Confirmation();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: Margins.spacingL),

            Row(
              children: [
                const SuccessIcon(size: Dimens.iconSizeL, padding: EdgeInsets.all(Margins.spacingS)),
                const SizedBox(width: Margins.spacingBase),
                Expanded(
                  child: Text(
                    Strings.inAppFeedbackConfirmationTitle,
                    style: TextStyles.primaryLargeMedium.copyWith(color: AppColors.content(context)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Margins.spacingXl),
          ],
        ),
      ],
    );
  }
}

class SuccessIcon extends StatelessWidget {
  const SuccessIcon({super.key, required this.size, required this.padding});
  final double size;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.greenSuccess.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(MingCuteIcons.mgc_check_fill, size: size, color: AppColors.greenSuccess),
    );
  }
}
