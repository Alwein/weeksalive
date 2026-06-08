import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/presentation/widgets/primary_button.dart';

Future<TimeOfDay?> showCustomTimePicker(
  BuildContext context, {
  required TimeOfDay initialTime,
}) {
  return showTimePicker(
    context: context,
    initialTime: initialTime,
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
          timePickerTheme: TimePickerThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.radiusBase),
              side: BorderSide(color: AppColors.strokeColor(context)),
            ),
          ),
        ),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        ),
      );
    },
  );
}

Future<TimeOfDay?> showCustomCupertinoTimePicker(
  BuildContext context, {
  required TimeOfDay initialTime,
}) async {
  Duration selectedDuration = Duration(hours: initialTime.hour, minutes: initialTime.minute);

  TimeOfDay? result = await showCupertinoModalPopup<TimeOfDay>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: AppColors.bg(context),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimens.radiusL),
            topRight: Radius.circular(Dimens.radiusL),
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Margins.spacingM, vertical: Margins.spacingS),
                child: PrimaryButton(
                  onPressed: () {
                    Navigator.of(context).pop(
                      TimeOfDay(
                        hour: selectedDuration.inHours,
                        minute: selectedDuration.inMinutes % 60,
                      ),
                    );
                  },
                  text: Strings.done,
                ),
              ),
            ),
            Expanded(
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                initialTimerDuration: selectedDuration,
                onTimerDurationChanged: (Duration newDuration) {
                  selectedDuration = newDuration;
                },
              ),
            ),
          ],
        ),
      );
    },
  );

  return result;
}
