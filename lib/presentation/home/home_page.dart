import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/core/utils/sensorial_feedback.dart';
import 'package:weeksalive/presentation/day_form/day_form.dart';
import 'package:weeksalive/presentation/home/view_model/home_page_view_model.dart';
import 'package:weeksalive/presentation/home/widgets/day_resume_bottom_sheet/day_resume_bottom_sheet.dart';
import 'package:weeksalive/presentation/home/widgets/home_appbar.dart';
import 'package:weeksalive/presentation/home/widgets/home_week_calendar.dart';
import 'package:weeksalive/presentation/onboarding/widgets/custom_tab_bar.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/navigation/navigation_actions.dart';
import 'package:weeksalive/presentation/redux/push_notifications/push_notification_actions.dart';
import 'package:weeksalive/presentation/widgets/apparition_animation.dart';
import 'package:weeksalive/presentation/widgets/zoomable_life_grid_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomePageViewModel>(
      converter: HomePageViewModel.create,
      builder: (context, vm) {
        final store = StoreProvider.of<AppState>(context);
        return Scaffold(
          backgroundColor: AppColors.bg(context),
          body: _Body(
            vm: vm,
            initialTabIndex: store.state.navigationState.homeTabIndex,
          ),
        );
      },
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.vm, required this.initialTabIndex});
  final HomePageViewModel vm;
  final int initialTabIndex;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with SingleTickerProviderStateMixin {
  late final TabController _gridTabController;
  final GlobalKey<ZoomableLifeGridViewState> _zoomableGridKey = GlobalKey();
  final GlobalKey<HomeAppBarState> _appBarKey = GlobalKey();

  int _committedGridTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _committedGridTabIndex = widget.initialTabIndex;
    _gridTabController = CustomTabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    if (widget.initialTabIndex == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _zoomableGridKey.currentState?.jumpToYearView();
      });
    }
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
      StoreProvider.of<AppState>(context).dispatch(SetHomeTabIndexAction(index));
    }
    if (index == 0) {
      _zoomableGridKey.currentState?.animateToWeekView();
    } else {
      _zoomableGridKey.currentState?.animateToYearView();
    }
  }

  void _onPastDayTap(DateTime date) {
    DayResumeBottomSheet.show(context, date: date);
  }

  Future<void> _onTodayTap() async {
    final result = await DayForm.showBottomSheet(
      context,
      DateTime.now(),
      onDaySaved: (saved) => _zoomableGridKey.currentState?.prepareDayAppear(saved.date),
    );
    if (!mounted || result == null) return;
    await _playSaveAnimations(result);
  }

  Future<void> _playSaveAnimations(DayFormResult result) async {
    // Delay to avoid animation starting during the sheet close animation
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _zoomableGridKey.currentState?.prepareDayAppear(result.date);

    _gridTabController.index = 1;
    _committedGridTabIndex = 1;
    await _zoomableGridKey.currentState?.animateToYearView();
    if (!mounted) return;
    await _zoomableGridKey.currentState?.animateDayAppear(result.date, result.sizeLevel);

    if (!mounted) return;

    if (result.streakIncreased) {
      await _appBarKey.currentState?.playStreakReveal();
    }
  }

  void _onNotificationTap() {
    StoreProvider.of<AppState>(context).dispatch(const ClearNotificationTapAction());
    _onTodayTap();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
      converter: (store) => store.state.pushNotificationState.pendingOpenDayForm,
      onWillChange: (previous, next) {
        if (next && !(previous ?? false)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _onNotificationTap();
          });
        }
      },
      builder: (context, _) => ApparitionAnimation(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.paddingOf(context).top),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Margins.spacingL),
              child: HomeAppBar(
                key: _appBarKey,
                vm: widget.vm,
                tabController: _gridTabController,
              ),
            ),
            const SizedBox(height: Margins.spacingBase),
            HomeWeekCalendar(
              vm: widget.vm,
              onTodayTap: _onTodayTap,
              onPastDayTap: _onPastDayTap,
            ),
            const SizedBox(height: Margins.spacingBase),
            Expanded(
              child: ZoomableLifeGridView(
                key: _zoomableGridKey,
                grid: widget.vm.lifeWeekGrid,
                padding: const EdgeInsets.only(left: Margins.spacingL, right: Margins.spacingL),
                onYearModeCommitted: _onGridYearModeCommitted,
                onPastDayTap: (date, entry) => _onPastDayTap(date),
              ),
            ),
            _BottomBar(
              streakCount: widget.vm.streakCount,
              isTodayDone: widget.vm.isTodayDone,
              tabController: _gridTabController,
              onTabTap: _onGridTabTapped,
              onTodayTap: _onTodayTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.streakCount,
    required this.isTodayDone,
    required this.tabController,
    required this.onTabTap,
    required this.onTodayTap,
  });
  final int streakCount;
  final bool isTodayDone;
  final TabController tabController;
  final ValueChanged<int> onTabTap;
  final VoidCallback onTodayTap;

  static const double kTabHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg(context),
      padding: EdgeInsets.only(
        left: Margins.spacingL,
        right: Margins.spacingL,
        top: Margins.spacingBase,
        bottom: Margins.spacingXs + MediaQuery.paddingOf(context).bottom,
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
          _TodayButton(isTodayDone: isTodayDone, onTap: onTodayTap),
        ],
      ),
    );
  }
}

// custom button to keep same size as the tabs
class _TodayButton extends StatelessWidget {
  const _TodayButton({required this.isTodayDone, required this.onTap});
  final bool isTodayDone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fgColor = isTodayDone ? AppColors.contentSoftOnSoft(context) : AppColors.contentMuted(context);
    final bgColor = isTodayDone ? AppColors.bgSoft(context) : AppColors.content(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          height: _BottomBar.kTabHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: Margins.spacingM,
            vertical: Margins.spacingS,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: Margins.spacingXs,
            children: [
              Icon(
                isTodayDone ? MingCuteIcons.mgc_check_line : MingCuteIcons.mgc_add_line,
                size: Dimens.iconSizeS,
                color: fgColor,
              ),
              Text(
                Strings.today,
                style: TextStyles.primaryRegularBold.copyWith(
                  color: fgColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
