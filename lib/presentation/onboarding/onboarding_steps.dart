import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_01_welcome.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_02_life_feels_long.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_03_life_in_weeks.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_04_make_it_count.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_05_build_your_grid.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_06_name.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_07_date_of_birth.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_08_week_begin.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_09_gender.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_10_lifespan.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_11_grid_reveal.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_12_birthdays.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_13_winters.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_14_olympics.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_15_loved_one.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_16_visits_visualization.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_17_but_add_life.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_18_this_year.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_19_one_year_but.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_20_weeks_that_stay.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_21_weeks_disappear.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_22_daily_habit.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_23_one_minute.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_24_notification_time.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_25_weekly_intent.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_26_grid_alive.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_27_widget.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_28_rating.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_29_attribution.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_30_next_steps.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_31_final.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_32_paywall.dart';

const List<OnboardingStep> kOnboardingSteps = <OnboardingStep>[
  Step01Welcome(),
  Step02LifeFeelsLong(),
  Step03LifeInWeeks(),
  Step04MakeItCount(),
  Step05BuildYourGrid(),
  Step06Name(),
  Step07DateOfBirth(),
  Step08WeekBegin(),
  Step09Gender(),
  Step10Lifespan(),
  Step11GridReveal(),
  Step12Birthdays(),
  Step13Winters(),
  Step14Olympics(),
  Step15LovedOne(),
  Step16VisitsVisualization(),
  Step17ButAddLife(),
  Step18ThisYear(),
  Step19OneYearBut(),
  Step20WeeksThatStay(),
  Step21WeeksDisappear(),
  Step22DailyHabit(),
  Step23OneMinute(),
  Step24NotificationTime(),
  Step25WeeklyIntent(),
  Step26GridAlive(),
  Step27Widget(),
  Step28Rating(),
  Step29Attribution(),
  Step30NextSteps(),
  Step31Final(),
  Step32Paywall(),
];
