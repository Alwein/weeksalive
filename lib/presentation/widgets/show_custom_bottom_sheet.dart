import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/presentation/widgets/app_background_scale.dart';

Future<T?> showCustomBottomSheet<T>(
  BuildContext context,
  WidgetBuilder builder, {
  bool isScrollable = true,
  double maxSheetHeightFactor = 0.85,
  Curve entranceCurve = Curves.easeOutSine,
  Curve exitCurve = Curves.easeIn,
  Duration entranceDuration = AnimationDurations.medium,
  Duration exitDuration = AnimationDurations.short,
  Color? barrierColor,
  bool dismissible = true,
  WidgetBuilder? previewBuilder,
  bool scaleBackground = true,
  double backgroundScaleFactor = 1,
  bool showhandle = true,
  bool useRootNavigator = false,
}) {
  final bgController = scaleBackground ? AppBackgroundScaleScope.maybeOf(context) : null;
  bgController?.push(scale: backgroundScaleFactor);

  final future = showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: barrierColor,
    isScrollControlled: true,
    enableDrag: dismissible,
    isDismissible: dismissible,
    useRootNavigator: useRootNavigator,
    builder: (context) => _CustomBottomSheetContent(
      builder: builder,
      isScrollable: isScrollable,
      maxSheetHeightFactor: maxSheetHeightFactor,
      entranceCurve: entranceCurve,
      exitCurve: exitCurve,
      entranceDuration: entranceDuration,
      exitDuration: exitDuration,
      dismissible: dismissible,
      previewBuilder: previewBuilder,
      showhandle: showhandle,
    ),
  );
  return future.whenComplete(() => bgController?.pop());
}

class _CustomBottomSheetContent extends StatefulWidget {
  const _CustomBottomSheetContent({
    required this.builder,
    required this.isScrollable,
    required this.maxSheetHeightFactor,
    required this.entranceCurve,
    required this.exitCurve,
    required this.entranceDuration,
    required this.exitDuration,
    required this.dismissible,
    required this.previewBuilder,
    required this.showhandle,
  });

  final WidgetBuilder builder;
  final bool isScrollable;
  final double maxSheetHeightFactor;
  final Curve entranceCurve;
  final Curve exitCurve;
  final Duration entranceDuration;
  final Duration exitDuration;
  final bool dismissible;
  final bool showhandle;
  final WidgetBuilder? previewBuilder;

  @override
  State<_CustomBottomSheetContent> createState() => _CustomBottomSheetContentState();
}

class _CustomBottomSheetContentState extends State<_CustomBottomSheetContent> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previewHeight = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.entranceDuration,
      reverseDuration: widget.exitDuration,
      vsync: this,
    );

    _animation =
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: widget.entranceCurve,
            reverseCurve: widget.exitCurve,
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasPreview = widget.previewBuilder != null;
    final bgController = AppBackgroundScaleScope.maybeOf(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final t = _animation.value.clamp(0.0, 1.0);
        const previewGap = -60.0;
        const previewTopOffsetFallback = 92.0;

        final sheet = Transform.translate(
          offset: Offset(0, (1 - t) * 100),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) *
                  widget.maxSheetHeightFactor,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.bg(context),
                borderRadius: BorderRadius.circular(Dimens.radiusXl),
                border: Border.all(color: AppColors.strokeColor(context)),
              ),
              child: AnimatedPadding(
                duration: AnimationDurations.veryShort,
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Builder(
                  builder: (context) {
                    final content = Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (widget.showhandle) ...[
                              if (widget.dismissible) ...[
                                const SizedBox(height: Margins.spacingS),
                                const Center(child: _Handle()),
                              ],
                              const SizedBox(height: Margins.spacingM),
                            ],
                            widget.builder(context),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(MingCuteIcons.mgc_close_line, color: AppColors.contentSoft(context)),
                          ),
                        ),
                      ],
                    );
                    return widget.isScrollable
                        ? SingleChildScrollView(
                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                            child: content,
                          )
                        : content;
                  },
                ),
              ),
            ),
          ),
        );

        final preview = hasPreview
            ? Transform.translate(
                offset: Offset(0, (1 - t) * 100),
                child: _MeasureSize(
                  onChange: (size) {
                    if (!mounted) return;
                    if ((_previewHeight - size.height).abs() < 0.5) return;
                    setState(() => _previewHeight = size.height);
                  },
                  child: widget.previewBuilder!(context),
                ),
              )
            : null;

        Widget content = Stack(
          children: [
            if (widget.dismissible)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).maybePop(),
                  child: const SizedBox.expand(),
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.95,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    sheet,
                    if (preview != null)
                      Positioned(
                        top: -((_previewHeight > 0) ? (_previewHeight + previewGap) : previewTopOffsetFallback),
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.topCenter,
                          heightFactor: 1,
                          child: preview,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );

        if (bgController == null) return content;

        // Root is scaled down; counter-scale the sheet route back to 1.0 so only the background shrinks.
        return AnimatedBuilder(
          animation: bgController,
          child: content,
          builder: (context, child) => Transform.scale(
            scale: 1 / bgController.scale,
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
    );
  }
}

class _Handle extends StatelessWidget {
  const _Handle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.strokeColor(context),
        borderRadius: BorderRadius.circular(Dimens.radiusS),
      ),
    );
  }
}

class _MeasureSize extends SingleChildRenderObjectWidget {
  const _MeasureSize({required this.onChange, required super.child});

  final ValueChanged<Size> onChange;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderMeasureSize(onChange);

  @override
  void updateRenderObject(BuildContext context, covariant _RenderMeasureSize renderObject) {
    renderObject.onChange = onChange;
  }
}

class _RenderMeasureSize extends RenderProxyBox {
  _RenderMeasureSize(this.onChange);

  ValueChanged<Size> onChange;
  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    final newSize = child?.size;
    if (newSize == null) return;
    if (_oldSize == newSize) return;
    _oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) => onChange(newSize));
  }
}
