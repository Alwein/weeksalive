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
  static String get editList => "Edit list";
  static String get edit => "Edit";
  static String get saveChanges => "Save changes";
  static String get save => "Save";

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
  static String get leaveATraceSectionTitle => "Leave a trace (optional)";
  static String get leaveATraceSectionSubtitle => "A few words or a picture to describe your day";
  static String get leaveATraceSectionTextHint => "Write what made today special…";
  static String get leaveATraceSectionAddPhoto => "Add pictures";
  static String leaveATraceSectionPhotoCount(int count) => "$count picture${count > 1 ? 's' : ''}";

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
  static String get onboarding03WeekOfTheYear => "WEEK OF THE YEAR";
  static String get onboarding03Footer => "Every dot is a week you lived, or a week still ahead of you.";

  static String get onboarding03bTitle => "The life of a typical american";
  static String get onboarding03bChildhood => "YOUTH";
  static String get onboarding03bEducation => "EDUCATION";
  static String get onboarding03bCareer => "CAREER";
  static String get onboarding03bRetirement => "RETIREMENT";

  static String get iAmReady => "I\u2019m ready";

  static String get onboardingThemePickerTitle => "Choose your theme.";
  static String get onboardingThemePickerSubtitle =>
      "Pick the look that feels most like you. You can always change it later.";

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

  static String get onboarding18Title => "Every day, reflect on 4 questions.";
  static String get onboarding18Subtitle => "This will help you notice your life as it happens.";

  static String get onboarding19Title => "Day after day.\nWeek after week.";
  static String get onboarding19Subtitle => "Watch both your grids come alive.";

  static String get onboarding20Title => "What time of day for your daily check-in?";
  static String get onboarding20Subtitle => "WeeksAlive will send you a notification to complete today's entry.";
  static String get onboarding20CheckIn => "CHECK IN";
  static String get onboardingNotificationTitle => "WeeksAlive";
  static String get onboardingNotificationSubtitle => "Time for your daily check-in.";
  static String get dailyNotificationTitle => "Make this day count";
  static String get dailyNotificationBody => "It's time to check in";
  static String get weeklySummaryNotificationTitle => "Your week in review";
  static String get weeklySummaryNotificationBody => "A new week begins — see how last week went";

  static String get onboardingWeekBeginTitle => "When do you prefer the week to begin?";
  static String get onboardingWeekBeginSubtitle => "When a new dot is added to your life grid.";
  static String get onboardingWeekBeginMonday => "Default (every Monday)";
  static String onboardingWeekBeginBirthday(String weekday) => "On your birth day (every $weekday)";
  static String get onboardingWeekBeginCustom => "Custom";
  static String get onboardingWeekBeginFooter => "You can change this anytime.";

  // weekly intent onboarding
  static String get onboardingWeeklyIntentTitle => "Select what matters to you this week.";
  static String get onboardingWeeklyIntentSubtitle =>
      "Choose 1 to 3 intentions.\nNot a goal, just a guideline, at your own pace.";
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

  static String get paywallBenefit1 => 'Take back control of your time';
  static String get paywallBenefit2 => 'Track every day on your unique year grid';
  static String get paywallBenefit3 => 'Your grid, as your wallpaper & widgets';
  static String get paywallBenefit4 => 'Unlock rewards by staying consistent';

  static String get paywallReview1 =>
      "waouw that's a strong motivation app to get our important shit done! thank you!!";
  static String get paywallReview2 => 'wow..great app..makes me look life in a different perspective...';
  static String get paywallReview3 => 'This is the most concise life lesson ever. Life is important';

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
  static String get themePetale => "Pétale";
  static String get themePivoine => "Pivoine";
  static String get themeCafe => "Café";
  static String get themeMatcha => "Matcha";
  static String get themeLavande => "Lavande";
  static String get themeTerracotta => "Terracotta";
  static String get themeArdoise => "Ardoise";
  static String themeLockedStreakHint(int days) => "$days-day streak";
  static String get themeSelectedLabel => "SELECTED";

  // Home page
  static String homePageTitle(String userName) => "$userName's life";

  static List<String> get homePageDayLabels => ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];

  // day form — discard confirmation dialog
  static String get dayFormDiscardTitle => "Leave without saving?";
  static String get dayFormDiscardBody => "Your answers for today won't be recorded.";
  static String get dayFormDiscardConfirm => "Leave anyway";
  static String get dayFormDiscardCancel => "Keep going";

  // day form
  static String get feelingSectionQuestion => "How did you feel today?";
  static String get meaningSectionQuestion => "How meaningful was your time today?";
  static String get newExperienceSectionQuestion => "Something new today? A food, a place, an activity, a person…";
  static String get livingIntentionsSectionQuestion => "Did your actions reflect your weekly intentions?";
  static String get livingIntentionsSectionValueNone => "None";
  static String get livingIntentionsSectionEditLabel => "Edit weekly intentions";
  static String get leaveATraceSectionQuestion => "What made today special?";
  static String get consecutiveDay => "consecutive day";
  static String get consecutiveDays => "consecutive days";
  static String get congratulations => "Well done!";
  static String get streakGraceReminderTitle => "No worries";
  static String get streakGraceReminderBody =>
      "Missing a day happens. You still have 24 extra hours to log yesterday and keep your streak going.";
  static String get streakGraceReminderLogYesterday => "Log yesterday";
  static String get streakGraceReminderDismiss => "Got it";

  // streaks rewards page
  static String get streaksPageTitle => "Streak rewards";
  static String streaksPageSubtitle(int bestStreak) =>
      "Reach streak milestones to unlock themes, app icons, and grid motifs. Your best streak: $bestStreak days.";
  static String get streaksCurrentStreak => "CURRENT STREAK";
  static String get streaksCategoryTheme => "Theme";
  static String get streaksCategoryAppIcon => "App icon";
  static String get streaksCategoryGridMotif => "Grid motif";
  static String streaksNextRewardIn(int days) => days == 1 ? "Next reward in 1 day" : "Next reward in $days days";
  static String streaksRewardUnlockedTitle(int count) =>
      count == 1 ? "New reward unlocked" : "$count new rewards unlocked";
  static String get streaksRewardUnlockedBody => "You can customize it right away.";
  static String get streaksOpenThemePicker => "Browse themes";
  static String get streaksOpenAppIconPicker => "Choose app icon";
  static String get streaksOpenGridMotifPicker => "Choose grid motif";

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

  // day form confirmation page
  static String get dayFormConfirmationTitle => "Daily awareness";
  static String get dayFormConfirmationSubtitle => "Check-in complete.";
  static String get dayFormConfirmationJournalOnlyHint => "Added to your journal — does not count toward your streak.";
  static String get dayFormConfirmationSave => "Save and finish";
  static List<String> get dayFormConfirmationPositiveAffirmations => [
    "You're becoming more mindful of your time.",
    "You see clearly where your time goes.",
    "Every moment tracked is a moment understood.",
    "You're in tune with how you spend your days.",
    "Tomorrow is an opportunity to work on what truly counts.",
    "You're building a life of intention.",
    "You showed up today, that matters.",
    "You're making your time count.",
    "Awareness is the first step to change.",
    "You're choosing where your energy flows.",
    "Your hours reflect your priorities.",
    "You're investing in what matters most.",
    "Each day, you understand yourself a little more.",
    "You're taking ownership of your time.",
    "Small, intentional moments add up.",
    "You're aligning your time with your values.",
    "Progress lives in the choices you make today.",
    "You're learning what truly deserves your focus.",
    "Your time is yours to shape.",
    "You're growing more honest about your habits.",
    "Every entry brings greater clarity.",
    "You're designing your days with purpose.",
    "You're present with how you live.",
    "Mindful tracking leads to meaningful living.",
    "You're honoring your time and your goals.",
    "You're one step closer to balance.",
    "Reflection today builds wisdom for tomorrow.",
    "You're spending time like it matters, because it does.",
    "You're turning awareness into action.",
    "Your focus is becoming your superpower.",
    "You're living more deliberately every day.",
  ];

  // day resume bottom sheet
  static String get dayResumeBottomSheetEmptySubtitle => "No entry for this day.";
  static String get startTracking => "Start tracking";

  // profile page
  static String get profilePageTitle => "Profile";
  static String get profilePageBorn => "BORN";
  static String get profilePageAge => "AGE";
  static String get profilePageLifespan => "LIFESPAN";
  static String get profilePageGender => "GENDER";
  static String profilePageLifespanValue(int lifespan) => "$lifespan years";
  static String get profilePageYearsAhead => "YEARS AHEAD";
  static String get profilePagePreferences => "PREFERENCES";
  static String get profilePageAppearance => "APPEARANCE";
  static String get profilePageGetInTouch => "GET IN TOUCH";
  static String get profilePageWidgetsWallpaper => "FEATURES";
  static String get profilePageApplication => "APPLICATION";
  static String get profilePageNotifications => "Notifications";
  static String get profilePageWeeklyIntentions => "Weekly intentions";
  static String get profilePageTheme => "Theme";
  static String get profilePageGridMotif => "Grid motif";
  static String get profilePageWallpaper => "Wallpaper";
  static String get profilePageWidgets => "Widgets";
  static String get profilePageWidgetsDescription => "4 available";
  static String get profilePageAppIcon => "App icon";
  static String get appIconComposer => "Default";
  static String get appIconLight => "Light";
  static String get appIconGrid => "Grid";
  static String get appIconSilver => "Silver";
  static String get appIconSisyphus => "Sisyphus";
  static String get appIconGold => "Gold";
  static String get gridMotifDots => "Circles";
  static String get gridMotifSquares => "Squares";
  static String get gridMotifFlowers => "Flowers";
  static String get gridMotifDraw => "Draw";
  static String get gridMotifEmoji => "Emoji";
  static String get gridMotifMoons => "Moons";
  static String get profilePageWallpaperConfigured => "ON";
  static String get profilePageWallpaperNotConfigured => "OFF";
  static String get profilePageWallpaperSetupGuide => "Wallpaper setup guide";
  static String get profilePageWallpaperSetupGuideDescription => "~2 min";
  static String get profilePageWeekBegin => "Week begin";
  static String get profilePageRateTheApp => "Rate the app";
  static String get profilePageSuggestAFeature => "Suggest a feature";
  static String get profilePageReportABug => "Report a bug";

  static String get profilePageTermsOfService => "Terms of service";
  static String get profilePagePrivacyPolicy => "Privacy policy";

  static String get profilePageNotificationsEnabled => "ON";
  static String get profilePageNotificationsDisabled => "OFF";
  static String get profilePageRevenueCatIdCopied => "Purchase ID copied";

  // edit profile page
  static String get editProfilePageTitle => "Edit profile";
  static String get editProfilePageName => "Name";
  static String get editProfilePageDateOfBirth => "Date of birth";
  static String get editProfilePageGender => "Gender";
  static String get editProfilePageLifespan => "Lifespan";

  // week begin page
  static String get weekBeginPageTitle => "Week begin";

  // notifications settings page
  static String get notificationsSettingsPageTitle => "Notifications";
  static String get notificationsSettingsPageDailySlots => "Daily check-in";
  static String get notificationsSettingsPageWeeklySlot => "Weekly recap";
  static String get notificationsSettingsPageDailySlot1 => "Daily check-in 1";
  static String get notificationsSettingsPageDailySlot2 => "Daily check-in 2";
  static String notificationsSettingsPageWeeklySlotDay(String weekday) => "Every $weekday";
  static String get notificationsSettingsPageDisabledMessage =>
      "Push notifications are disabled on your device. Enable them in your phone settings to receive daily reminders.";
  static String get notificationsSettingsPageOpenSettings => "Open settings";

  // weekly summary page
  static List<String> get monthNames => [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static String get weeklySummaryPageTitle => "Week complete";
  static String get weeklySummaryPageSubtitle => "One dot has been added to your life grid.";
  static String get weeklySummaryDetailsPageTitle => "Your week in review";
  static String get weeklySummaryPageAverageFeeling => "AVERAGE FEELING";
  static String get weeklySummaryPageMeaningScore => "MEANING SCORE";
  static String get weeklySummaryPageNewExperiences => "NEW EXPERIENCES";
  static String get weeklySummaryPageLivingIntentions => "LIVING INTENTIONS";
  static String get weeklySummaryPageRegularity => "REGULARITY";
  static String get weeklySummaryPageSeeMore => "Start a new week";

  static String get suggestAFeatureSubject => "[EN] Suggest a feature - WeeksAlive";
  static String get suggestAFeatureBody => "Hi, I have a suggestion for WeeksAlive:\n\n";

  static String get reportABugSubject => "[EN] Report a bug - WeeksAlive";
  static String get reportABugBody => "Hi, I have a bug report for WeeksAlive:\n\n";

  // wallpaper editor
  static String get wallpaperPageTitle => "Wallpaper";
  static String get wallpaperGridSectionTitle => "Grid";
  static String get wallpaperGridLife => "Life";
  static String get wallpaperGridYear => "Year";
  static String get wallpaperAppearanceSectionTitle => "Appearance";
  static String get wallpaperBrightness => "Brightness";
  static String get wallpaperBrightnessLight => "Light";
  static String get wallpaperBrightnessDark => "Dark";
  static String get wallpaperBackgroundSectionTitle => "Background";
  static String get wallpaperBackgroundSolid => "Solid";
  static String get wallpaperBackgroundGradient => "Gradient";
  static String get wallpaperBackgroundImage => "Image";
  static String get wallpaperPickImage => "Pick image";
  static String get wallpaperChangeImage => "Change image";
  static String get wallpaperImageDim => "Luminosity";
  static String get wallpaperImageBlur => "Blur";
  static String get wallpaperGridOpacity => "Grid opacity";
  static String get wallpaperGridLayoutSectionTitle => "Layout";
  static String get wallpaperGridScale => "Size";
  static String get wallpaperGridVerticalOffset => "Vertical position";
  static String wallpaperGridScaleValue(double scale) => '${(scale * 100).round()}%';
  static String wallpaperGridVerticalOffsetValue(double offset) {
    final percent = (offset * 100).round();
    if (percent == 0) return 'Center';
    return percent > 0 ? '↓ $percent%' : '↑ ${percent.abs()}%';
  }

  static String get wallpaperThemeSectionTitle => "Theme";
  static String get wallpaperBackgroundImageSectionTitle => "Background image";
  static String get wallpaperAddImage => "Add image";
  static String get wallpaperInstall => "Activate wallpaper";
  static String get wallpaperUpdate => "Update wallpaper";
  static String get wallpaperInstallAction => "Activate";
  static String get wallpaperUpdateAction => "Update";
  static String get wallpaperAutomaticTitle => "Automatic wallpaper";
  static String get wallpaperAutomaticUpdatesDaily => "Updates daily";
  static String get wallpaperAutomaticUpdatesWeekly => "Updates weekly";
  static String get wallpaperAutomaticUpdatesOff => "Automatic updates are off";
  static String get wallpaperDisableTitle => "Stop automatic updates?";
  static String get wallpaperDisableMessage =>
      "WeeksAlive will stop updating your wallpaper. Your current wallpaper will stay until you change it in your phone settings.";
  static String get wallpaperDisableConfirm => "Stop updates";
  static String get wallpaperDisableCancel => "Keep active";
  static String get wallpaperDisabledShortcutsMessage =>
      "To fully stop wallpaper updates, delete the automation in the Shortcuts app.";

  static String get wallpaperSetupTitle => "Wallpaper set up ~2 min";
  static String get wallpaperSetupSubtitle =>
      "Follow this guide to make your lock screen wallpaper update automatically every day.";
  static String get wallpaperSetupShortcutTitle => "Open Shortcuts app";
  static String get wallpaperOpenShortcuts => "Open Shortcuts";
  static String get wallpaperSetupShowPreview => "Show me how";
  static String get wallpaperSetupExpandAll => "Expand all";
  static String get wallpaperSetupCollapseAll => "Collapse all";
  static String get wallpaperSetupGoToShortcutsPage => "Go to the Automation tab";
  static String get wallpaperSetupCreateAutomation => "Create a new automation";
  static String get wallpaperSetupSelectTimeOfDay => "Select Time of Day";
  static String get wallpaperSetupSelect => "Select → Time of Day → Daily → Run Immediately";
  static String wallpaperSetupSelectDescription(String time) =>
      "$time is the recommended time based on your notification settings. So your wallpaper will update after you check in.";
  static String get wallpaperSetupCreateNewShortcut => "Create new shortcut";
  static String get wallpaperSetupSearchAndAddGetWallpaper =>
      "Search and add \"Get Wallpaper\""; // note "Get Wallpaper" is not translated
  static String get wallpaperSetupSearchAndAddSetWallpaperPhoto => "Search and add \"Set Wallpaper Photo\"";
  static String get wallpaperSetupClickOnLockScreenAndHomeScreen => "Tap \"Lock Screen and Home Screen\"";
  static String get wallpaperSetupUnselectHomeScreen => "Keep only \"Lock Screen\"";
  static String get wallpaperSetupUnselectHomeScreenDescription =>
      "You can select \"Home Screen\" if you want your life grid to be visible on your home screen.";
  static String get wallpaperSetupClickOnExpandArrow => "Tap the arrow on Set Wallpaper Photo to show more options";
  static String get wallpaperSetupUnselectShowPreviewAndCropToSubject =>
      "Unselect \"Show Preview\" and \"Crop to Subject\"";
  static String get wallpaperSetupUnselectShowPreviewAndCropToSubjectDescription =>
      "So the automation runs without asking every day.";
  static String get wallpaperSetupPressRunButton => "Tap Run to activate the automation";
  static String get wallpaperSetupYouAreAllSet => "Tap Done to save. You’re all set!";

  // widgets page
  static String get profilePageWidgetsLifeGrid => "LIFE GRID";
  static String get profilePageWidgetsYearGrid => "YEAR GRID";
}
