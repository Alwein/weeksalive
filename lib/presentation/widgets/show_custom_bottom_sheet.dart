import 'dart:math' as math;

import 'package:flutter/material.dart';
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
    final bgController = AppBackgroundScaleScope.maybeOf(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final t = _animation.value.clamp(0.0, 1.0);

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
            CustomMultiChildLayout(
              delegate: _SheetLayoutDelegate(
                maxSheetHeight: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.95,
              ),
              children: [
                LayoutId(id: _SheetSlot.sheet, child: sheet),
                if (widget.previewBuilder != null)
                  LayoutId(
                    id: _SheetSlot.preview,
                    child: Transform.translate(
                      offset: Offset(0, (1 - t) * 100),
                      child: widget.previewBuilder!(context),
                    ),
                  ),
              ],
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

enum _SheetSlot { sheet, preview }

/// Lays the sheet out at the bottom and the preview straddling its top edge.
///
/// Both live in this full-size box: a preview overflowing a sheet-sized parent
/// would only receive taps on the part drawn over the sheet.
class _SheetLayoutDelegate extends MultiChildLayoutDelegate {
  _SheetLayoutDelegate({required this.maxSheetHeight});

  final double maxSheetHeight;

  /// How far the preview's bottom edge reaches into the sheet.
  static const _previewOverlap = 60.0;

  @override
  void performLayout(Size size) {
    final sheetSize = layoutChild(
      _SheetSlot.sheet,
      BoxConstraints(maxWidth: size.width, maxHeight: math.min(maxSheetHeight, size.height)),
    );
    final sheetTop = size.height - sheetSize.height;
    positionChild(_SheetSlot.sheet, Offset((size.width - sheetSize.width) / 2, sheetTop));

    if (!hasChild(_SheetSlot.preview)) return;
    final previewSize = layoutChild(_SheetSlot.preview, BoxConstraints(maxWidth: size.width));
    positionChild(
      _SheetSlot.preview,
      Offset((size.width - previewSize.width) / 2, sheetTop + _previewOverlap - previewSize.height),
    );
  }

  @override
  bool shouldRelayout(_SheetLayoutDelegate oldDelegate) => oldDelegate.maxSheetHeight != maxSheetHeight;
}
