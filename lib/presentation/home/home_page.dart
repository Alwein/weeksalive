import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/presentation/day_form/day_form.dart';
import 'package:weeksalive/presentation/home/view_model/home_page_view_model.dart';
import 'package:weeksalive/presentation/onboarding/widgets/custom_tab_bar.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/widgets/home_appbar.dart';
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
        const SizedBox(height: Margins.spacingS),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacingL),
          child: HomeAppBar(vm: widget.vm, tabController: _gridTabController),
        ),
        const SizedBox(height: Margins.spacingM),
        Expanded(
          child: ZoomableLifeGridView(
            key: _zoomableGridKey,
            grid: widget.vm.lifeWeekGrid,
            padding: const EdgeInsets.only(left: Margins.spacingL, right: Margins.spacingL),
            onYearModeCommitted: _onGridYearModeCommitted,
          ),
        ),
        _BottomBar(
          streakCount: widget.vm.streakCount,
          tabController: _gridTabController,
          onTabTap: _onGridTabTapped,
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.streakCount, required this.tabController, required this.onTabTap});
  final int streakCount;
  final TabController tabController;
  final ValueChanged<int> onTabTap;

  static const double kTabHeight = 42;

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
        spacing: Margins.spacingM,
        children: [
          IntrinsicWidth(
            child: CustomTabBar(
              controller: tabController,
              onTap: onTabTap,
              tabHeight: _BottomBar.kTabHeight,
              tabs: [
                Tab(
                  child: Text(Strings.homeGridTabLife, style: TextStyles.primaryRegularBold),
                ),
                Tab(
                  child: Text(Strings.homeGridTabYear, style: TextStyles.primaryRegularBold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(3, (i) {
                final day = monday.subtract(Duration(days: i));
                return _DayCell(
                  day: day,
                  today: today,
                  streakCount: streakCount,
                );
              }).reversed.toList(),
            ),
          ),
          _TodayButton(onTap: () => DayForm.showBottomSheet(context, DateTime.now())),
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

  bool get _isToday => day.year == today.year && day.month == today.month && day.day == today.day;

  bool get _isFuture => day.isAfter(DateTime(today.year, today.month, today.day));

  bool get _isChecked {
    if (_isFuture) return false;

    final diff = DateTime(today.year, today.month, today.day).difference(DateTime(day.year, day.month, day.day)).inDays;
    return diff < streakCount;
  }

  @override
  Widget build(BuildContext context) {
    final label = Strings.homePageDayLabels[day.weekday - 1];
    final contentColor = AppColors.content(context);
    final softColor = AppColors.contentSoft(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyles.primarySmallBold.copyWith(
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

    if (isChecked && !isToday) {
      return Icon(Icons.check, size: 16, color: contentColor);
    }

    const size = 16.0;

    final todayEmpty = !isChecked && isToday;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: todayEmpty ? AppColors.accentOrange : Colors.transparent,
        shape: BoxShape.circle,
        border: todayEmpty
            ? null
            : Border.all(
                color: AppColors.strokeColor(context),
                width: 1,
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
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          height: _BottomBar.kTabHeight,
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
              Icon(Icons.add, size: Dimens.iconSizeS, color: AppColors.bg(context)),
              Text(
                Strings.today,
                style: TextStyles.primaryRegularBold.copyWith(
                  color: AppColors.bg(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
