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

  // weeksalive

  static String get dayLabel => "DAY";
  static String get yearLabel => "YEAR";
  static String get archivedLabel => "ARCHIVED";

  static String get feelingSectionTitle => "Average feeling";
  static String get feelingSectionValueRough => "ROUGH";
  static String get feelingSectionValueLow => "LOW";
  static String get feelingSectionValueOkay => "OKAY";
  static String get feelingSectionValueGood => "GOOD";
  static String get feelingSectionValueGreat => "GREAT";
  static String get meaningSectionTitle => "Meaning score";
  static String get meaningSectionValueNone => "NONE";
  static String get meaningSectionValueLittle => "LITTLE";
  static String get meaningSectionValueSome => "SOME";
  static String get meaningSectionValueMuch => "MUCH";
  static String get meaningSectionValueDeep => "DEEP";
  static String get newExperienceSectionTitle => "New experiences";
  static String get newExperienceSectionValueYes => "YES";
  static String get newExperienceSectionValueNo => "NO";
  static String get livingIntentionsSectionTitle => "Living your intention";
  static String get livingIntentionsSectionValueExplore => "EXPLORE";
  static String get livingIntentionsSectionValueConnect => "CONNECT";
  static String get livingIntentionsSectionValueRest => "REST";
  static String get livingIntentionsSectionValueGive => "GIVE";
  static String get livingIntentionsSectionValueLearn => "LEARN";
  static String get livingIntentionsSectionValueCreate => "CREATE";
  static String get livingIntentionsSectionValueTakeCare => "TAKE CARE";
  static String get livingIntentionsSectionValueObserve => "OBSERVE";
  static String get livingIntentionsSectionValueBePresent => "BE PRESENT";

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
  static String get weeksLabel => "WEEKS";

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
      "Your grid is unique.\nIt starts the day you were born, and it belongs to no one else.";

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

  static String get onboarding11Title1 => "Think about someone you love.";
  static String onboarding11Subtitle(int visits) =>
      "If you see them twice a year, and you're both in good health, you might have around $visits more visits together in your lifetime.";

  static String onboarding12Title(int visits) => "What $visits visits looks like in your grid.";
  static String get visitsAheadLabel => "VISITS AHEAD";
  static String get onboarding12Subtitle =>
      "This isn’t meant to feel heavy. It’s meant to make those visits feel like what they are... Precious.";

  static String get onboarding13Title => "Think about last year.";
  static String get onboarding13Subtitle => "How many weeks can you actually name?";
  static String get onboarding13Footer => "Most don\u2019t stand out because nothing made them worth noticing.";
  static String get onboarding13Footer2 => "This one doesn\u2019t have to fade.";
  static String get lastYearWeeksLabel => "LAST YEAR";
  static String get onboarding13Caption1 => "Week you remember";
  static String get onboarding13Caption2 => "Week that faded";

  static String get onboarding14Title => "Your best memories weren\u2019t planned.";
  static String get onboarding14Subtitle => "They happened in ordinary weeks, when you were not even paying attention.";
  static String get onboarding14Item1 => "The conversation that went way too deep";
  static String get onboarding14Item2 => "That moment everyone started laughing at once";
  static String get onboarding14Item3 => "When you felt exactly where you belonged";
  static String get onboarding14Footer =>
      "Notice them. Savor them. Let them count.\nYou never know the value of a moment until it becomes a memory.";

  static String get onboarding15Title1 => "Some weeks feel like years.";
  static String get onboarding15Title2 => "Others vanish like days.";
  static String get onboarding15Caption1 => "WEEK THAT STAYED";
  static String get onboarding15Caption1Value1 => "Present";
  static String get onboarding15Caption1Value2 => "Connected";
  static String get onboarding15Caption1Value3 => "Alive";
  static String get onboarding15Caption2 => "WEEK THAT FADED";
  static String get onboarding15Caption2Value1 => "Autopilot";
  static String get onboarding15Caption2Value2 => "Distracted";
  static String get onboarding15Caption2Value3 => "Rushed";
  static String get onboarding15Footer =>
      "The difference between them isn't luck. It's awareness - the simple act of deciding to show up.";

  static String get onboarding16Title1 => "Awareness is beautiful.";
  static String get onboarding16Title2 => "But it fades without a ritual.";
  static String get onboarding16Subtitle =>
      "That's why we built something to help you stay present, not just today, but every week of your life.";

  static String get onboarding17Title => "Make living a real daily habit.";
  static String get onboarding17Title2 => "Build a streak, one day at a time.";
  static String get onboarding17Subtitle => "Small ritual. Big difference.";

  static String get onboarding18Title => "One minute.\nEvery day.";
  static String get onboarding18Subtitle =>
      "A quick check-in to notice how you\u2019re really living before the day slips away.";

  static String get onboarding19Title => "Watch your grid come alive.";
  static String get onboarding19Subtitle =>
      "Every day you check in. Over time, you won't just see time passing. You'll see a life being lived.";
  static String get onboarding19Footer => "A day noticed is a day that stays.";

  static String get onboarding20Title => "What time of the day is best for you to check in?";
  static String get onboarding20Subtitle => "WeeksAlive will send you a notification to complete today's entry.";
  static String get onboarding20CheckIn => "CHECK IN";
  static String get onboardingNotificationTitle => "WeeksAlive";
  static String get onboardingNotificationSubtitle => "Time for your daily check-in.";

  static String get onboarding21Title => "Your life, always in sight.";
  static String get onboarding21Subtitle =>
      "Add your grid to your Home Screen, your Lock Screen, or your walls \u2014 a beautiful, constant reminder to live on purpose.";

  static String get onboarding22Title1 => "Your data is yours.";
  static String get onboarding22Subtitle =>
      "It never leaves your device. No ads. No tracking. No data release. Works 100% offline.";

  static String get onboarding23Title => "One small favor?";
  static String get onboarding23Subtitle =>
      "If you allow tracking on the next screen, it simply tells us which ad brought you here.\n\nNothing personal, no data sold, ever. That one signal helps us find more people who need this app and keeps us building it for you.";

  static String get onboarding25Title1 => "You have";
  static String get onboarding25Title2 => "exactly one life.";
  static String get onboarding25Title3 => "Every week,";
  static String get onboarding25Title4 => "a new chance.";
  static String get onboarding25Title5 => "To feel more.";
  static String get onboarding25Title6 => "To love more.";
  static String get onboarding25Footer => "This is that chance.";

  // paywall
  static String paywallTitle(String trialWeeks) => 'Try WeeksAlive free for $trialWeeks weeks.';
  static String get paywallCtaWithTrial => 'Start free trial';
  static String paywallCtaWithWeeks(int trialWeeks) => 'Start my $trialWeeks-week free trial';

  static String get paywallTimelineStep1Label => 'Download the app';
  static String get paywallTimelineStep1Sublabel => 'You chose to see your life differently.';
  static String get paywallTimelineStep2Label => 'Today — Free trial starts';
  static String get paywallTimelineStep2Sublabel => 'Get full access. Start shaping your grid.';
  static String paywallTimelineStep3Label(int reminderWeek) => 'Week $reminderWeek — Feel your first wins';
  static String get paywallTimelineStep3Sublabel => "Your first week is already on the grid. You'll remember this one.";
  static String paywallTimelineStep4Label(String trialWeeks) => 'Week $trialWeeks — End of trial period';
  static String paywallTimelineStep4Sublabel(String endDate) =>
      "Watch your grid growing. Cancel anytime before $endDate and you won't be charged.";

  static String paywallPriceSubtitle(int trialWeeks, String pricePerYear) =>
      '$trialWeeks weeks free, then $pricePerYear / year';
  static String paywallPricePerWeek(String pricePerWeek) => 'Only $pricePerWeek / week';

  static String get paywallFooterDisclaimer => 'Cancel anytime. Billed via App Store.';
  static String get paywallFooterTerms => 'Terms';
  static String get paywallFooterPrivacy => 'Privacy';
  static String get paywallFooterRestore => 'Restore';
  static String get paywallFooterSkip => 'Skip';

  // paywall errors
  static String get paywallErrorNetwork =>
      "We couldn't reach the App Store. Please check your connection and try again.";
  static String get paywallErrorNotAllowed => "This purchase isn't allowed on your account.";
  static String get paywallErrorAlreadyOwned => "You already have an active subscription. Tap Restore to get access.";
  static String get paywallErrorGeneric => "Something went wrong with your purchase. Please try again.";
  static String get paywallErrorRestoreNotFound => "No active subscription found for this Apple ID.";
  static String get paywallErrorRestoreGeneric => "We couldn't restore your purchase. Please try again.";

  // paywall success
  static String get paywallSuccessTitle => "You're in.";
  static String get paywallSuccessSubtitle => "Your free trial has started.\nEvery week ahead is yours to shape.";
  static String get paywallSuccessCta => "Get started";
}
