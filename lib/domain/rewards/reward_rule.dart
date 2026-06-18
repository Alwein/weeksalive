import 'package:weeksalive/domain/rewards/reward_condition.dart';
import 'package:weeksalive/domain/rewards/reward_id.dart';

class RewardRule {
  const RewardRule({
    required this.id,
    required this.condition,
  });

  final RewardId id;
  final RewardCondition condition;
}
