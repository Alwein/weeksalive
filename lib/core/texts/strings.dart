import 'package:easy_localization/easy_localization.dart';

class Strings {
  static String get appName => tr('app_name');

  // force update page
  static String get forceUpdateTitle => tr('force_update_title');
  static String get forceUpdateSubtitle => tr('force_update_subtitle');
  static String get forceUpdateButton => tr('force_update_button');

  // common
  static String get next => tr('next');
  static String get done => tr('done');
  static String get continueString => tr('continue');
  static String get editName => tr('edit_name');
  static String get editList => tr('edit_list');
  static String get edit => tr('edit');
  static String get saveChanges => tr('save_changes');
  static String get save => tr('save');
  static String get none => tr('none');

  // weeksalive

  static String get dayLabel => tr('day_label');
  static String get yearLabel => tr('year_label');
  static String get archivedLabel => tr('archived_label');

  static String get homeGridTabLife => tr('home_grid_tab_life');
  static String get homeGridTabYear => tr('home_grid_tab_year');
  static String get today => tr('today');

  static String get feelingSectionTitle => tr('feeling_section_title');
  static String get feelingSectionValueRough => tr('feeling_section_value_rough');
  static String get feelingSectionValueLow => tr('feeling_section_value_low');
  static String get feelingSectionValueOkay => tr('feeling_section_value_okay');
  static String get feelingSectionValueGood => tr('feeling_section_value_good');
  static String get feelingSectionValueGreat => tr('feeling_section_value_great');
  static String get meaningSectionTitle => tr('meaning_section_title');
  static String get meaningSectionValueNone => tr('meaning_section_value_none');
  static String get meaningSectionValueLittle => tr('meaning_section_value_little');
  static String get meaningSectionValueSome => tr('meaning_section_value_some');
  static String get meaningSectionValueMuch => tr('meaning_section_value_much');
  static String get meaningSectionValueDeep => tr('meaning_section_value_deep');
  static String get newExperienceSectionTitle => tr('new_experience_section_title');
  static String get newExperienceSectionValueYes => tr('new_experience_section_value_yes');
  static String get newExperienceSectionValueNo => tr('new_experience_section_value_no');
  static String get livingIntentionsSectionTitle => tr('living_intentions_section_title');
  static String get livingIntentionsSectionValueExplore => tr('living_intentions_section_value_explore');
  static String get livingIntentionsSectionValueConnect => tr('living_intentions_section_value_connect');
  static String get livingIntentionsSectionValueRest => tr('living_intentions_section_value_rest');
  static String get livingIntentionsSectionValueGive => tr('living_intentions_section_value_give');
  static String get livingIntentionsSectionValueLearn => tr('living_intentions_section_value_learn');
  static String get livingIntentionsSectionValueCreate => tr('living_intentions_section_value_create');
  static String get livingIntentionsSectionValueTakeCare => tr('living_intentions_section_value_take_care');
  static String get livingIntentionsSectionValueObserve => tr('living_intentions_section_value_observe');
  static String get livingIntentionsSectionValueBePresent => tr('living_intentions_section_value_be_present');
  static String get leaveATraceSectionTitle => tr('leave_a_trace_section_title');
  static String get leaveATraceSectionSubtitle => tr('leave_a_trace_section_subtitle');
  static String get leaveATraceSectionTextHint => tr('leave_a_trace_section_text_hint');
  static String get leaveATraceSectionAddPhoto => tr('leave_a_trace_section_add_photo');
  static String leaveATraceSectionPhotoCount(int count) => plural('leave_a_trace_section_photo_count', count);

  // In app feedback
  static String get inAppFeedbackTitle => tr('in_app_feedback_title');
  static String get inAppFeedbackSubtitle => tr('in_app_feedback_subtitle');
  static String get inAppFeedbackHint => tr('in_app_feedback_hint');
  static String get inAppFeedbackConfirmationTitle => tr('in_app_feedback_confirmation_title');
  static String get quickActionFeedbackTitle => tr('quick_action_feedback_title');
  static String get quickActionFeedbackSubtitle => tr('quick_action_feedback_subtitle');

  // Life grid
  static String get progressLabel => tr('progress_label');
  static String get weekLabel => tr('week_label');
  static String get weeksLabel => tr('weeks_label');
  static String get daysLabel => tr('days_label');

  // onboarding
  static String get onboarding01Subtitle => tr('onboarding_01_subtitle');

  static String get onboarding02Title1 => tr('onboarding_02_title_1');
  static String get onboarding02Title2 => tr('onboarding_02_title_2');
  static String get onboarding02Subtitle => tr('onboarding_02_subtitle');

