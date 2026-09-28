import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/domain/feedback/feedback_sentiment.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/review_prompt/review_prompt_actions.dart';
import 'package:weeksalive/presentation/widgets/custom_text_field.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/show_custom_bottom_sheet.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

/// How the feedback sheet was closed.
enum FeedbackSheetResult {
  /// Closed before any answer.
  dismissed,

  /// The user answered the pulse positively: the caller asks for a store review.
  positive,

  /// The user answered the pulse negatively or neutrally (and may have sent a message).
  answered,
}

/// In-app feedback, in two steps: a one-tap pulse, then a free-text form for
/// users who are not fully satisfied. A positive answer closes the sheet so the
/// caller can ask for the native store review.
///
/// With [openForm], the pulse is skipped (used from the profile, where the user
/// explicitly chose to write to us).
class FeedbackSheet extends StatefulWidget {
  const FeedbackSheet._({required this.source, required this.openForm, required this.onResult});

  final String source;
  final bool openForm;
  final ValueChanged<FeedbackSheetResult> onResult;

  static Future<FeedbackSheetResult> show(
    BuildContext context, {
    required String source,
    bool openForm = false,
  }) async {
    // The sheet reports its outcome as it goes rather than through the pop
    // result, so that closing it with the close button or a drag after
    // answering still counts as answered.
    var result = FeedbackSheetResult.dismissed;
    await showCustomBottomSheet<void>(
      context,
      (context) => FeedbackSheet._(source: source, openForm: openForm, onResult: (value) => result = value),
    );
    return result;
  }

  @override
  State<FeedbackSheet> createState() => _FeedbackSheetState();
}

enum _Step { pulse, form, thanks }

class _FeedbackSheetState extends State<FeedbackSheet> {
  static const _maxMessageLength = 1000;

  late _Step _step = widget.openForm ? _Step.form : _Step.pulse;
  FeedbackSentiment? _sentiment;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSentiment(FeedbackSentiment sentiment) {
    SensorialFeedback.selectionChanged();
    StoreProvider.of<AppState>(context, listen: false).dispatch(
      FeedbackPulseAnsweredAction(sentiment: sentiment, source: widget.source),
    );

    if (sentiment == FeedbackSentiment.positive) {
      widget.onResult(FeedbackSheetResult.positive);
      Navigator.of(context).pop();
      return;
    }
    widget.onResult(FeedbackSheetResult.answered);
    setState(() {
      _sentiment = sentiment;
      _step = _Step.form;
    });
  }

  void _onSend() {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    FocusScope.of(context).unfocus();
    StoreProvider.of<AppState>(context, listen: false).dispatch(
      FeedbackSubmittedAction(message: message, source: widget.source, sentiment: _sentiment),
    );
    widget.onResult(FeedbackSheetResult.answered);
    setState(() => _step = _Step.thanks);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: AnimatedSize(
        duration: AnimationDurations.short,
        alignment: Alignment.topCenter,
        child: switch (_step) {
          _Step.pulse => _PulseStep(onSelected: _onSentiment),
          _Step.form => _FormStep(
              sentiment: _sentiment,
              controller: _controller,
              maxLength: _maxMessageLength,
              onSend: _controller.text.trim().isEmpty ? null : _onSend,
            ),
          _Step.thanks => _ThanksStep(onClose: () => Navigator.of(context).pop()),
        },
      ),
    );
  }
}

class _PulseStep extends StatelessWidget {
  const _PulseStep({required this.onSelected});

  final ValueChanged<FeedbackSentiment> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('feedback_pulse'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Texts.xlBold(Strings.feedbackPulseTitle),
        const SizedBox(height: Margins.spacingS),
        Texts.primaryMediumSoft(context, Strings.feedbackPulseBody),
        const SizedBox(height: Margins.spacingM),
        Row(
          children: [
            Expanded(
              child: _SentimentButton(
                emoji: '😕',
                label: Strings.feedbackPulseNegative,
                onTap: () => onSelected(FeedbackSentiment.negative),
              ),
            ),
            const SizedBox(width: Margins.spacingS),
            Expanded(
              child: _SentimentButton(
                emoji: '😐',
                label: Strings.feedbackPulseNeutral,
                onTap: () => onSelected(FeedbackSentiment.neutral),
              ),
            ),
            const SizedBox(width: Margins.spacingS),
            Expanded(
              child: _SentimentButton(
                emoji: '😍',
                label: Strings.feedbackPulsePositive,
                onTap: () => onSelected(FeedbackSentiment.positive),
              ),
            ),
          ],
        ),
        const SizedBox(height: Margins.spacingM),
      ],
    );
  }
}

class _SentimentButton extends StatelessWidget {
  const _SentimentButton({required this.emoji, required this.label, required this.onTap});

  final String emoji;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: AppColors.bgSoft(context),
        borderRadius: BorderRadius.circular(Dimens.radiusBase),
        child: InkWell(
          borderRadius: BorderRadius.circular(Dimens.radiusBase),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Margins.spacingBase, horizontal: Margins.spacingXs),
            child: Column(
              children: [
                ExcludeSemantics(child: Text(emoji, style: const TextStyle(fontSize: 32))),
                const SizedBox(height: Margins.spacingS),
                Texts.primaryXsMediumSoft(context, label, textAlign: TextAlign.center, maxLines: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormStep extends StatelessWidget {
  const _FormStep({
    required this.sentiment,
    required this.controller,
    required this.maxLength,
    required this.onSend,
  });

  final FeedbackSentiment? sentiment;
  final TextEditingController controller;
  final int maxLength;
  final VoidCallback? onSend;

  @override
  Widget build(BuildContext context) {
    final title = switch (sentiment) {
      FeedbackSentiment.negative => Strings.feedbackFormTitleNegative,
      FeedbackSentiment.neutral => Strings.feedbackFormTitleNeutral,
      _ => Strings.feedbackFormTitleOpen,
    };
    return Column(
      key: const ValueKey('feedback_form'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Texts.xlBold(title),
        const SizedBox(height: Margins.spacingS),
        Texts.primaryMediumSoft(context, Strings.feedbackFormBody),
        const SizedBox(height: Margins.spacingM),
        CustomTextField(
          controller: controller,
          hintText: Strings.feedbackFormHint,
          autofocus: true,
          minLines: 4,
          maxLines: 8,
          maxLength: maxLength,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: Margins.spacingS),
        PrimaryButton(text: Strings.feedbackFormSend, onPressed: onSend),
        const SizedBox(height: Margins.spacingM),
      ],
    );
  }
}

class _ThanksStep extends StatelessWidget {
  const _ThanksStep({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('feedback_thanks'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Texts.xlBold(Strings.feedbackThanksTitle),
        const SizedBox(height: Margins.spacingS),
        Texts.primaryMediumSoft(context, Strings.feedbackThanksBody),
        const SizedBox(height: Margins.spacingM),
        PrimaryButton(text: Strings.done, onPressed: onClose),
        const SizedBox(height: Margins.spacingM),
      ],
    );
  }
}
