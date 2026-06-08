import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';

Future<DateTime?> showCustomDatePicker(
  BuildContext context, {
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    builder: (BuildContext context, Widget? child) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme(
            brightness: isDark ? Brightness.dark : Brightness.light,
            primary: AppColors.content(context),
            onPrimary: AppColors.bg(context),
            surface: AppColors.bg(context),
            onSurface: AppColors.content(context),
            secondary: AppColors.contentSoftOnSoft(context),
            onSecondary: AppColors.contentMuted(context),
            surfaceTint: Colors.transparent,
            error: AppColors.redWarning,
            onError: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              backgroundColor: AppColors.content(context),
              foregroundColor: AppColors.bg(context),
            ),
          ),
          datePickerTheme: DatePickerThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.radiusBase),
              side: BorderSide(color: AppColors.strokeColor(context)),
            ),
          ),
        ),
        child: child!,
      );
    },
  );
}
