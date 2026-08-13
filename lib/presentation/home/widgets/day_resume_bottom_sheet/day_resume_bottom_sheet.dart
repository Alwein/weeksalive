import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/l10n/time_utils.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/day_form/day_form.dart';
import 'package:weeksalive/presentation/home/widgets/day_resume_bottom_sheet/day_resume_bottom_sheet_view_model.dart';
import 'package:weeksalive/presentation/home/widgets/day_summaries.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/onboarding/widgets/parallax_rive.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/widgets/circle.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/show_custom_bottom_sheet.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class DayResumeBottomSheet extends StatelessWidget {
  const DayResumeBottomSheet({super.key, required this.date});
  final DateTime date;

  static Future<void> show(BuildContext context, {required DateTime date}) {
    return showCustomBottomSheet<void>(
      context,
      (sheetContext) => DayResumeBottomSheet(date: date),
      previewBuilder: (context) => _FilePreview(date: date),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DayResumeBottomSheetViewModel>(
      converter: (store) => DayResumeBottomSheetViewModel.create(store, date),
      builder: (context, viewModel) {
        return switch (viewModel) {
          DayResumeBottomSheetViewModelEmpty() => _EmptyDayContent(date: date),
          DayResumeBottomSheetViewModelFilled() => _FilledDayContent(viewModel: viewModel),
          DayResumeBottomSheetViewModel() => throw UnimplementedError(),
        };
      },
    );
  }
}

class _EmptyDayContent extends StatelessWidget {
  const _EmptyDayContent({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Circle(color: AppColors.strokeColor(context), size: Dimens.iconSizeM),
          const SizedBox(height: Margins.spacingM),
          Text(
            TimeUtils.formatDate(context, date),
            textAlign: TextAlign.center,
            style: TextStyles.primarySemiBold.copyWith(
              color: AppColors.content(context),
            ),
          ),
          const SizedBox(height: Margins.spacingS),
          Text(
            Strings.dayResumeBottomSheetEmptySubtitle,
            textAlign: TextAlign.center,
            style: TextStyles.primaryRegularMedium.copyWith(
              color: AppColors.contentSoft(context),
            ),
          ),
          const SizedBox(height: Margins.spacingM),
          const SizedBox(
            height: 160,
            child: OverflowBox(
              maxHeight: 220,
              alignment: Alignment.bottomCenter,
              child: ParallaxRive(
                maxOffset: 0,
                assetPath: "assets/animations/outline_looking_up.riv",
              ),
            ),
          ),
          PrimaryButton(
            text: Strings.startTracking,
            onPressed: () {
              Navigator.of(context).pop();
              DayForm.showBottomSheet(context, date, source: 'calendar');
            },
          ),
          const SizedBox(height: Margins.spacingM),
        ],
      ),
    );
  }
}

class _FilledDayContent extends StatelessWidget {
  const _FilledDayContent({required this.viewModel});
  final DayResumeBottomSheetViewModelFilled viewModel;

  @override
  Widget build(BuildContext context) {
    final leaveATraceText = viewModel.entry.leaveATrace.text;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: Margins.spacingM),
          if (viewModel.entry.leaveATrace.imagePaths.isNotEmpty) ...[
            const SizedBox(height: Margins.spacingL),
          ],
          if (viewModel.entry.leaveATrace.text.isNotEmpty) ...[
            _Description(leaveATraceText: leaveATraceText),
            const SizedBox(height: Margins.spacingM),
          ],
          _CardEntry(viewModel: viewModel),
          const SizedBox(height: Margins.spacingM),
          PrimaryButton(
            text: Strings.edit,
            onPressed: () {
              Navigator.of(context).pop();
              DayForm.showBottomSheet(context, viewModel.entry.date, source: 'resume');
            },
          ),
          const SizedBox(height: Margins.spacingM),
        ],
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({
    required this.leaveATraceText,
  });

  final String leaveATraceText;

  @override
  Widget build(BuildContext context) {
    return Text(
      '"$leaveATraceText"',
      style: TextStyles.primaryMediumMedium.copyWith(color: AppColors.content(context)),
    );
  }
}

