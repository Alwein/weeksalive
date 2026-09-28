import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/l10n/time_utils.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/day/day_entry.dart';
import 'package:weeksalive/presentation/day_form/day_form.dart';
import 'package:weeksalive/presentation/home/widgets/day_resume_bottom_sheet/day_resume_bottom_sheet_view_model.dart';
import 'package:weeksalive/presentation/home/widgets/day_resume_bottom_sheet/day_resume_session.dart';
import 'package:weeksalive/presentation/home/widgets/day_summaries.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/onboarding/widgets/parallax_rive.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';
import 'package:weeksalive/presentation/widgets/circle.dart';
import 'package:weeksalive/presentation/widgets/image_carousel_page.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';
import 'package:weeksalive/presentation/widgets/show_custom_bottom_sheet.dart';
import 'package:weeksalive/presentation/widgets/texts.dart';

class DayResumeBottomSheet extends StatefulWidget {
  const DayResumeBottomSheet({super.key, required this.session});

  final DayResumeSession session;

  static Future<void> show(BuildContext context, {required DateTime date}) {
    final birth = StoreProvider.of<AppState>(
      context,
      listen: false,
    ).state.userState.userOrNull?.dateOfBirth;
    final session = DayResumeSession(
      date: normalizeDay(date),
      earliestDate: birth == null ? null : normalizeDay(birth),
    );
    return showCustomBottomSheet<void>(
      context,
      (sheetContext) => DayResumeBottomSheet(session: session),
      previewBuilder: (context) => _FilePreview(session: session),
    ).whenComplete(session.dispose);
  }

  @override
  State<DayResumeBottomSheet> createState() => _DayResumeBottomSheetState();
}

class _DayResumeBottomSheetState extends State<DayResumeBottomSheet> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.session.attach(this);
  }

  @override
  void dispose() {
    widget.session.detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DaySwipeViewport(
      session: widget.session,
      reportsWidth: true,
      pageBuilder: (date) => _DayPage(date: date),
    );
  }
}

class _DayPage extends StatelessWidget {
  const _DayPage({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DayResumeBottomSheetViewModel>(
      converter: (store) => DayResumeBottomSheetViewModel.create(store, date),
      builder: (context, viewModel) {
        return switch (viewModel) {
          DayResumeBottomSheetViewModelEmpty() => _EmptyDayContent(date: date),
          DayResumeBottomSheetViewModelFilled() => _FilledDayContent(
            viewModel: viewModel,
          ),
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
              DayForm.showBottomSheet(
                context,
                viewModel.entry.date,
                source: 'resume',
              );
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
      style: TextStyles.primaryMediumMedium.copyWith(
        color: AppColors.content(context),
      ),
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
        border: Border.all(
          color: AppColors.strokeColor(context),
          width: Dimens.strokeWidthS,
        ),
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
                ? LivingIntentionsSummary(
                    selectedIds: entry.livingIntentionIds.toSet(),
                  )
                : const _EmptySummary(),
          ),
        ],
      ),
    );
  }

  double _sizeLevelToCircleSize(int sizeLevel) => 6 + sizeLevel * 6;
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({
    required this.circleSize,
    required this.dayCount,
    required this.date,
  });
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
                  style: TextStyles.primaryMediumBold.copyWith(
                    color: indexColor,
                  ),
                ),
                const SizedBox(width: Margins.spacingS),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyles.primaryMediumBold.copyWith(
                      color: titleColor,
                    ),
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

class _DaySwipeViewport extends StatefulWidget {
  const _DaySwipeViewport({
    required this.session,
    required this.pageBuilder,
    this.reportsWidth = false,
  });

  final DayResumeSession session;
  final Widget Function(DateTime date) pageBuilder;
  final bool reportsWidth;

  @override
  State<_DaySwipeViewport> createState() => _DaySwipeViewportState();
}

class _DaySwipeViewportState extends State<_DaySwipeViewport> {
  final Map<DateTime, double> _heights = {};
  final Map<DateTime, GlobalKey> _keys = {};

  GlobalKey _keyFor(DateTime date) => _keys.putIfAbsent(date, GlobalKey.new);