  static String get onboarding03Title => tr('onboarding_03_title');
  static String get onboarding03Subtitle => tr('onboarding_03_subtitle');
  static String get onboarding03WeekOfTheYear => tr('onboarding_03_week_of_the_year');
  static String get onboarding03Footer => tr('onboarding_03_footer');

  static String get onboarding03bTitle => tr('onboarding_03b_title');
  static String get onboarding03bChildhood => tr('onboarding_03b_childhood');
  static String get onboarding03bEducation => tr('onboarding_03b_education');
  static String get onboarding03bCareer => tr('onboarding_03b_career');
  static String get onboarding03bRetirement => tr('onboarding_03b_retirement');

  static String get iAmReady => tr('i_am_ready');

  static String get onboardingThemePickerTitle => tr('onboarding_theme_picker_title');
  static String get onboardingThemePickerSubtitle => tr('onboarding_theme_picker_subtitle');

  static String get onboarding04Title => tr('onboarding_04_title');
  static String get onboarding04Subtitle => tr('onboarding_04_subtitle');

  static String get onboarding05Title => tr('onboarding_05_title');
  static String get onboarding05Hint => tr('onboarding_05_hint');

  static String get onboarding06Title => tr('onboarding_06_title');
  static String get onboarding06DateOfBirth => tr('onboarding_06_date_of_birth');

  static String get onboarding07Title => tr('onboarding_07_title');
  static String get onboarding07Subtitle => tr('onboarding_07_subtitle');

  static String get man => tr('man');
  static String get woman => tr('woman');
  static String get other => tr('other');

  static String get onboarding08Title => tr('onboarding_08_title');
  static String get onboarding08Subtitle => tr('onboarding_08_subtitle');
  static String get onboarding08LifespanLabel => tr('onboarding_08_lifespan_label');
  static String get onboarding08ShowGrid => tr('onboarding_08_show_grid');

  static String onboarding09Title(String name) =>
      tr('onboarding_09_title', namedArgs: {'name': name});
  static String get onboarding09Subtitle => tr('onboarding_09_subtitle');
  static String get onboarding09LoadingLabel => tr('onboarding_09_loading_label');

  static String onboarding09BirthdaysTitle(int count) =>
      tr('onboarding_09_birthdays_title', namedArgs: {'count': '$count'});

  static String onboarding09WintersTitle(int count) =>
      tr('onboarding_09_winters_title', namedArgs: {'count': '$count'});

  static String onboarding09OlympicsTitle(int count) =>
      tr('onboarding_09_olympics_title', namedArgs: {'count': '$count'});
  static String get onboarding09dThisYearTitle => tr('onboarding_09d_this_year_title');

  static String onboarding27OneYearButTitle(int georgianDays) =>
      tr('onboarding_27_one_year_but_title', namedArgs: {'georgian_days': '$georgianDays'});

  static String get livedLabel => tr('lived_label');
  static String get aheadLabel => tr('ahead_label');
  static String get thisYearLabel => tr('this_year_label');
  static String get livedDaysLabel => tr('lived_days_label');

  static String get onboarding10Title1 => tr('onboarding_10_title_1');
  static String get onboarding10Title2 => tr('onboarding_10_title_2');
  static String get onboarding10Subtitle => tr('onboarding_10_subtitle');

  static String get onboarding11Title1 => tr('onboarding_11_title_1');
  static String onboarding11Subtitle(int visits) =>
      tr('onboarding_11_subtitle', namedArgs: {'visits': '$visits'});

  static String onboarding12Title(int visits) =>
      tr('onboarding_12_title', namedArgs: {'visits': '$visits'});
  static String get visitsAheadLabel => tr('visits_ahead_label');
  static String get onboarding12Subtitle => tr('onboarding_12_subtitle');

  static String get onboardingButAddLifeTitle1 => tr('onboarding_but_add_life_title_1');
  static String get onboardingButAddLifeBut => tr('onboarding_but_add_life_but');
  static String get onboardingButAddLifeTitle2 => tr('onboarding_but_add_life_title_2');

  static String get onboarding13Title => tr('onboarding_13_title');
  static String get onboarding13Footer => tr('onboarding_13_footer');
  static String get onboarding13Caption1 => tr('onboarding_13_caption_1');
  static String get onboarding13Caption2 => tr('onboarding_13_caption_2');

