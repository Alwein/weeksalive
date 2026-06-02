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
import 'package:weeksalive/presentation/home/widgets/home_appbar.dart';
import 'package:weeksalive/presentation/home/widgets/home_week_calendar.dart';
import 'package:weeksalive/presentation/onboarding/widgets/custom_tab_bar.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
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
        SizedBox(height: MediaQuery.paddingOf(context).top),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacingL),
          child: HomeAppBar(vm: widget.vm, tabController: _gridTabController),
        ),
        const SizedBox(height: Margins.spacingBase),
        HomeWeekCalendar(vm: widget.vm),
        const SizedBox(height: Margins.spacingBase),
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

  static const double kTabHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg(context),
      padding: EdgeInsets.only(
        left: Margins.spacingL,
        right: Margins.spacingL,
        top: Margins.spacingBase,
        bottom: Margins.spacingBase + MediaQuery.paddingOf(context).bottom,
      ),
      child: Row(
        spacing: Margins.spacingBase,
        children: [
          Expanded(
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
          _TodayButton(onTap: () => DayForm.showBottomSheet(context, DateTime.now())),
        ],
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
