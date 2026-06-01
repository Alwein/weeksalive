import 'package:easy_localization/easy_localization.dart';

class Strings {
  static String get appName => "WEEKSALIVE";

  // force update page
  static String get forceUpdateTitle => tr('force_update_title');
  static String get forceUpdateSubtitle => tr('force_update_subtitle');
  static String get forceUpdateButton => tr('force_update_button');

  // common
  static String get next => tr('next');
  static String get done => tr('done');
  static String get continueString => tr('continue');
  static String get editName => "Edit name";
  static String get custom => "Custom";

  // weeksalive

  static String get dayLabel => "DAY";
  static String get yearLabel => "YEAR";
  static String get archivedLabel => "ARCHIVED";

  static String get homeGridTabLife => "Life";
  static String get homeGridTabYear => "Year";
  static String get today => "Today";

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
  static String get daysLabel => "DAYS";

  // onboarding
  static String get onboarding01Subtitle => "A gentle reminder\nthat your time is precious";

  static String get onboarding02Title1 => "Life feels long.";
  static String get onboarding02Title2 => "Until it doesn\u2019t.";
  static String get onboarding02Subtitle =>
      "Most of us move through weeks without really feeling them. Until we look back and wonder where the years went.";

  static String get onboarding03Title => "Your life is made of weeks.";
  static String get onboarding03Subtitle => "Birthdays, heartbreaks, Tuesdays.\nEvery one is here.";
  static String get onboarding03Footer => "Every dot is a week you lived, or a week still ahead of you.";

  static String get iAmReady => "I\u2019m ready";

  static String get onboarding04Title => "Let's build your own grid.";
  static String get onboarding04Subtitle =>
      "Your grid is unique.\nIt starts the day you were born, and it belongs to no one else.";

  static String get onboarding05Title => "Type your name or a nickname.";
  static String get onboarding05Hint => "Nickname";

  static String get onboarding06Title => "What is your date of birth?";
  static String get onboarding06DateOfBirth => "DATE OF BIRTH";

  static String get onboarding07Title => "What's your biological sex?";
  static String get onboarding07Subtitle => "Women tend to live 5 years longer than men.";

  static String get man => "Man";
  static String get woman => "Woman";
  static String get other => "Other";

  static String get onboarding08Title => "How long do you expect to live?";
  static String get onboarding08Subtitle => "This is only an estimate, you can change it anytime.";
  static String get onboarding08LifespanLabel => "PROJECTED LIFESPAN";
  static String get onboarding08ShowGrid => "Show me my grid";

  static String onboarding09Title(String name) => "$name's life in weeks.";
  static String get onboarding09Subtitle => "Every dot is a week you lived, or a week still ahead of you.";
  static String get onboarding09LoadingLabel => "Building your life grid\u2026";

  static String onboarding09BirthdaysTitle(int count) => "You have $count birthdays ahead.";

  static String onboarding09WintersTitle(int count) => "You have $count weeks of winter ahead.";

  static String onboarding09OlympicsTitle(int count) => "You have $count Olympic games ahead.";
  static String get onboarding09dThisYearTitle => "How? Let's zoom into this year.";

  static String onboarding27OneYearButTitle(int georgianDays) => "This year has $georgianDays days.\nOkay but…";

  static String get livedLabel => "LIVED";
  static String get aheadLabel => "AHEAD";
  static String get thisYearLabel => "THIS YEAR";
  static String get livedDaysLabel => "LIVED DAYS";

  static String get onboarding10Title1 => "This isn't about counting time down.";
  static String get onboarding10Title2 => "It's about making each week count.";
  static String get onboarding10Subtitle => "WeeksAlive is about awareness,\nintention, and living with purpose.";

  static String get onboarding11Title1 => "Think about someone you love.";
  static String onboarding11Subtitle(int visits) =>
      "If you see them twice a year, and you're both in good health, you might have around $visits more visits together in your lifetime.";

