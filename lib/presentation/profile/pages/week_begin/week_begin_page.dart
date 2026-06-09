import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/user/user.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';
import 'package:weeksalive/presentation/redux/user/user_actions.dart';
import 'package:weeksalive/presentation/redux/user/user_state.dart';
import 'package:weeksalive/presentation/widgets/primary_appbar.dart';
import 'package:weeksalive/presentation/widgets/week_begin_picker.dart';

class WeekBeginPage extends StatelessWidget {
  const WeekBeginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (context) => const WeekBeginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: PrimaryAppBar(title: Strings.weekBeginPageTitle),
      body: StoreConnector<AppState, User?>(
        converter: (store) => store.state.userState.userOrNull,
        builder: (context, user) {
          if (user == null) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM, vertical: Margins.spacingM),
            child: WeekBeginPicker(
              dateOfBirth: user.dateOfBirth,
              onWeekStartDaySelected: (weekStartDay) => _onWeekStartDaySelected(context, user, weekStartDay),
            ),
          );
        },
      ),
    );
  }

  void _onWeekStartDaySelected(BuildContext context, User user, int weekStartDay) {
    StoreProvider.of<AppState>(context).dispatch(
      UpdateUserAction(
        name: user.name,
        dateOfBirth: user.dateOfBirth,
        gender: user.gender,
        lifespan: user.lifespan,
        weekStartDay: weekStartDay,
      ),
    );
    Navigator.pop(context);
  }
}