  static String get onboarding15Title => tr('onboarding_15_title');
  static String get onboarding15LeftLabel1 => tr('onboarding_15_left_label_1');
  static String get onboarding15LeftLabel2 => tr('onboarding_15_left_label_2');
  static String get onboarding15LeftLabel3 => tr('onboarding_15_left_label_3');
  static String get onboarding15RightLabel1 => tr('onboarding_15_right_label_1');
  static String get onboarding15RightLabel2 => tr('onboarding_15_right_label_2');
  static String get onboarding15RightLabel3 => tr('onboarding_15_right_label_3');
  static String get onboarding15Footer => tr('onboarding_15_footer');

  static String get onboarding17Title => tr('onboarding_17_title');
  static String get onboarding17Title2 => tr('onboarding_17_title_2');
  static String get onboarding17Subtitle => tr('onboarding_17_subtitle');

  static String get onboarding18Title => tr('onboarding_18_title');
  static String get onboarding18Subtitle => tr('onboarding_18_subtitle');

  static String get onboarding19Title => tr('onboarding_19_title');
  static String get onboarding19Subtitle => tr('onboarding_19_subtitle');

  static String get onboarding20Title => tr('onboarding_20_title');
  static String get onboarding20Subtitle => tr('onboarding_20_subtitle');
  static String get onboarding20CheckIn => tr('onboarding_20_check_in');
  static String get onboardingNotificationTitle => tr('onboarding_notification_title');
  static String get onboardingNotificationSubtitle => tr('onboarding_notification_subtitle');
  static String get dailyNotificationTitle => tr('daily_notification_title');
  static String get dailyNotificationBody => tr('daily_notification_body');
  static String get dailyFollowupNotificationTitle => tr('daily_followup_notification_title');
  static String get dailyFollowupNotificationBody => tr('daily_followup_notification_body');
  static String get streakSaveNotificationTitle => tr('streak_save_notification_title');
  static String streakSaveNotificationBody(int count) =>
      tr('streak_save_notification_body', namedArgs: {'count': '$count'});
  static String get weeklySummaryNotificationTitle => tr('weekly_summary_notification_title');
  static String get weeklySummaryNotificationBody => tr('weekly_summary_notification_body');

  static String get onboardingWeekBeginTitle => tr('onboarding_week_begin_title');
  static String get onboardingWeekBeginSubtitle => tr('onboarding_week_begin_subtitle');
  static String get onboardingWeekBeginMonday => tr('onboarding_week_begin_monday');
  static String onboardingWeekBeginBirthday(String weekday) =>
      tr('onboarding_week_begin_birthday', namedArgs: {'weekday': weekday});
  static String get onboardingWeekBeginCustom => tr('onboarding_week_begin_custom');
  static String get onboardingWeekBeginFooter => tr('onboarding_week_begin_footer');

  // weekly intent onboarding
  static String get onboardingWeeklyIntentTitle => tr('onboarding_weekly_intent_title');
  static String get onboardingWeeklyIntentSubtitle => tr('onboarding_weekly_intent_subtitle');
  static String get onboardingWeeklyIntentFooter => tr('onboarding_weekly_intent_footer');

  static List<String> get weekdayFullNames => [
    tr('weekday_monday'),
    tr('weekday_tuesday'),
    tr('weekday_wednesday'),
    tr('weekday_thursday'),
    tr('weekday_friday'),
    tr('weekday_saturday'),
    tr('weekday_sunday'),
  ];

  static List<String> get weekdayShortNames => [
    tr('weekday_short_mo'),
    tr('weekday_short_tu'),
    tr('weekday_short_we'),
    tr('weekday_short_th'),
    tr('weekday_short_fr'),
    tr('weekday_short_sa'),
    tr('weekday_short_su'),
  ];

  static String get onboarding21Title => tr('onboarding_21_title');
  static String get onboarding21Subtitle => tr('onboarding_21_subtitle');

  static String get onboarding22Title1 => tr('onboarding_22_title_1');

  static String get onboarding23Title1 => tr('onboarding_23_title_1');
  static String get onboarding23Subtitle => tr('onboarding_23_subtitle');

  static String get onboarding25Title1 => tr('onboarding_25_title_1');
  static String get onboarding25Title2 => tr('onboarding_25_title_2');
  static String get onboarding25Title3 => tr('onboarding_25_title_3');
  static String get onboarding25Title4 => tr('onboarding_25_title_4');
  static String get onboarding25Title5 => tr('onboarding_25_title_5');
  static String get onboarding25Title6 => tr('onboarding_25_title_6');
  static String get onboarding25Footer => tr('onboarding_25_footer');