  static String onboarding12Title(int visits) => "What $visits visits look like in your grid.";
  static String get visitsAheadLabel => "VISITS AHEAD";
  static String get onboarding12Subtitle =>
      "This isn’t meant to feel heavy. It’s meant to make those visits feel like what they are — precious.";

  static String get onboardingButAddLifeTitle1 => "You can’t add weeks to your life.";
  static String get onboardingButAddLifeBut => "BUT";
  static String get onboardingButAddLifeTitle2 => "You can add life to your weeks.";

  static String get onboarding13Title => "This is what it actually feels like.";
  static String get onboarding13Footer =>
      "Same 365 days. Each dot is a day. Its size is the weight it carries in your perception.";
  static String get onboarding13Caption1 => "Week you remember";
  static String get onboarding13Caption2 => "Week that faded";

  static String get onboarding15Title => "Not all days carry the same weight in our brain.";
  static String get onboarding15LeftLabel1 => "Rushed";
  static String get onboarding15LeftLabel2 => "Autopilot";
  static String get onboarding15LeftLabel3 => "Forgotten";
  static String get onboarding15RightLabel1 => "Present";
  static String get onboarding15RightLabel2 => "Intentional";
  static String get onboarding15RightLabel3 => "Remembered";
  static String get onboarding15Footer =>
      "Studies show that novelty, emotion, and presence can stretch time itself.\nThe more you notice your life as it happens, the more of it you get to keep.";

  static String get onboarding17Title => "That’s why WeeksAlive exists.";
  static String get onboarding17Title2 => "Not to track time\nTo help you feel it.";
  static String get onboarding17Subtitle => "A simple daily ritual to notice your life as it happens.";

  static String get onboarding18Title => "Answer 4 questions every day.";
  static String get onboarding18Subtitle => "A few quick questions about how today felt.";

  static String get onboarding19Title => "Day after day.\nWeek after week.";
  static String get onboarding19Subtitle => "Watch both your grids come alive.";

  static String get onboarding20Title => "What time of day for your daily check-in?";
  static String get onboarding20Subtitle => "WeeksAlive will send you a notification to complete today's entry.";
  static String get onboarding20CheckIn => "CHECK IN";
  static String get onboardingNotificationTitle => "WeeksAlive";
  static String get onboardingNotificationSubtitle => "Time for your daily check-in.";
  static String get dailyNotificationTitle => "Make this day count";
  static String get dailyNotificationBody => "It's time to check in";

  static String get onboardingWeekBeginTitle => "When do you prefer the week to begin?";
  static String get onboardingWeekBeginSubtitle => "When a new dot is added to your life grid.";
  static String get onboardingWeekBeginMonday => "On every monday";
  static String onboardingWeekBeginBirthday(String weekday) => "On your birth day (every $weekday)";
  static String get onboardingWeekBeginCustom => "Custom";
  static String get onboardingWeekBeginFooter => "You can change this anytime.";

  // weekly intent onboarding
  static String get onboardingWeeklyIntentTitle => "Select what matters to you this week.";
  static String get onboardingWeeklyIntentSubtitle =>
      "Choose up to 3 intentions.\nNot a goal, just a guideline, at your own pace.";
  static String get onboardingWeeklyIntentFooter => "Your intentions reset every week.";

  static List<String> get weekdayFullNames => [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static List<String> get weekdayShortNames => ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];

  static String get onboarding21Title => "Your life, always in sight.";
  static String get onboarding21Subtitle =>
      "Add your grid to your Home Screen, your Lock Screen, or your walls \u2014 a beautiful, constant reminder to live on purpose.";

  static String get onboarding22Title1 => "Do you like it so far?";
  static String get onboarding22Subtitle =>
      "91% of people using WeeksAlive say it helps them getting the most of their time";

  static String get onboarding23Title1 => "Your data is yours.";
  static String get onboarding23Subtitle =>
      "It never leaves your device. No ads. No data release. Works 100% offline.\n\nIf you allow tracking on the next screen, it simply tells us which ad brought you here.\n\nNothing personal, no data sold, ever. That one signal help us find more people who need this app an keeps us building it for you.";

