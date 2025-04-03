import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required UserPremiumPlan? premiumPlan,
    required DateTime createdAt,
  }) = _User;

  static User fromDocument(Map<String, dynamic> doc) {
    return User(
      id: doc['id'] as String,
      premiumPlan: UserPremiumPlan.fromDocument(doc['entitlements'] as Map<String, dynamic>?),
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
    );
  }
}

enum UserPremiumPlan {
  monthly,
  yearly,
  lifetime;

  static UserPremiumPlan? fromString(String value) {
    return switch (value) {
      'central_save_monthly' => UserPremiumPlan.monthly,
      'central_save_annual' => UserPremiumPlan.yearly,
      'lifetime_pro_upgrade' => UserPremiumPlan.lifetime,
      _ => null,
    };
  }

  static UserPremiumPlan? fromDocument(Map<String, dynamic>? doc) {
    if (doc == null) {
      return null;
    }

    final proEntitlement = doc['Pro'] as Map<String, dynamic>?;
    if (proEntitlement == null) {
      return null;
    }

    final plan = fromString(proEntitlement['product_identifier']);

    final isActive = switch (plan) {
      UserPremiumPlan.monthly => isSubscriptionActive(proEntitlement['expires_date']),
      UserPremiumPlan.yearly => isSubscriptionActive(proEntitlement['expires_date']),
      UserPremiumPlan.lifetime => true,
      _ => false,
    };

    return isActive ? plan : null;
  }

  static bool isSubscriptionActive(String? dateStr) {
    if (dateStr == null) {
      return false;
    }
    final date = DateTime.parse(dateStr);
    return date.isAfter(DateTime.now());
  }
}