  static String get onboarding24Title => tr('onboarding_24_title');
  static String onboarding24PlanHeader(String planName) =>
      tr('onboarding_24_plan_header', namedArgs: {'plan_name': planName});
  static String get onboarding24TodaySection => tr('onboarding_24_today_section');
  static String onboarding24TodayDescription(String preferedTime) =>
      tr('onboarding_24_today_description', namedArgs: {'preferred_time': preferedTime});
  static String get onboarding24ThisWeekSection => tr('onboarding_24_this_week_section');
  static String onboarding24ThisWeekDescription(List<String> intentions) {
    final count = intentions.length;
    return plural(
      'onboarding_24_this_week_description',
      count,
      namedArgs: {
        'count': '$count',
        'intentions': intentions.join(', '),
      },
    );
  }

  static String get onboarding24NextWeekSection => tr('onboarding_24_next_week_section');
  static String onboarding24NextWeekDescription(String weekday) =>
      tr('onboarding_24_next_week_description', namedArgs: {'weekday': weekday});

  // paywall
  static String paywallTitle(String trialWeeks) =>
      tr('paywall_title', namedArgs: {'trial_weeks': trialWeeks});
  static String get paywallCtaWithTrial => tr('paywall_cta_with_trial');
  static String paywallCtaWithWeeks(int trialWeeks) =>
      tr('paywall_cta_with_weeks', namedArgs: {'trial_weeks': '$trialWeeks'});

  static String get paywallTimelineStep1Label => tr('paywall_timeline_step_1_label');
  static String get paywallTimelineStep1Sublabel => tr('paywall_timeline_step_1_sublabel');
  static String get paywallTimelineStep2Label => tr('paywall_timeline_step_2_label');
  static String get paywallTimelineStep2Sublabel => tr('paywall_timeline_step_2_sublabel');
  static String paywallTimelineStep3Label(int reminderWeek) =>
      tr('paywall_timeline_step_3_label', namedArgs: {'reminder_week': '$reminderWeek'});
  static String get paywallTimelineStep3Sublabel => tr('paywall_timeline_step_3_sublabel');
  static String paywallTimelineStep4Label(String trialWeeks) =>
      tr('paywall_timeline_step_4_label', namedArgs: {'trial_weeks': trialWeeks});
  static String paywallTimelineStep4Sublabel(String endDate) =>
      tr('paywall_timeline_step_4_sublabel', namedArgs: {'end_date': endDate});

  static String get paywallBenefit1 => tr('paywall_benefit_1');
  static String get paywallBenefit2 => tr('paywall_benefit_2');
  static String get paywallBenefit3 => tr('paywall_benefit_3');
  static String get paywallBenefit4 => tr('paywall_benefit_4');

  static String get paywallReview1 => tr('paywall_review_1');
  static String get paywallReview2 => tr('paywall_review_2');
  static String get paywallReview3 => tr('paywall_review_3');

  static String paywallPriceSubtitle(int trialWeeks, String pricePerYear) => tr(
        'paywall_price_subtitle',
        namedArgs: {
          'trial_weeks': '$trialWeeks',
          'price_per_year': pricePerYear,
        },
      );
  static String paywallPricePerWeek(String pricePerWeek) =>
      tr('paywall_price_per_week', namedArgs: {'price_per_week': pricePerWeek});

  static String get paywallFooterTerms => tr('paywall_footer_terms');
  static String get paywallFooterPrivacy => tr('paywall_footer_privacy');
  static String get paywallFooterRestore => tr('paywall_footer_restore');
  static String get paywallFooterSkip => tr('paywall_footer_skip');

  // paywall errors
  static String get paywallErrorNetwork => tr('paywall_error_network');
  static String get paywallErrorNotAllowed => tr('paywall_error_not_allowed');
  static String get paywallErrorAlreadyOwned => tr('paywall_error_already_owned');
  static String get paywallErrorGeneric => tr('paywall_error_generic');
  static String get paywallErrorRestoreNotFound => tr('paywall_error_restore_not_found');
  static String get paywallErrorRestoreGeneric => tr('paywall_error_restore_generic');

  // paywall success
  static String get paywallSuccessTitle => tr('paywall_success_title');
  static String get paywallSuccessSubtitle => tr('paywall_success_subtitle');
  static String get paywallSuccessCta => tr('paywall_success_cta');