class _CardEntry extends StatelessWidget {
  const _CardEntry({required this.viewModel});
  final DayResumeBottomSheetViewModelFilled viewModel;

  @override
  Widget build(BuildContext context) {
    final entry = viewModel.entry;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radiusL),
        border: Border.all(color: AppColors.strokeColor(context), width: Dimens.strokeWidthS),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DayHeader(
            circleSize: _sizeLevelToCircleSize(entry.sizeLevel),
            dayCount: viewModel.dayCount,
            date: entry.date,
          ),
          _DaySection(
            index: '01',
            title: Strings.feelingSectionTitle,
            summary: entry.averageFeeling != null
                ? FeelingSummary(value: entry.averageFeeling!)
                : const _EmptySummary(),
          ),

          _DaySection(
            index: '02',
            title: Strings.meaningSectionTitle,
            summary: entry.meaningScore != null ? MeaningSummary(value: entry.meaningScore!) : const _EmptySummary(),
          ),

          _DaySection(
            index: '03',
            title: Strings.newExperienceSectionTitle,
            summary: entry.hasNewExperience != null
                ? NewExperienceSummary(value: entry.hasNewExperience!)
                : const _EmptySummary(),
          ),
          _DaySection(
            index: '04',
            title: Strings.livingIntentionsSectionTitle,
            isLast: true,
            summary: entry.livingIntentionIds.isNotEmpty
                ? LivingIntentionsSummary(selectedIds: entry.livingIntentionIds.toSet())
                : const _EmptySummary(),
          ),
        ],
      ),
    );
  }

  double _sizeLevelToCircleSize(int sizeLevel) => 6 + sizeLevel * 6;
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.circleSize, required this.dayCount, required this.date});
  final int dayCount;
  final double circleSize;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Margins.spacingBase),
      color: AppColors.bgSoft(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Texts.primaryXsCounter(
                  context,
                  Strings.dayLabel,
                  "#$dayCount",
                  softColor: AppColors.contentSoftOnSoft(context),
                ),
                const SizedBox(height: Margins.spacingXs),
                Texts.primaryLargeBold(TimeUtils.formatDate(context, date)),
              ],
            ),
          ),
          const SizedBox(width: Margins.spacingBase),
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              color: AppColors.content(context),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AnimatedContainer(
                duration: AnimationDurations.short,
                curve: Curves.easeInOut,
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  color: AppColors.content(context),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({
    required this.index,
    required this.title,
    required this.summary,
    this.isLast = false,
  });

  final String index;
  final String title;
  final Widget? summary;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final Color titleColor = AppColors.contentSoft(context);
    final Color indexColor = AppColors.contentExtraSoft(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingBase),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Margins.spacingBase),
            child: Row(
              children: [
                Text(
                  index,
                  style: TextStyles.primaryMediumBold.copyWith(color: indexColor),
                ),
                const SizedBox(width: Margins.spacingS),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyles.primaryMediumBold.copyWith(color: titleColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (summary != null) ...[
                  const SizedBox(width: Margins.spacingS),
                  Flexible(child: summary!),
                ],
              ],
            ),
          ),
          if (!isLast) const SmallDivider(width: double.infinity),
        ],
      ),
    );
  }
}

class _EmptySummary extends StatelessWidget {
  const _EmptySummary();

  @override
  Widget build(BuildContext context) {
    return Icon(
      MingCuteIcons.mgc_minimize_line,
      size: Dimens.iconSizeXs,
      color: AppColors.contentSoft(context),
    );
  }
}

class _FilePreview extends StatelessWidget {
  const _FilePreview({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DayResumeBottomSheetViewModel>(
      converter: (store) => DayResumeBottomSheetViewModel.create(store, date),
      builder: (context, viewModel) {
        return switch (viewModel) {
          DayResumeBottomSheetViewModelEmpty() => const SizedBox.shrink(),
          DayResumeBottomSheetViewModelFilled() => _ImagesPreview(viewModel: viewModel),
          DayResumeBottomSheetViewModel() => throw UnimplementedError(),
        };
      },
    );
  }
}

class _ImagesPreview extends StatelessWidget {
  const _ImagesPreview({required this.viewModel});
  final DayResumeBottomSheetViewModelFilled viewModel;

