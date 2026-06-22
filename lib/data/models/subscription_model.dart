import '../../core/constants/app_constants.dart';

/// Subscription data model
class SubscriptionModel {
  final String id;
  final String userId;
  final String plan;
  final String status; // active, cancelled, expired, trial
  final DateTime? expiryDate;
  final DateTime? startDate;
  final String? transactionId;
  final String? platform; // android, ios, web
  final DateTime createdAt;

  const SubscriptionModel({
    required this.id,
    required this.userId,
    required this.plan,
    required this.status,
    this.expiryDate,
    this.startDate,
    this.transactionId,
    this.platform,
    required this.createdAt,
  });

  bool get isActive => status == 'active' || status == 'trial';

  bool get isExpired =>
      status == 'expired' ||
      (expiryDate != null && expiryDate!.isBefore(DateTime.now()));

  bool get isPremium =>
      isActive &&
      (plan == AppConstants.planPremiumMonthly ||
          plan == AppConstants.planPremiumYearly ||
          plan == AppConstants.planLifetime);

  int? get daysRemaining {
    if (expiryDate == null) return null;
    final diff = expiryDate!.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      plan: json['plan'] as String,
      status: json['status'] as String,
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'] as String)
          : null,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      transactionId: json['transaction_id'] as String?,
      platform: json['platform'] as String?,
      createdAt: DateTime.parse(
          json['created_at'] as String? ??
              DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'plan': plan,
      'status': status,
      if (expiryDate != null) 'expiry_date': expiryDate!.toIso8601String(),
      if (startDate != null) 'start_date': startDate!.toIso8601String(),
      if (transactionId != null) 'transaction_id': transactionId,
      if (platform != null) 'platform': platform,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Subscription plan details
class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final double price;
  final String period; // monthly, yearly, lifetime
  final List<String> features;
  final bool isPopular;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.period,
    required this.features,
    this.isPopular = false,
  });

  static const List<SubscriptionPlan> plans = [
    SubscriptionPlan(
      id: AppConstants.planFree,
      name: 'Free',
      description: 'Get started with basic features',
      price: 0,
      period: 'forever',
      features: [
        'Basic workout library',
        'Weight tracking',
        'Water tracking',
        '3 AI requests/day',
        'Basic progress charts',
      ],
    ),
    SubscriptionPlan(
      id: AppConstants.planPremiumMonthly,
      name: 'Premium',
      description: 'Unlock your full potential',
      price: AppConstants.premiumMonthlyPrice,
      period: 'month',
      isPopular: true,
      features: [
        'Unlimited AI Coach',
        'Personalized meal plans',
        'Advanced analytics',
        'Progress predictions',
        'Priority support',
        'All workout programs',
        'Custom workout builder',
      ],
    ),
    SubscriptionPlan(
      id: AppConstants.planPremiumYearly,
      name: 'Premium Yearly',
      description: 'Save 33% with annual billing',
      price: AppConstants.premiumYearlyPrice,
      period: 'year',
      features: [
        'Everything in Premium',
        'Save 33% vs monthly',
        'Early access to features',
      ],
    ),
    SubscriptionPlan(
      id: AppConstants.planLifetime,
      name: 'Lifetime',
      description: 'One-time purchase, forever access',
      price: AppConstants.lifetimePrice,
      period: 'lifetime',
      features: [
        'Everything in Premium',
        'Lifetime access',
        'All future features',
        'VIP support',
      ],
    ),
  ];
}
