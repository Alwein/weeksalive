import 'package:weeksalive/presentation/onboarding/model/onboarding_step.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_01_welcome.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_02_life_feels_long.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_03_life_in_weeks.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_04_build_your_grid.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_05_name.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_06_date_of_birth.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_07_gender.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_08_lifespan.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_09_grid_reveal.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_10_make_it_count.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_11_loved_one.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_12_visits_visualization.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_13_weeks_disappear.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_14_best_memories.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_15_weeks_that_stay.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_16_awareness_fades.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_17_daily_habit.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_18_one_minute.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_19_grid_alive.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_20_notification_time.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_21_widget.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_22_privacy.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_23_attribution.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_24_rating.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_25_final.dart';
import 'package:weeksalive/presentation/onboarding/steps/step_26_paywall.dart';

const List<OnboardingStep> kOnboardingSteps = <OnboardingStep>[
  Step01Welcome(),
  Step02LifeFeelsLong(),
  Step03LifeInWeeks(),
  Step04BuildYourGrid(),
  Step05Name(),
  Step06DateOfBirth(),
  Step07Gender(),
  Step08Lifespan(),
  Step09GridReveal(),
  Step10MakeItCount(),
  Step11LovedOne(),
  Step12VisitsVisualization(),
  Step13WeeksDisappear(),
  Step14BestMemories(),
  Step15WeeksThatStay(),
  Step16AwarenessFades(),
  Step17DailyHabit(),
  Step18OneMinute(),
  Step19GridAlive(),
  Step20NotificationTime(),
  Step21Widget(),
  Step22Privacy(),
  Step23Attribution(),
  Step24Rating(),
  Step25Final(),
  Step26Paywall(),
  // Step27OnboardingDone(),
];
