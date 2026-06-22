/// Weight log entry model
class WeightLogModel {
  final String id;
  final String userId;
  final double weight; // kg
  final double? bodyFatPercentage;
  final double? bmi;
  final String? notes;
  final DateTime date;
  final DateTime createdAt;

  const WeightLogModel({
    required this.id,
    required this.userId,
    required this.weight,
    this.bodyFatPercentage,
    this.bmi,
    this.notes,
    required this.date,
    required this.createdAt,
  });

  factory WeightLogModel.fromJson(Map<String, dynamic> json) {
    return WeightLogModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      weight: (json['weight'] as num).toDouble(),
      bodyFatPercentage:
          (json['body_fat_percentage'] as num?)?.toDouble(),
      bmi: (json['bmi'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(
          json['created_at'] as String? ??
              DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'weight': weight,
      if (bodyFatPercentage != null)
        'body_fat_percentage': bodyFatPercentage,
      if (bmi != null) 'bmi': bmi,
      if (notes != null) 'notes': notes,
      'date': date.toIso8601String().split('T').first,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeightLogModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Progress statistics model
class ProgressStats {
  final double currentWeight;
  final double? startingWeight;
  final double? targetWeight;
  final double? weightChange;
  final double currentBMI;
  final int workoutStreak;
  final int totalWorkoutsCompleted;
  final double averageCaloriesConsumed;
  final double averageCaloriesBurned;

  const ProgressStats({
    required this.currentWeight,
    this.startingWeight,
    this.targetWeight,
    this.weightChange,
    required this.currentBMI,
    required this.workoutStreak,
    required this.totalWorkoutsCompleted,
    required this.averageCaloriesConsumed,
    required this.averageCaloriesBurned,
  });

  double? get weightChangePercent {
    if (startingWeight == null || startingWeight == 0) return null;
    return ((currentWeight - startingWeight!) / startingWeight!) * 100;
  }

  double? get progressToGoal {
    if (startingWeight == null || targetWeight == null) return null;
    if (startingWeight == targetWeight) return 1.0;
    final totalChange = (targetWeight! - startingWeight!).abs();
    final currentChange = (currentWeight - startingWeight!).abs();
    return (currentChange / totalChange).clamp(0.0, 1.0);
  }
}