  // theme
  static String get themePickerTitle => tr('theme_picker_title');
  static String get themeSystem => tr('theme_system');
  static String get themeLight => tr('theme_light');
  static String get themeDark => tr('theme_dark');
  static String get themePetale => tr('theme_petale');
  static String get themePivoine => tr('theme_pivoine');
  static String get themeCafe => tr('theme_cafe');
  static String get themeMatcha => tr('theme_matcha');
  static String get themeLavande => tr('theme_lavande');
  static String get themeTerracotta => tr('theme_terracotta');
  static String get themeArdoise => tr('theme_ardoise');
  static String themeLockedStreakHint(int days) =>
      tr('theme_locked_streak_hint', namedArgs: {'days': '$days'});
  static String get themeSelectedLabel => tr('theme_selected_label');

  // Home page
  static String homePageTitle(String userName) =>
      tr('home_page_title', namedArgs: {'user_name': userName});

  static List<String> get homePageDayLabels => weekdayShortNames;

  // day form - discard confirmation dialog
  static String get dayFormDiscardTitle => tr('day_form_discard_title');
  static String get dayFormDiscardBody => tr('day_form_discard_body');
  static String get dayFormDiscardConfirm => tr('day_form_discard_confirm');
  static String get dayFormDiscardCancel => tr('day_form_discard_cancel');

  // day form
  static String get feelingSectionQuestion => tr('feeling_section_question');
  static String get meaningSectionQuestion => tr('meaning_section_question');
  static String get newExperienceSectionQuestion => tr('new_experience_section_question');
  static String get livingIntentionsSectionQuestion => tr('living_intentions_section_question');
  static String get livingIntentionsSectionValueNone => tr('living_intentions_section_value_none');
  static String get livingIntentionsSectionEditLabel => tr('living_intentions_section_edit_label');
  static String get leaveATraceSectionQuestion => tr('leave_a_trace_section_question');
  static String get consecutiveDay => tr('consecutive_day');
  static String get consecutiveDays => tr('consecutive_days');
  static String get congratulations => tr('congratulations');
  static String get streakGraceReminderTitle => tr('streak_grace_reminder_title');
  static String get streakGraceReminderBody => tr('streak_grace_reminder_body');
  static String get streakGraceReminderLogYesterday => tr('streak_grace_reminder_log_yesterday');
  static String get streakGraceReminderDismiss => tr('streak_grace_reminder_dismiss');

  // streaks rewards page
  static String get streaksPageTitle => tr('streaks_page_title');
  static String streaksPageSubtitle(int bestStreak) =>
      tr('streaks_page_subtitle', namedArgs: {'best_streak': '$bestStreak'});
  static String get streaksCurrentStreak => tr('streaks_current_streak');
  static String get streaksCategoryTheme => tr('streaks_category_theme');
  static String get streaksCategoryAppIcon => tr('streaks_category_app_icon');
  static String get streaksCategoryGridMotif => tr('streaks_category_grid_motif');
  static String streaksNextRewardIn(int days) => plural('streaks_next_reward_in', days);
  static String streaksRewardUnlockedTitle(int count) => plural('streaks_reward_unlocked_title', count);
  static String get streaksRewardUnlockedBody => tr('streaks_reward_unlocked_body');
  static String get streaksOpenThemePicker => tr('streaks_open_theme_picker');
  static String get streaksOpenAppIconPicker => tr('streaks_open_app_icon_picker');
  static String get streaksOpenGridMotifPicker => tr('streaks_open_grid_motif_picker');

  // weekly intent
  static String get intentBePresent => tr('intent_be_present');
  static String get intentExplore => tr('intent_explore');
  static String get intentConnect => tr('intent_connect');
  static String get intentRest => tr('intent_rest');
  static String get intentGive => tr('intent_give');
  static String get intentLearn => tr('intent_learn');
  static String get intentCreate => tr('intent_create');
  static String get intentTakeCare => tr('intent_take_care');
  static String get intentObserve => tr('intent_observe');

  static String get editWeeklyIntentsTitle => tr('edit_weekly_intents_title');
  static String get editWeeklyIntentsAddCustomLabel => tr('edit_weekly_intents_add_custom_label');
  static String get editWeeklyIntentsCustomHint => tr('edit_weekly_intents_custom_hint');
  static String get editWeeklyIntentsAdd => tr('edit_weekly_intents_add');

  // day form confirmation page
  static String get dayFormConfirmationTitle => tr('day_form_confirmation_title');
  static String get dayFormConfirmationSubtitle => tr('day_form_confirmation_subtitle');
  static String get dayFormConfirmationJournalOnlyHint => tr('day_form_confirmation_journal_only_hint');
  static String get dayFormConfirmationSave => tr('day_form_confirmation_save');
  static const int _affirmationCount = 31;
  static List<String> get dayFormConfirmationPositiveAffirmations => [
        for (var i = 0; i < _affirmationCount; i++)
          tr('day_form_confirmation_positive_affirmations.$i'),
      ];