  void _setHeight(DateTime date, double height) {
    if (!mounted) return;
    final current = _heights[date];
    if (current != null && (current - height).abs() < 0.5) return;
    setState(() => _heights[date] = height);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.session,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final layoutWidth = constraints.maxWidth;
            final session = widget.session;
            if (widget.reportsWidth) session.updateWidth(layoutWidth);

            final width = session.width > 1 ? session.width : layoutWidth;
            final progress = width == 0 ? 0.0 : (session.offset / width).clamp(-1.0, 1.0);
            final previous = session.previousDate;
            final next = session.nextDate;
            final visible = <DateTime>{
              session.date,
              if (previous != null) previous,
              if (next != null) next,
            };
            _keys.removeWhere((date, _) => !visible.contains(date));
            _heights.removeWhere((date, _) => !visible.contains(date));

            final neighbor = progress > 0
                ? previous
                : progress < 0
                ? next
                : null;
            final currentHeight = _heights[session.date];
            final neighborHeight = neighbor == null ? null : _heights[neighbor];
            final displayHeight = currentHeight != null && neighborHeight != null && progress != 0
                ? ui.lerpDouble(currentHeight, neighborHeight, progress.abs())
                : null;

            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragDown: (_) => session.onDragStart(),
              onHorizontalDragStart: (_) => session.onDragStart(),
              onHorizontalDragUpdate: (details) => session.onDragUpdate(details.delta.dx),
              onHorizontalDragEnd: (details) => session.onDragEnd(details.primaryVelocity ?? 0),
              onHorizontalDragCancel: session.onDragCancel,
              child: ClipRect(
                child: SizedBox(
                  width: layoutWidth,
                  height: displayHeight,
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    alignment: Alignment.topCenter,
                    children: [
                      if (previous != null)
                        _slot(
                          date: previous,
                          dx: -width + session.offset,
                          laysOutHeight: false,
                        ),
                      if (next != null)
                        _slot(
                          date: next,
                          dx: width + session.offset,
                          laysOutHeight: false,
                        ),
                      _slot(
                        date: session.date,
                        dx: session.offset,
                        laysOutHeight: displayHeight == null,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _slot({
    required DateTime date,
    required double dx,
    required bool laysOutHeight,
  }) {
    final page = Transform.translate(
      offset: Offset(dx, 0),
      child: KeyedSubtree(
        key: _keyFor(date),
        child: _ReportHeight(
          onHeight: (height) => _setHeight(date, height),
          child: widget.pageBuilder(date),
        ),
      ),
    );

    if (laysOutHeight) return page;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: OverflowBox(
        alignment: Alignment.topCenter,
        fit: OverflowBoxFit.deferToChild,
        minHeight: 0,
        maxHeight: double.infinity,
        child: page,
      ),
    );
  }
}

class _ReportHeight extends SingleChildRenderObjectWidget {
  const _ReportHeight({required this.onHeight, required super.child});

  final ValueChanged<double> onHeight;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderReportHeight(onHeight);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderReportHeight renderObject,
  ) {
    renderObject.onHeight = onHeight;
  }
}

class _RenderReportHeight extends RenderProxyBox {
  _RenderReportHeight(this.onHeight);

  ValueChanged<double> onHeight;
  double? _last;

  @override
  void performLayout() {
    super.performLayout();
    final height = child?.size.height;
    if (height == null || (_last != null && (_last! - height).abs() < 0.5)) return;
    _last = height;
    final reported = height;
    WidgetsBinding.instance.addPostFrameCallback((_) => onHeight(reported));
  }
}

class _FilePreview extends StatelessWidget {
  const _FilePreview({required this.session});

  final DayResumeSession session;

  @override
  Widget build(BuildContext context) {
    return _DaySwipeViewport(
      session: session,
      pageBuilder: (date) => _DayPreview(date: date),
    );
  }
}

class _DayPreview extends StatelessWidget {
  const _DayPreview({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DayResumeBottomSheetViewModel>(
      converter: (store) => DayResumeBottomSheetViewModel.create(store, date),
      builder: (context, viewModel) {
        return switch (viewModel) {
          DayResumeBottomSheetViewModelEmpty() => const SizedBox.shrink(),
          DayResumeBottomSheetViewModelFilled() => _ImagesPreview(
            viewModel: viewModel,
          ),
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
      child: _AnimatedImagesStack(
        imagePaths: imagePaths,
        onImageTap: (index) => ImageCarouselPage.show(
          context,
          imagePaths: imagePaths,
          initialIndex: index,
        ),
      ),
    );
  }
}

class _AnimatedImagesStack extends StatefulWidget {
  const _AnimatedImagesStack({
    required this.imagePaths,
    required this.onImageTap,
  });
  final List<String> imagePaths;
  final ValueChanged<int> onImageTap;

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
                onTap: () => widget.onImageTap(i),
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
    required VoidCallback onTap,
  }) {
    final anim = _staggered(index);
    final finalRotation = _rotations[index % _rotations.length];
    final startRotation = finalRotation + (index.isEven ? -0.25 : 0.25);
    final rotation = Tween<double>(
      begin: startRotation,
      end: finalRotation,
    ).animate(anim);
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
              child: GestureDetector(
                onTap: onTap,
                child: _PhotoFrame(path: path, width: photoWidth),
              ),
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
        borderRadius: BorderRadius.circular(
          Dimens.radiusBase - Dimens.storkeWidthM,
        ),
        child: Image.file(
          File(widget.path),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