  static String get onboarding25Title1 => "You have";
  static String get onboarding25Title2 => "exactly one life.";
  static String get onboarding25Title3 => "Every week,";
  static String get onboarding25Title4 => "a new chance.";
  static String get onboarding25Title5 => "To feel more.";
  static String get onboarding25Title6 => "To love more.";
  static String get onboarding25Footer => "Will you take this chance?";

  static String get onboarding24Title => "Next steps";
  static String onboarding24PlanHeader(String planName) => "Plan for $planName";
  static String get onboarding24TodaySection => "Today";
  static String onboarding24TodayDescription(String preferedTime) =>
      "Take 60 seconds at $preferedTime to notice how today really felt.";
  static String get onboarding24ThisWeekSection => "This week";
  static String onboarding24ThisWeekDescription(List<String> intentions) =>
      "Live with your ${intentions.length} itentions : ${intentions.join(", ")}";
  static String get onboarding24NextWeekSection => "Next week";
  static String onboarding24NextWeekDescription(String weekday) =>
      "One dot is added to your life grid.\nOn $weekday, your week closes with a short recap. ";

  // paywall
  static String paywallTitle(String trialWeeks) => 'Try WeeksAlive free for $trialWeeks weeks.';
  static String get paywallCtaWithTrial => 'Start free trial';
  static String paywallCtaWithWeeks(int trialWeeks) => 'Start my $trialWeeks-week free trial';

  static String get paywallTimelineStep1Label => 'Download the app';
  static String get paywallTimelineStep1Sublabel => 'You chose to see your life differently.';
  static String get paywallTimelineStep2Label => 'Today — Free trial starts';
  static String get paywallTimelineStep2Sublabel => 'Full access unlocked. Start shaping your grid.';
  static String paywallTimelineStep3Label(int reminderWeek) => 'Week $reminderWeek — Get a reminder';
  static String get paywallTimelineStep3Sublabel =>
      "Your first week is already on the grid. We'll let you know when your trial is ending.";
  static String paywallTimelineStep4Label(String trialWeeks) => 'Week $trialWeeks — End of trial period';
  static String paywallTimelineStep4Sublabel(String endDate) =>
      "Watch your grid growing. Cancel anytime before $endDate and you won't be charged.";

  static String paywallPriceSubtitle(int trialWeeks, String pricePerYear) =>
      '$trialWeeks weeks free, then $pricePerYear / year';
  static String paywallPricePerWeek(String pricePerWeek) => 'Only $pricePerWeek / week';

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

  // theme
  static String get themePickerTitle => "THEME";
  static String get themeSystem => "System";
  static String get themeLight => "Light";
  static String get themeDark => "Dark";

  // Home page
  static String homePageTitle(String userName) => "$userName's life";

  static List<String> get homePageDayLabels => ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];

  // day form
  static String get feelingSectionQuestion => "How did you feel today?";
  static String get meaningSectionQuestion => "How meaningful was your time today?";
  static String get newExperienceSectionQuestion => "Did you try something new today?";
  static String get livingIntentionsSectionQuestion => "Did your actions reflect your weekly intentions?";
  static String get livingIntentionsSectionValueNone => "None";
  static String get livingIntentionsSectionEditLabel => "Edit";

  // weekly intent
  static String get intentBePresent => "Be Present";
  static String get intentExplore => "Explore";
  static String get intentConnect => "Connect";
  static String get intentRest => "Rest";
  static String get intentGive => "Give";
  static String get intentLearn => "Learn";
  static String get intentCreate => "Create";
  static String get intentTakeCare => "Take Care";
  static String get intentObserve => "Observe";

  static String get editWeeklyIntentsTitle => "Your intentions";
  static String get editWeeklyIntentsAddCustomLabel => "ADD A CUSTOM INTENTION";
  static String get editWeeklyIntentsCustomHint => "Anything\u2026";
  static String get editWeeklyIntentsAdd => "Add";
}
