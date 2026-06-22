import '../../core/constants/app_constants.dart';

/// User profile data model
class UserModel {
  final String id;
  final String email;
  final String name;
  final int? age;
  final String? gender;
  final double? height; // cm
  final double? weight; // kg
  final String? goal;
  final String? activityLevel;
  final String? dietPreference;
  final String? avatarUrl;
  final String subscriptionPlan;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.age,
    this.gender,
    this.height,
    this.weight,
    this.goal,
    this.activityLevel,
    this.dietPreference,
    this.avatarUrl,
    this.subscriptionPlan = AppConstants.planFree,
    required this.createdAt,
    this.updatedAt,
  });

  /// Check if profile is complete
  bool get isProfileComplete =>
      age != null &&
      gender != null &&
      height != null &&
      weight != null &&
      goal != null &&
      activityLevel != null;

  /// Check if user is premium
  bool get isPremium =>
      subscriptionPlan == AppConstants.planPremiumMonthly ||
      subscriptionPlan == AppConstants.planPremiumYearly ||
      subscriptionPlan == AppConstants.planLifetime;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String? ?? '',
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      goal: json['goal'] as String?,
      activityLevel: json['activity_level'] as String?,
      dietPreference: json['diet_preference'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      subscriptionPlan:
          json['subscription_plan'] as String? ?? AppConstants.planFree,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (goal != null) 'goal': goal,
      if (activityLevel != null) 'activity_level': activityLevel,
      if (dietPreference != null) 'diet_preference': dietPreference,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      'subscription_plan': subscriptionPlan,
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    int? age,
    String? gender,
    double? height,
    double? weight,
    String? goal,
    String? activityLevel,
    String? dietPreference,
    String? avatarUrl,
    String? subscriptionPlan,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
      dietPreference: dietPreference ?? this.dietPreference,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'UserModel(id: $id, email: $email, name: $name)';
}
