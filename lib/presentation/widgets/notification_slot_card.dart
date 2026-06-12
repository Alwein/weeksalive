import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/app_colors.dart';
import 'package:weeksalive/core/styles/dimens.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';
import 'package:weeksalive/core/texts/strings.dart';
import 'package:weeksalive/domain/notifications/notification_slots.dart';
import 'package:weeksalive/presentation/widgets/show_custom_time_picker.dart';

class NotificationSlotCard extends StatelessWidget {
  const NotificationSlotCard({
    super.key,
    this.enabled = true,
    required this.slot,
    required this.onToggle,
    required this.onTimeChanged,
    this.label,
  });

  final bool enabled;
  final NotificationSlotState slot;
  final ValueChanged<bool> onToggle;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final String? label;

  String _formatTime(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showCustomTimePicker(context, initialTime: slot.time);
    if (picked != null) {
      onTimeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: IgnorePointer(
        ignoring: !enabled,
        child: GestureDetector(
          onTap: () => _pickTime(context),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Margins.spacingBase,
              vertical: Margins.spacingBase,
            ),
            decoration: BoxDecoration(
              color: AppColors.bgSoft(context),
              borderRadius: BorderRadius.circular(Dimens.radiusBase),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label ?? Strings.onboarding20CheckIn,
                        style: TextStyles.primarySmallBold.copyWith(
                          color: AppColors.contentSoftOnSoft(context),
                        ),
                      ),
                      const SizedBox(height: Margins.spacingXs),
                      Row(
                        children: [
                          Text(
                            _formatTime(slot.time),
                            style: TextStyles.primaryLargeBold.copyWith(
                              color: AppColors.content(context),
                            ),
                          ),
                          const SizedBox(width: Margins.spacingS),
                          Icon(
                            MingCuteIcons.mgc_pencil_line,
                            size: Dimens.iconSizeXs,
                            color: AppColors.contentSoft(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                CupertinoSwitch(
                  value: slot.enabled,
                  onChanged: onToggle,
                  activeTrackColor: AppColors.greenSuccess(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
