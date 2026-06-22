/// Nutrition log entry model
class NutritionLogModel {
  final String id;
  final String userId;
  final String mealType; // breakfast, lunch, dinner, snack
  final String foodName;
  final double calories;
  final double? protein; // grams
  final double? carbs; // grams
  final double? fat; // grams
  final double? fiber; // grams
  final double servingSize;
  final String servingUnit;
  final DateTime date;
  final DateTime createdAt;

  const NutritionLogModel({
    required this.id,
    required this.userId,
    required this.mealType,
    required this.foodName,
    required this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.fiber,
    this.servingSize = 1,
    this.servingUnit = 'serving',
    required this.date,
    required this.createdAt,
  });

  factory NutritionLogModel.fromJson(Map<String, dynamic> json) {
    return NutritionLogModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      mealType: json['meal_type'] as String,
      foodName: json['food_name'] as String,
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num?)?.toDouble(),
      carbs: (json['carbs'] as num?)?.toDouble(),
      fat: (json['fat'] as num?)?.toDouble(),
      fiber: (json['fiber'] as num?)?.toDouble(),
      servingSize: (json['serving_size'] as num?)?.toDouble() ?? 1,
      servingUnit: json['serving_unit'] as String? ?? 'serving',
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
      'meal_type': mealType,
      'food_name': foodName,
      'calories': calories,
      if (protein != null) 'protein': protein,
      if (carbs != null) 'carbs': carbs,
      if (fat != null) 'fat': fat,
      if (fiber != null) 'fiber': fiber,
      'serving_size': servingSize,
      'serving_unit': servingUnit,
      'date': date.toIso8601String().split('T').first,
      'created_at': createdAt.toIso8601String(),
    };
  }

  NutritionLogModel copyWith({
    String? id,
    String? userId,
    String? mealType,
    String? foodName,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? fiber,
    double? servingSize,
    String? servingUnit,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return NutritionLogModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mealType: mealType ?? this.mealType,
      foodName: foodName ?? this.foodName,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      fiber: fiber ?? this.fiber,
      servingSize: servingSize ?? this.servingSize,
      servingUnit: servingUnit ?? this.servingUnit,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NutritionLogModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Daily nutrition summary
class DailyNutritionSummary {
  final DateTime date;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final double waterIntakeMl;
  final List<NutritionLogModel> meals;

  const DailyNutritionSummary({
    required this.date,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.waterIntakeMl,
    required this.meals,
  });

  Map<String, List<NutritionLogModel>> get mealsByType {
    final Map<String, List<NutritionLogModel>> grouped = {};
    for (final meal in meals) {
      grouped.putIfAbsent(meal.mealType, () => []).add(meal);
    }
    return grouped;
  }
}

/// Water intake log model
class WaterIntakeModel {
  final String id;
  final String userId;
  final double amountMl;
  final DateTime loggedAt;

  const WaterIntakeModel({
    required this.id,
    required this.userId,
    required this.amountMl,
    required this.loggedAt,
  });

  factory WaterIntakeModel.fromJson(Map<String, dynamic> json) {
    return WaterIntakeModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amountMl: (json['amount_ml'] as num).toDouble(),
      loggedAt: DateTime.parse(json['logged_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount_ml': amountMl,
      'logged_at': loggedAt.toIso8601String(),
    };
  }
}