  // day resume bottom sheet
  static String get dayResumeBottomSheetEmptySubtitle => tr('day_resume_bottom_sheet_empty_subtitle');
  static String get startTracking => tr('start_tracking');

  // profile page
  static String get profilePageTitle => tr('profile_page_title');
  static String get profilePageBorn => tr('profile_page_born');
  static String get profilePageAge => tr('profile_page_age');
  static String get profilePageLifespan => tr('profile_page_lifespan');
  static String get profilePageGender => tr('profile_page_gender');
  static String profilePageLifespanValue(int lifespan) =>
      tr('profile_page_lifespan_value', namedArgs: {'lifespan': '$lifespan'});
  static String get profilePageYearsAhead => tr('profile_page_years_ahead');
  static String get profilePagePreferences => tr('profile_page_preferences');
  static String get profilePageAppearance => tr('profile_page_appearance');
  static String get profilePageGetInTouch => tr('profile_page_get_in_touch');
  static String get profilePageWidgetsWallpaper => tr('profile_page_widgets_wallpaper');
  static String get profilePageApplication => tr('profile_page_application');
  static String get profilePageNotifications => tr('profile_page_notifications');
  static String get profilePageWeeklyIntentions => tr('profile_page_weekly_intentions');
  static String get profilePageTheme => tr('profile_page_theme');
  static String get profilePageGridMotif => tr('profile_page_grid_motif');
  static String get profilePageWallpaper => tr('profile_page_wallpaper');
  static String get profilePageWidgets => tr('profile_page_widgets');
  static String get profilePageWidgetsDescription => tr('profile_page_widgets_description');
  static String get profilePageAppIcon => tr('profile_page_app_icon');
  static String get appIconComposer => tr('app_icon_composer');
  static String get appIconLight => tr('app_icon_light');
  static String get appIconGrid => tr('app_icon_grid');
  static String get appIconSilver => tr('app_icon_silver');
  static String get appIconSisyphus => tr('app_icon_sisyphus');
  static String get appIconGold => tr('app_icon_gold');
  static String get appIconAndroidHintTitle => tr('app_icon_android_hint_title');
  static String get appIconAndroidHintMessage => tr('app_icon_android_hint_message');
  static String get appIconAndroidHintButton => tr('app_icon_android_hint_button');
  static String get gridMotifDots => tr('grid_motif_dots');
  static String get gridMotifSquares => tr('grid_motif_squares');
  static String get gridMotifFlowers => tr('grid_motif_flowers');
  static String get gridMotifDraw => tr('grid_motif_draw');
  static String get gridMotifEmoji => tr('grid_motif_emoji');
  static String get gridMotifMoons => tr('grid_motif_moons');
  static String get profilePageWallpaperConfigured => tr('profile_page_wallpaper_configured');
  static String get profilePageWallpaperNotConfigured => tr('profile_page_wallpaper_not_configured');
  static String get profilePageWallpaperSetupGuide => tr('profile_page_wallpaper_setup_guide');
  static String get profilePageWallpaperSetupGuideDescription =>
      tr('profile_page_wallpaper_setup_guide_description');
  static String get profilePageWeekBegin => tr('profile_page_week_begin');
  static String get profilePageRateTheApp => tr('profile_page_rate_the_app');
  static String get profilePageSuggestAFeature => tr('profile_page_suggest_a_feature');
  static String get profilePageReportABug => tr('profile_page_report_a_bug');

  static String get profilePageTermsOfService => tr('profile_page_terms_of_service');
  static String get profilePagePrivacyPolicy => tr('profile_page_privacy_policy');

  static String get profilePageNotificationsEnabled => tr('profile_page_notifications_enabled');
  static String get profilePageNotificationsDisabled => tr('profile_page_notifications_disabled');
  static String get profilePageRevenueCatIdCopied => tr('profile_page_revenue_cat_id_copied');

  // edit profile page
  static String get editProfilePageTitle => tr('edit_profile_page_title');
  static String get editProfilePageName => tr('edit_profile_page_name');
  static String get editProfilePageDateOfBirth => tr('edit_profile_page_date_of_birth');
  static String get editProfilePageGender => tr('edit_profile_page_gender');
  static String get editProfilePageLifespan => tr('edit_profile_page_lifespan');

  // week begin page
  static String get weekBeginPageTitle => tr('week_begin_page_title');

