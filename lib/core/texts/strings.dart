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
  static String get editName => "Edit name";

  // In app feedback
  static String get inAppFeedbackTitle => tr('inAppFeedbackTitle');
  static String get inAppFeedbackSubtitle => tr('inAppFeedbackSubtitle');
  static String get inAppFeedbackHint => tr('inAppFeedbackHint');
  static String get inAppFeedbackConfirmationTitle => tr('inAppFeedbackConfirmationTitle');
  static String get quickActionFeedbackTitle => tr('quickActionFeedbackTitle');
  static String get quickActionFeedbackSubtitle => tr('quickActionFeedbackSubtitle');

  // Life grid
  static String get progressLabel => "PROGRESS";
  static String get weekLabel => "WEEK";

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

  static String get onboarding05Title => "Type your name or a nickname.";
  static String get onboarding05Hint => "Nickname";

  static String get onboarding06Title => "When did your story begin?";
  static String get onboarding06Subtitle => "We\u2019ll build your personal life grid from this moment.";
  static String get onboarding06DateOfBirth => "DATE OF BIRTH";

  static String get onboarding07Title => "Are you a man or a woman?";
  static String get onboarding07Subtitle => "Women tend to live 5 years longer than men.";

  static String get man => "Man";
  static String get woman => "Woman";
  static String get other => "Other";

  static String get onboarding08Title => "What is your projected lifespan?";
  static String get onboarding08Subtitle => "This is only an estimate, you can change it anytime.";
  static String get onboarding08LifespanLabel => "PROJECTED LIFESPAN";
  static String get onboarding08ShowGrid => "Show me my grid";
  static String get onboarding08EstimateLifespan => "Feel lost? Answer 5 questions to estimate it";

  static String onboarding09Title(String name) => "$name's life in weeks.";
  static String get onboarding09Subtitle => "Every dot is a week you lived, or a week still ahead of you.";

  static String get onboarding10Title1 => "This isn't about counting time down.";
  static String get onboarding10Title2 => "It's about making each week count.";
  static String get onboarding10Subtitle => "WeeksAlive is about awareness,\nintention, and living with purpose.";
}
