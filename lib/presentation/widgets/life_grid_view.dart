import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/core/grid_motif/grid_motif_id.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/domain/life_week_grid.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/widgets/week_grid_painter.dart';

class LifeGridView extends StatelessWidget {
  const LifeGridView({super.key, required this.grid, this.padding = EdgeInsets.zero});

  final LifeWeekGrid grid;
  final EdgeInsets padding;

  static const _kColumns = 52;
  static const _kDotSpacing = 2.0;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GridMotifId>(
      converter: (store) => store.state.gridMotifState.selectedMotif,
      builder: (context, motif) {
        final activeColor = AppColors.content(context);
        final inactiveColor = AppColors.bgSoft(context);
        final bgColor = AppColors.bg(context);

        return LayoutBuilder(
          builder: (context, constraints) {
            final exactHeight = WeekGridPainter.computeHeight(
              availableWidth: constraints.maxWidth,
              totalWeeks: grid.totalWeeks,
              columns: _kColumns,
              dotSpacing: _kDotSpacing,
              padding: padding,
            );
            final needsScroll = exactHeight > constraints.maxHeight;

            final scrollContent = SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: exactHeight,
                    child: CustomPaint(
                      painter: WeekGridPainter(
                        columns: _kColumns,
                        totalWeeks: grid.totalWeeks,
                        livedWeeks: grid.livedWeeks,
                        dotSpacing: _kDotSpacing,
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                        padding: padding,
                        motif: motif,
                      ),
                    ),
                  ),
                ],
              ),
            );

            if (!needsScroll) return scrollContent;

            return ShaderMask(
              shaderCallback: (rect) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.0, 0.90, 1.0],
                colors: [bgColor, Colors.transparent, Colors.transparent, bgColor],
              ).createShader(rect),
              blendMode: BlendMode.dstOut,
              child: scrollContent,
            );
          },
        );
      },
    );
  }
}