  // notifications settings page
  static String get notificationsSettingsPageTitle => tr('notifications_settings_page_title');
  static String get notificationsSettingsPageDailySlots => tr('notifications_settings_page_daily_slots');
  static String get notificationsSettingsPageWeeklySlot => tr('notifications_settings_page_weekly_slot');
  static String get notificationsSettingsPageDailySlot1 => tr('notifications_settings_page_daily_slot_1');
  static String get notificationsSettingsPageDailySlot2 => tr('notifications_settings_page_daily_slot_2');
  static String notificationsSettingsPageWeeklySlotDay(String weekday) =>
      tr('notifications_settings_page_weekly_slot_day', namedArgs: {'weekday': weekday});
  static String get notificationsSettingsPageDisabledMessage =>
      tr('notifications_settings_page_disabled_message');
  static String get notificationsSettingsPageOpenSettings =>
      tr('notifications_settings_page_open_settings');

  // weekly summary page
  static List<String> get monthNames => [
        tr('month_january'),
        tr('month_february'),
        tr('month_march'),
        tr('month_april'),
        tr('month_may'),
        tr('month_june'),
        tr('month_july'),
        tr('month_august'),
        tr('month_september'),
        tr('month_october'),
        tr('month_november'),
        tr('month_december'),
      ];

  static String get weeklySummaryPageTitle => tr('weekly_summary_page_title');
  static String get weeklySummaryPageSubtitle => tr('weekly_summary_page_subtitle');
  static String get weeklySummaryDetailsPageTitle => tr('weekly_summary_details_page_title');
  static String get weeklySummaryPageAverageFeeling => tr('weekly_summary_page_average_feeling');
  static String get weeklySummaryPageMeaningScore => tr('weekly_summary_page_meaning_score');
  static String get weeklySummaryPageNewExperiences => tr('weekly_summary_page_new_experiences');
  static String get weeklySummaryPageLivingIntentions => tr('weekly_summary_page_living_intentions');
  static String get weeklySummaryPageRegularity => tr('weekly_summary_page_regularity');
  static String get weeklySummaryPageSeeMore => tr('weekly_summary_page_see_more');

  static String get suggestAFeatureSubject => tr('suggest_a_feature_subject');
  static String get suggestAFeatureBody => tr('suggest_a_feature_body');

  static String get reportABugSubject => tr('report_a_bug_subject');
  static String get reportABugBody => tr('report_a_bug_body');

  // wallpaper editor
  static String get wallpaperPageTitle => tr('wallpaper_page_title');
  static String get wallpaperGridSectionTitle => tr('wallpaper_grid_section_title');
  static String get wallpaperGridLife => tr('wallpaper_grid_life');
  static String get wallpaperGridYear => tr('wallpaper_grid_year');
  static String get wallpaperAppearanceSectionTitle => tr('wallpaper_appearance_section_title');
  static String get wallpaperBrightness => tr('wallpaper_brightness');
  static String get wallpaperBrightnessLight => tr('wallpaper_brightness_light');
  static String get wallpaperBrightnessDark => tr('wallpaper_brightness_dark');
  static String get wallpaperBackgroundSectionTitle => tr('wallpaper_background_section_title');
  static String get wallpaperBackgroundSolid => tr('wallpaper_background_solid');
  static String get wallpaperBackgroundGradient => tr('wallpaper_background_gradient');
  static String get wallpaperBackgroundImage => tr('wallpaper_background_image');
  static String get wallpaperPickImage => tr('wallpaper_pick_image');
  static String get wallpaperChangeImage => tr('wallpaper_change_image');
  static String get wallpaperImageDim => tr('wallpaper_image_dim');
  static String get wallpaperImageBlur => tr('wallpaper_image_blur');
  static String get wallpaperGridOpacity => tr('wallpaper_grid_opacity');
  static String get wallpaperGridLayoutSectionTitle => tr('wallpaper_grid_layout_section_title');
  static String get wallpaperGridScale => tr('wallpaper_grid_scale');
  static String get wallpaperGridVerticalOffset => tr('wallpaper_grid_vertical_offset');
  static String wallpaperGridScaleValue(double scale) => tr(
        'wallpaper_grid_scale_value',
        namedArgs: {'percent': '${(scale * 100).round()}'},
      );
  static String wallpaperGridVerticalOffsetValue(double offset) {
    final percent = (offset * 100).round();
    if (percent == 0) return tr('wallpaper_grid_vertical_offset_center');
    return percent > 0
        ? tr('wallpaper_grid_vertical_offset_down', namedArgs: {'percent': '$percent'})
        : tr('wallpaper_grid_vertical_offset_up', namedArgs: {'percent': '${percent.abs()}'});
  }

