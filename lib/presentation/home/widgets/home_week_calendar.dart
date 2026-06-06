import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/home/view_model/home_page_view_model.dart';

class HomeWeekCalendar extends StatelessWidget {
  const HomeWeekCalendar({
    super.key,
    required this.vm,
    required this.onTodayTap,
    required this.onPastDayTap,
  });

  final HomePageViewModel vm;
  final VoidCallback onTodayTap;
  final ValueChanged<DateTime> onPastDayTap;

  List<DateTime> _weekDays(DateTime today, int weekStartDay) {
    final offset = (today.weekday - weekStartDay) % 7;
    final start = DateTime(today.year, today.month, today.day - offset);
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  String _shortName(DateTime date) {
    return Strings.weekdayShortNames[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final days = _weekDays(todayNormalized, vm.weekStartDay);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacingL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((day) {
          final isToday = day == todayNormalized;
          final isFuture = day.isAfter(todayNormalized);
          return _DayCell(
            onTap: isFuture ? null : () => isToday ? onTodayTap() : onPastDayTap(day),
            dayName: _shortName(day),
            dayNumber: day.day,
            isToday: isToday,
            isRecorded: vm.recordedDays.contains(day),
          );
        }).toList(),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.dayName,
    required this.dayNumber,
    required this.isToday,
    required this.isRecorded,
    this.onTap,
  });

  final String dayName;
  final int dayNumber;
  final bool isToday;
  final bool isRecorded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Margins.spacingS),
        decoration: BoxDecoration(
          color: AppColors.bg(context),
          borderRadius: BorderRadius.circular(300),
          border: isToday ? Border.all(color: AppColors.strokeColor(context), width: 1) : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dayName,
              style: TextStyles.primaryXsBold.copyWith(
                color: isToday ? AppColors.content(context) : AppColors.contentSoft(context),
              ),
            ),
            const SizedBox(height: Margins.spacingXs / 2),
            _DayIndicator(isToday: isToday, isRecorded: isRecorded, dayNumber: dayNumber),
          ],
        ),
      ),
    );
  }
}

class _DayIndicator extends StatelessWidget {
  const _DayIndicator({
    required this.isToday,
    required this.isRecorded,
    required this.dayNumber,
  });

  final bool isToday;
  final bool isRecorded;
  final int dayNumber;

  static const double _size = 16;

  @override
  Widget build(BuildContext context) {
    if (isRecorded) {
      return SizedBox(
        width: _size,
        height: _size,
        child: Icon(
          MingCuteIcons.mgc_check_line,
          size: _size,
          color: AppColors.content(context),
        ),
      );
    }

    if (isToday) {
      return SizedBox(
        width: _size,
        height: _size,
        child: Center(
          child: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: AppColors.accentOrange,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    return Center(
      child: Text(
        dayNumber.toString().padLeft(2, '0'),
        style: TextStyles.primarySmallBold.copyWith(
          color: AppColors.contentSoft(context),
        ),
      ),
    );
  }
}
