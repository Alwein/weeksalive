import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';

Future<T?> showCustomBottomSheet<T>(
  BuildContext context,
  WidgetBuilder builder, {
  bool isScrollable = true,
  Curve entranceCurve = Curves.easeOutBack,
  Curve exitCurve = Curves.easeIn,
  Duration entranceDuration = AnimationDurations.base,
  Duration exitDuration = AnimationDurations.short,
  Color? barrierColor,
  bool dismissible = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: barrierColor,
    isScrollControlled: true,
    enableDrag: dismissible,
    isDismissible: dismissible,
    builder: (context) => _CustomBottomSheetContent(
      builder: builder,
      isScrollable: isScrollable,
      entranceCurve: entranceCurve,
      exitCurve: exitCurve,
      entranceDuration: entranceDuration,
      exitDuration: exitDuration,
      dismissible: dismissible,
    ),
  );
}

class _CustomBottomSheetContent extends StatefulWidget {
  const _CustomBottomSheetContent({
    required this.builder,
    required this.isScrollable,
    required this.entranceCurve,
    required this.exitCurve,
    required this.entranceDuration,
    required this.exitDuration,
    required this.dismissible,
  });

  final WidgetBuilder builder;
  final bool isScrollable;
  final Curve entranceCurve;
  final Curve exitCurve;
  final Duration entranceDuration;
  final Duration exitDuration;
  final bool dismissible;

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
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _animation.value) * 100),
          child: Opacity(
            opacity: _animation.value.clamp(0, 1),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.85,
              ),
              child: AnimatedPadding(
                duration: AnimationDurations.veryShort,
                padding: EdgeInsets.only(
                  left: Margins.spacingS,
                  right: Margins.spacingS,
                  bottom: isKeyboardOpen ? 0 : Margins.spacingM,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimens.radiusXl),
                  child: Container(
                    color: AppColors.bg(context),
                    child: AnimatedPadding(
                      duration: AnimationDurations.veryShort,
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Builder(
                        builder: (context) {
                          final content = Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (widget.dismissible)
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const Center(child: _Handle()),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () => Navigator.of(context).pop(),
                                        icon: Container(
                                          padding: const EdgeInsets.all(Margins.spacingXs),
                                          decoration: BoxDecoration(
                                            color: AppColors.bgSoft(context),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(MingCuteIcons.mgc_close_line, color: AppColors.strokeColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              widget.builder(context),
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
              ),
            ),
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
        color: AppColors.strokeColor,
        borderRadius: BorderRadius.circular(Dimens.radiusS),
      ),
    );
  }
}
