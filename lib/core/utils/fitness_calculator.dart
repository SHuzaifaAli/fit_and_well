import '../constants/app_constants.dart';

/// Fitness calculation utilities
/// Implements Harris-Benedict BMR formula and other fitness metrics
class FitnessCalculator {
  FitnessCalculator._();

  /// Calculate BMR using Harris-Benedict equation
  /// [gender]: 'male' or 'female'
  /// [weight]: in kg
  /// [height]: in cm
  /// [age]: in years
  static double calculateBMR({
    required String gender,
    required double weight,
    required double height,
    required int age,
  }) {
    if (gender == AppConstants.genderMale) {
      // Male: 88.362 + (13.397 × weight) + (4.799 × height) - (5.677 × age)
      return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      // Female: 447.593 + (9.247 × weight) + (3.098 × height) - (4.330 × age)
      return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }
  }

  /// Calculate TDEE (Total Daily Energy Expenditure)
  static double calculateTDEE({
    required String gender,
    required double weight,
    required double height,
    required int age,
    required String activityLevel,
  }) {
    final bmr = calculateBMR(
      gender: gender,
      weight: weight,
      height: height,
      age: age,
    );
    final multiplier =
        AppConstants.activityMultipliers[activityLevel] ?? 1.2;
    return bmr * multiplier;
  }

  /// Calculate daily calorie target based on goal
  static double calculateDailyCalorieTarget({
    required String gender,
    required double weight,
    required double height,
    required int age,
    required String activityLevel,
    required String goal,
  }) {
    final tdee = calculateTDEE(
      gender: gender,
      weight: weight,
      height: height,
      age: age,
      activityLevel: activityLevel,
    );

    switch (goal) {
      case AppConstants.goalWeightLoss:
        return tdee - 500; // 500 calorie deficit
      case AppConstants.goalMuscleGain:
        return tdee + 300; // 300 calorie surplus
      case AppConstants.goalMaintenance:
        return tdee;
      case AppConstants.goalGeneralFitness:
        return tdee - 200; // Slight deficit
      default:
        return tdee;
    }
  }

  /// Calculate BMI
  static double calculateBMI({
    required double weight, // kg
    required double height, // cm
  }) {
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  /// Get BMI category
  static String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal weight';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }

  /// Calculate ideal weight range (Devine formula)
  static Map<String, double> calculateIdealWeightRange({
    required String gender,
    required double height, // cm
  }) {
    final heightInInches = height / 2.54;
    final inchesOver5Feet = heightInInches - 60;

    double baseWeight;
    if (gender == AppConstants.genderMale) {
      baseWeight = 50.0 + (2.3 * inchesOver5Feet);
    } else {
      baseWeight = 45.5 + (2.3 * inchesOver5Feet);
    }

    return {
      'min': baseWeight * 0.9,
      'ideal': baseWeight,
      'max': baseWeight * 1.1,
    };
  }

  /// Calculate macro split based on goal
  static Map<String, double> calculateMacros({
    required double dailyCalories,
    required String goal,
  }) {
    double proteinPercent;
    double carbPercent;
    double fatPercent;

    switch (goal) {
      case AppConstants.goalWeightLoss:
        proteinPercent = 0.35;
        carbPercent = 0.35;
        fatPercent = 0.30;
        break;
      case AppConstants.goalMuscleGain:
        proteinPercent = 0.30;
        carbPercent = 0.45;
        fatPercent = 0.25;
        break;
      case AppConstants.goalMaintenance:
        proteinPercent = 0.25;
        carbPercent = 0.50;
        fatPercent = 0.25;
        break;
      default:
        proteinPercent = 0.25;
        carbPercent = 0.50;
        fatPercent = 0.25;
    }

    return {
      'protein': (dailyCalories * proteinPercent) / 4, // 4 cal/g
      'carbs': (dailyCalories * carbPercent) / 4, // 4 cal/g
      'fat': (dailyCalories * fatPercent) / 9, // 9 cal/g
    };
  }

  /// Calculate water intake recommendation (ml)
  static double calculateDailyWaterIntake({
    required double weight, // kg
    required String activityLevel,
  }) {
    // Base: 35ml per kg body weight
    double base = weight * 35;

    // Add extra for activity
    switch (activityLevel) {
      case AppConstants.activityModeratelyActive:
        base += 500;
        break;
      case AppConstants.activityVeryActive:
        base += 1000;
        break;
      case AppConstants.activityExtraActive:
        base += 1500;
        break;
      default:
        break;
    }

    return base;
  }

  /// Calculate body fat percentage (US Navy formula)
  static double calculateBodyFat({
    required String gender,
    required double height, // cm
    required double waist, // cm
    required double neck, // cm
    double? hip, // cm (required for female)
  }) {
    if (gender == AppConstants.genderMale) {
      return 495 /
              (1.0324 -
                  0.19077 * (log10(waist - neck)) +
                  0.15456 * log10(height)) -
          450;
    } else {
      final hipValue = hip ?? waist;
      return 495 /
              (1.29579 -
                  0.35004 * log10(waist + hipValue - neck) +
                  0.22100 * log10(height)) -
          450;
    }
  }

  static double log10(double x) => x <= 0 ? 0 : (x == 1 ? 0 : _log(x) / _log(10));
  static double _log(double x) {
    // Simple natural log approximation
    if (x <= 0) return double.negativeInfinity;
    double result = 0;
    double term = (x - 1) / (x + 1);
    double termSquared = term * term;
    double currentTerm = term;
    for (int i = 0; i < 100; i++) {
      result += currentTerm / (2 * i + 1);
      currentTerm *= termSquared;
    }
    return 2 * result;
  }
}