  static String get wallpaperThemeSectionTitle => tr('wallpaper_theme_section_title');
  static String get wallpaperBackgroundImageSectionTitle => tr('wallpaper_background_image_section_title');
  static String get wallpaperAddImage => tr('wallpaper_add_image');
  static String get wallpaperInstall => tr('wallpaper_install');
  static String get wallpaperUpdate => tr('wallpaper_update');
  static String get wallpaperInstallAction => tr('wallpaper_install_action');
  static String get wallpaperUpdateAction => tr('wallpaper_update_action');
  static String get wallpaperAutomaticTitle => tr('wallpaper_automatic_title');
  static String get wallpaperAutomaticUpdatesDaily => tr('wallpaper_automatic_updates_daily');
  static String get wallpaperAutomaticUpdatesWeekly => tr('wallpaper_automatic_updates_weekly');
  static String get wallpaperAutomaticUpdatesOff => tr('wallpaper_automatic_updates_off');
  static String get wallpaperDisableTitle => tr('wallpaper_disable_title');
  static String get wallpaperDisableMessage => tr('wallpaper_disable_message');
  static String get wallpaperDisableConfirm => tr('wallpaper_disable_confirm');
  static String get wallpaperDisableCancel => tr('wallpaper_disable_cancel');
  static String get wallpaperDisabledShortcutsMessage => tr('wallpaper_disabled_shortcuts_message');

  static String get wallpaperSetupTitle => tr('wallpaper_setup_title');
  static String get wallpaperSetupSubtitle => tr('wallpaper_setup_subtitle');
  static String get wallpaperSetupShortcutTitle => tr('wallpaper_setup_shortcut_title');
  static String get wallpaperOpenShortcuts => tr('wallpaper_open_shortcuts');
  static String get wallpaperSetupShowPreview => tr('wallpaper_setup_show_preview');
  static String get wallpaperSetupExpandAll => tr('wallpaper_setup_expand_all');
  static String get wallpaperSetupCollapseAll => tr('wallpaper_setup_collapse_all');
  static String get wallpaperSetupGoToShortcutsPage => tr('wallpaper_setup_go_to_shortcuts_page');
  static String get wallpaperSetupCreateAutomation => tr('wallpaper_setup_create_automation');
  static String get wallpaperSetupSelectTimeOfDay => tr('wallpaper_setup_select_time_of_day');
  static String get wallpaperSetupSelect => tr('wallpaper_setup_select');
  static String wallpaperSetupSelectDescription(String time) =>
      tr('wallpaper_setup_select_description', namedArgs: {'time': time});
  static String get wallpaperSetupCreateNewShortcut => tr('wallpaper_setup_create_new_shortcut');
  // note: "Get Wallpaper" / "Set Wallpaper Photo" are iOS Shortcuts action names
  static String get wallpaperSetupSearchAndAddGetWallpaper =>
      tr('wallpaper_setup_search_and_add_get_wallpaper');
  static String get wallpaperSetupSearchAndAddSetWallpaperPhoto =>
      tr('wallpaper_setup_search_and_add_set_wallpaper_photo');
  static String get wallpaperSetupClickOnLockScreenAndHomeScreen =>
      tr('wallpaper_setup_click_on_lock_screen_and_home_screen');
  static String get wallpaperSetupUnselectHomeScreen => tr('wallpaper_setup_unselect_home_screen');
  static String get wallpaperSetupUnselectHomeScreenDescription =>
      tr('wallpaper_setup_unselect_home_screen_description');
  static String get wallpaperSetupClickOnExpandArrow => tr('wallpaper_setup_click_on_expand_arrow');
  static String get wallpaperSetupUnselectShowPreviewAndCropToSubject =>
      tr('wallpaper_setup_unselect_show_preview_and_crop_to_subject');
  static String get wallpaperSetupUnselectShowPreviewAndCropToSubjectDescription =>
      tr('wallpaper_setup_unselect_show_preview_and_crop_to_subject_description');
  static String get wallpaperSetupPressRunButton => tr('wallpaper_setup_press_run_button');
  static String get wallpaperSetupYouAreAllSet => tr('wallpaper_setup_you_are_all_set');

  // widgets page
  static String get profilePageWidgetsLifeGrid => tr('profile_page_widgets_life_grid');
  static String get profilePageWidgetsYearGrid => tr('profile_page_widgets_year_grid');
}
