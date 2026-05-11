import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/presentation/home/view_model/home_page_view_model.dart';
import 'package:weeksalive/presentation/onboarding/widgets/custom_tab_bar.dart';
import 'package:weeksalive/presentation/onboarding/widgets/onboarding_small_divider.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/widgets/home_appbar.dart';
import 'package:weeksalive/presentation/widgets/life_grid_view.dart';
import 'package:weeksalive/presentation/widgets/zoomable_life_grid_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomePageViewModel>(
      converter: HomePageViewModel.create,
      builder: (context, vm) {
        return Scaffold(
          backgroundColor: AppColors.bg(context),
          body: _Body(vm: vm),
        );
      },
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.vm});
  final HomePageViewModel vm;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with SingleTickerProviderStateMixin {
  late final TabController _gridTabController;
  final GlobalKey<ZoomableLifeGridViewState> _zoomableGridKey = GlobalKey();

  int _committedGridTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _gridTabController = CustomTabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _gridTabController.dispose();
    super.dispose();
  }

  void _onGridYearModeCommitted(bool yearMode) {
    final idx = yearMode ? 1 : 0;
    if (_gridTabController.index != idx) {
      _gridTabController.index = idx;
      SensorialFeedback.navigationChanged();
      _committedGridTabIndex = idx;
    }
  }

  void _onGridTabTapped(int index) {
    if (index != _committedGridTabIndex) {
      SensorialFeedback.navigationChanged();
      _committedGridTabIndex = index;
    }
    if (index == 0) {
      _zoomableGridKey.currentState?.animateToWeekView();
    } else {
      _zoomableGridKey.currentState?.animateToYearView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacingL),
          child: Column(
            children: [
              HomeAppBar(
                userName: widget.vm.userName,
                streak: widget.vm.streakCount,
              ),
              const SizedBox(height: Margins.spacingBase),
              const SmallDivider(width: double.infinity),
              const SizedBox(height: Margins.spacingBase),
              _GridHeader(
                vm: widget.vm,
                tabController: _gridTabController,
                onTabTap: _onGridTabTapped,
              ),
              const SizedBox(height: Margins.spacingBase),
            ],
          ),
        ),
        Expanded(
          child: ZoomableLifeGridView(
            key: _zoomableGridKey,
            grid: widget.vm.lifeWeekGrid,
            padding: const EdgeInsets.only(left: Margins.spacingL, right: Margins.spacingL),
            onYearModeCommitted: _onGridYearModeCommitted,
          ),
        ),
        _WeekBar(streakCount: widget.vm.streakCount),
      ],
    );
  }
}

class _GridHeader extends StatelessWidget {
  const _GridHeader({
    required this.vm,
    required this.tabController,
    required this.onTabTap,
  });

  final HomePageViewModel vm;
  final TabController tabController;
  final ValueChanged<int> onTabTap;

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyles.primaryXsBold;

    return Row(
      children: [
        Expanded(child: LifeGridCounters(grid: vm.lifeWeekGrid)),
        const SizedBox(width: Margins.spacingBase),
        Flexible(
          child: CustomTabBar(
            controller: tabController,
            onTap: onTabTap,
            tabHeight: 42,
            tabs: [
              Tab(
                child: Text(Strings.homeGridTabLife, style: labelStyle),
              ),
              Tab(
                child: Text(Strings.homeGridTabYear, style: labelStyle),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeekBar extends StatelessWidget {
  const _WeekBar({required this.streakCount});
  final int streakCount;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    final monday = today.subtract(Duration(days: today.weekday - 1));

    return Container(
      color: AppColors.bg(context),
      padding: EdgeInsets.only(
        left: Margins.spacingL,
        right: Margins.spacingL,
        top: Margins.spacingBase,
        bottom: Margins.spacingBase + MediaQuery.paddingOf(context).bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final day = monday.add(Duration(days: i));
                return _DayCell(
                  day: day,
                  today: today,
                  streakCount: streakCount,
                );
              }),
            ),
          ),
          const SizedBox(width: Margins.spacingBase),
          _TodayButton(onTap: () {}),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.today,
    required this.streakCount,
  });

  final DateTime day;
  final DateTime today;
  final int streakCount;

  static const _kDayLabels = ['LU', 'MA', 'ME', 'JE', 'VE', 'SA', 'DI'];

  bool get _isToday => day.year == today.year && day.month == today.month && day.day == today.day;

  bool get _isFuture => day.isAfter(DateTime(today.year, today.month, today.day));

  bool get _isChecked {
    if (_isFuture) return false;

    final diff = DateTime(today.year, today.month, today.day).difference(DateTime(day.year, day.month, day.day)).inDays;
    return diff < streakCount;
  }

  @override
  Widget build(BuildContext context) {
    final label = _kDayLabels[day.weekday - 1];
    final contentColor = AppColors.content(context);
    final softColor = AppColors.contentSoft(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyles.primaryXsBold.copyWith(
            color: _isToday ? contentColor : softColor,
          ),
        ),
        const SizedBox(height: Margins.spacingXs),
        _DayIndicator(
          day: day,
          isToday: _isToday,
          isFuture: _isFuture,
          isChecked: _isChecked,
        ),
      ],
    );
  }
}

class _DayIndicator extends StatelessWidget {
  const _DayIndicator({
    required this.day,
    required this.isToday,
    required this.isFuture,
    required this.isChecked,
  });

  final DateTime day;
  final bool isToday;
  final bool isFuture;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    final contentColor = AppColors.content(context);
    final softColor = AppColors.contentSoft(context);

    if (isChecked && !isToday) {
      return Icon(Icons.check, size: 16, color: contentColor);
    }

    final label = isToday
        ? day.day.toString()
        : isFuture
        ? day.day.toString()
        : day.day.toString();

    final color = isFuture ? softColor : contentColor;

    if (isToday) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: contentColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyles.primaryXsBold.copyWith(
            color: AppColors.bg(context),
          ),
        ),
      );
    }

    return SizedBox(
      width: 24,
      height: 24,
      child: Center(
        child: Text(
          label,
          style: TextStyles.primaryXsBold.copyWith(color: color),
        ),
      ),
    );
  }
}

class _TodayButton extends StatelessWidget {
  const _TodayButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Margins.spacingBase,
          vertical: Margins.spacingS,
        ),
        decoration: BoxDecoration(
          color: AppColors.content(context),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: Margins.spacingXs,
          children: [
            Icon(Icons.add, size: 16, color: AppColors.bg(context)),
            Text(
              'Today',
              style: TextStyles.primaryRegularBold.copyWith(
                color: AppColors.bg(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