  @override
  Widget build(BuildContext context) {
    final imagePaths = viewModel.entry.leaveATrace.imagePaths;
    if (imagePaths.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 200,
      child: _AnimatedImagesStack(imagePaths: imagePaths),
    );
  }
}

class _AnimatedImagesStack extends StatefulWidget {
  const _AnimatedImagesStack({required this.imagePaths});
  final List<String> imagePaths;

  @override
  State<_AnimatedImagesStack> createState() => _AnimatedImagesStackState();
}

class _AnimatedImagesStackState extends State<_AnimatedImagesStack> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _rotations = [-0.12, 0.00, 0.12];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _controller.forward();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _staggered(int index) {
    final start = (index * 0.15).clamp(0.0, 1.0);
    final end = (start + 0.65).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutBack),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final rise = constraints.maxHeight * 0.5;
        final photoWidth = constraints.maxWidth * 0.35;
        final count = widget.imagePaths.length;

        // Spread images evenly across the available width.
        // With n images, there are (n-1) gaps; center the whole group.
        double dx(int i) {
          if (count <= 1) return 0.0;
          final step = (constraints.maxWidth * 0.7 - photoWidth) / (count - 1);
          return -((constraints.maxWidth * 0.7 - photoWidth) / 2) + i * step;
        }

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            for (int i = 0; i < count; i++)
              _buildPhoto(
                index: i,
                path: widget.imagePaths[i],
                rise: rise,
                photoWidth: photoWidth,
                dx: dx(i),
              ),
          ],
        );
      },
    );
  }

  Widget _buildPhoto({
    required int index,
    required String path,
    required double rise,
    required double photoWidth,
    required double dx,
  }) {
    final anim = _staggered(index);
    final finalRotation = _rotations[index % _rotations.length];
    final startRotation = finalRotation + (index.isEven ? -0.25 : 0.25);
    final rotation = Tween<double>(begin: startRotation, end: finalRotation).animate(anim);
    final opacity = Tween<double>(begin: 0.0, end: 1.0).animate(anim);
    final dy = Tween<double>(begin: rise, end: 0.0).animate(anim);

    return AnimatedBuilder(
      animation: anim,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(dx, dy.value),
          child: Transform.rotate(
            angle: rotation.value,
            child: Opacity(
              opacity: opacity.value.clamp(0.0, 1.0),
              child: _PhotoFrame(path: path, width: photoWidth),
            ),
          ),
        );
      },
    );
  }
}

class _PhotoFrame extends StatefulWidget {
  const _PhotoFrame({required this.path, required this.width});
  final String path;
  final double width;

  @override
  State<_PhotoFrame> createState() => _PhotoFrameState();
}

class _PhotoFrameState extends State<_PhotoFrame> {
  double? _imageWidth;
  double? _imageHeight;

  @override
  void initState() {
    super.initState();
    _loadAspectRatio();
  }

  Future<void> _loadAspectRatio() async {
    final file = File(widget.path);
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    if (mounted) {
      setState(() {
        _imageWidth = image.width.toDouble();
        _imageHeight = image.height.toDouble();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_imageWidth == null || _imageHeight == null) {
      return const SizedBox.shrink();
    }
    return Container(
      width: _imageHeight! > _imageWidth! ? widget.width / (_imageHeight! / _imageWidth!) : widget.width,
      height: _imageHeight! > _imageWidth! ? widget.width : widget.width * (_imageHeight! / _imageWidth!),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radiusBase),
        border: Border.all(
          color: AppColors.strokeColor(context),
          width: Dimens.storkeWidthM,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.radiusBase - Dimens.storkeWidthM),
        child: Image.file(
          File(widget.path),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
