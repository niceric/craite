class UserProfile {
  final String username;
  final String email;
  final int credits;
  final SubscriptionType subscriptionType;

  UserProfile({
    required this.username,
    required this.email,
    required this.credits,
    required this.subscriptionType,
  });

  UserProfile copyWith({
    String? username,
    String? email,
    int? credits,
    SubscriptionType? subscriptionType,
  }) {
    return UserProfile(
      username: username ?? this.username,
      email: email ?? this.email,
      credits: credits ?? this.credits,
      subscriptionType: subscriptionType ?? this.subscriptionType,
    );
  }
}

enum SubscriptionType {
  free,
  basic,
  premium,
}

extension SubscriptionTypeExtension on SubscriptionType {
  String get displayName {
    switch (this) {
      case SubscriptionType.free:
        return 'Free';
      case SubscriptionType.basic:
        return 'Basic';
      case SubscriptionType.premium:
        return 'Premium';
    }
  }
}
