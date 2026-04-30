import 'package:easy_localization/easy_localization.dart';

class Strings {
  static String get appName => "WeeksAlive";

  // force update page
  static String get forceUpdateTitle => tr('force_update_title');
  static String get forceUpdateSubtitle => tr('force_update_subtitle');
  static String get forceUpdateButton => tr('force_update_button');

  // common
  static String get next => tr('next');
  static String get done => tr('done');
  static String get continueString => tr('continue');
  static String get edit => "Edit";

  // In app feedback
  static String get inAppFeedbackTitle => tr('inAppFeedbackTitle');
  static String get inAppFeedbackSubtitle => tr('inAppFeedbackSubtitle');
  static String get inAppFeedbackHint => tr('inAppFeedbackHint');
  static String get inAppFeedbackConfirmationTitle => tr('inAppFeedbackConfirmationTitle');
  static String get quickActionFeedbackTitle => tr('quickActionFeedbackTitle');
  static String get quickActionFeedbackSubtitle => tr('quickActionFeedbackSubtitle');

  // onboarding
  static String get onboarding01Subtitle => "A gentle reminder that\nyour time is precious";

  static String get onboarding02Title1 => "Life feels long.";
  static String get onboarding02Title2 => "Until it doesn\u2019t.";
  static String get onboarding02Subtitle =>
      "Most of us move through weeks without really feeling them. Until we look back and wonder where the years went.";

  static String get onboarding03Title => "Your life is made of weeks.";
  static String get onboarding03Subtitle => "Birthdays, heartbreaks.\nTuesdays. Every one is here.";
  static String get onboarding03Footer => "Every dot is a week you lived, or a week still ahead of you.";

  static String get iAmReady => "I\u2019m ready";

  static String get onboarding04Title => "Let's build your own grid.";
  static String get onboarding04Subtitle =>
      "Your grid is unique.\nIt starts the day you were born,and it belongs to no one else.";

  static String get onboarding05Title => "How should we call you?";
  static String get onboarding05Hint => "Nickname";

  static String get onboarding06Title => "When did your story begin?";
  static String get onboarding06Subtitle => "We\u2019ll build your personal life grid from this moment.";
}
