// ============================================================
// PHASE 1 — UNIT TESTS
// Run: flutter test
// ============================================================

// ── test/core/utils/validators_test.dart ─────────────────────

import 'package:flutter_test/flutter_test.dart';
import 'package:fit_and_well/core/utils/validators.dart';
import 'package:fit_and_well/core/utils/fitness_calculator.dart';
import 'package:fit_and_well/core/errors/app_exceptions.dart';
import 'package:fit_and_well/core/errors/failures.dart';
import 'package:fit_and_well/data/models/user_model.dart';
import 'package:fit_and_well/core/constants/app_constants.dart';

// ─────────────────────────────────────────────────────────────
// Validators
// ─────────────────────────────────────────────────────────────

void main() {
  group('Validators.email', () {
    test('returns null for valid email', () {
      expect(Validators.email('user@example.com'), isNull);
      expect(Validators.email('first.last+tag@sub.domain.io'), isNull);
    });

    test('returns error for empty input', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email(null), isNotNull);
    });

    test('returns error for malformed email', () {
      expect(Validators.email('notanemail'), isNotNull);
      expect(Validators.email('@nodomain.com'), isNotNull);
      expect(Validators.email('missing@'), isNotNull);
      expect(Validators.email('spaces in@email.com'), isNotNull);
    });
  });

  group('Validators.password', () {
    test('returns null for strong password', () {
      expect(Validators.password('Password1'), isNull);
      expect(Validators.password('Str0ngP@ss!'), isNull);
    });

    test('returns error for empty or null', () {
      expect(Validators.password(''), isNotNull);
      expect(Validators.password(null), isNotNull);
    });

    test('returns error for too short', () {
      expect(Validators.password('Ab1'), isNotNull);
    });

    test('returns error when missing uppercase', () {
      expect(Validators.password('password1'), isNotNull);
    });

    test('returns error when missing number', () {
      expect(Validators.password('Password'), isNotNull);
    });

    test('returns error for excessively long password', () {
      expect(Validators.password('A1' * 65), isNotNull); // 130 chars
    });
  });

  group('Validators.confirmPassword', () {
    test('returns null when passwords match', () {
      expect(Validators.confirmPassword('Password1', 'Password1'), isNull);
    });

    test('returns error when passwords differ', () {
      expect(Validators.confirmPassword('Password1', 'Password2'), isNotNull);
    });

    test('returns error when confirm is empty', () {
      expect(Validators.confirmPassword('', 'Password1'), isNotNull);
      expect(Validators.confirmPassword(null, 'Password1'), isNotNull);
    });
  });

  group('Validators.name', () {
    test('accepts valid names', () {
      expect(Validators.name('John'), isNull);
      expect(Validators.name('Mary-Jane'), isNull);
      expect(Validators.name('Dr. Smith'), isNull);
    });

    test('rejects too short', () {
      expect(Validators.name('A'), isNotNull);
    });

    test('rejects special characters', () {
      expect(Validators.name('John123'), isNotNull);
      expect(Validators.name('John@Doe'), isNotNull);
    });

    test('rejects null/empty', () {
      expect(Validators.name(null), isNotNull);
      expect(Validators.name(''), isNotNull);
    });
  });

  group('Validators.age', () {
    test('accepts valid ages', () {
      expect(Validators.age('18'), isNull);
      expect(Validators.age('65'), isNull);
      expect(Validators.age('13'), isNull);
    });

    test('rejects below minimum', () {
      expect(Validators.age('12'), isNotNull);
    });

    test('rejects above maximum', () {
      expect(Validators.age('121'), isNotNull);
    });

    test('rejects non-numeric', () {
      expect(Validators.age('abc'), isNotNull);
    });

    test('rejects empty', () {
      expect(Validators.age(''), isNotNull);
      expect(Validators.age(null), isNotNull);
    });
  });

  group('Validators.weight', () {
    test('accepts valid weights', () {
      expect(Validators.weight('70'), isNull);
      expect(Validators.weight('70.5'), isNull);
    });

    test('rejects out of range', () {
      expect(Validators.weight('10'), isNotNull);
      expect(Validators.weight('600'), isNotNull);
    });

    test('rejects non-numeric', () {
      expect(Validators.weight('abc'), isNotNull);
    });
  });

  group('Validators.height', () {
    test('accepts valid heights', () {
      expect(Validators.height('175'), isNull);
      expect(Validators.height('50'), isNull);
    });

    test('rejects out of range', () {
      expect(Validators.height('30'), isNotNull);
      expect(Validators.height('400'), isNotNull);
    });
  });

  group('Validators.calories', () {
    test('accepts valid calorie values', () {
      expect(Validators.calories('500'), isNull);
      expect(Validators.calories('0'), isNull);
      expect(Validators.calories('2000'), isNull);
    });

    test('rejects negative or over-limit', () {
      expect(Validators.calories('-100'), isNotNull);
      expect(Validators.calories('20000'), isNotNull);
    });
  });

  // ─────────────────────────────────────────────────────────
  // FitnessCalculator
  // ─────────────────────────────────────────────────────────

  group('FitnessCalculator.calculateBMR', () {
    test('calculates male BMR correctly', () {
      final bmr = FitnessCalculator.calculateBMR(
        gender: 'male',
        weight: 80.0,
        height: 180.0,
        age: 30,
      );
      // Expected ≈ 1901: 88.362 + (13.397*80) + (4.799*180) - (5.677*30)
      expect(bmr, closeTo(1901, 5));
    });

    test('calculates female BMR correctly', () {
      final bmr = FitnessCalculator.calculateBMR(
        gender: 'female',
        weight: 60.0,
        height: 165.0,
        age: 28,
      );
      // Expected ≈ 1428
      expect(bmr, closeTo(1428, 5));
    });

    test('female BMR is lower than male BMR for same stats', () {
      final male = FitnessCalculator.calculateBMR(
          gender: 'male', weight: 70, height: 170, age: 30);
      final female = FitnessCalculator.calculateBMR(
          gender: 'female', weight: 70, height: 170, age: 30);
      expect(male, greaterThan(female));
    });
  });

  group('FitnessCalculator.calculateTDEE', () {
    test('TDEE is always greater than BMR', () {
      final bmr = FitnessCalculator.calculateBMR(
          gender: 'male', weight: 75, height: 175, age: 25);
      final tdee = FitnessCalculator.calculateTDEE(
          gender: 'male',
          weight: 75,
          height: 175,
          age: 25,
          activityLevel: AppConstants.activitySedentary);
      expect(tdee, greaterThan(bmr));
    });

    test('higher activity gives higher TDEE', () {
      final sedentary = FitnessCalculator.calculateTDEE(
          gender: 'male',
          weight: 75,
          height: 175,
          age: 25,
          activityLevel: AppConstants.activitySedentary);
      final veryActive = FitnessCalculator.calculateTDEE(
          gender: 'male',
          weight: 75,
          height: 175,
          age: 25,
          activityLevel: AppConstants.activityVeryActive);
      expect(veryActive, greaterThan(sedentary));
    });
  });

  group('FitnessCalculator.calculateBMI', () {
    test('normal weight BMI is in 18.5–24.9 range', () {
      final bmi = FitnessCalculator.calculateBMI(weight: 70, height: 175);
      expect(bmi, greaterThanOrEqualTo(18.5));
      expect(bmi, lessThanOrEqualTo(24.9));
    });

    test('calculates BMI for known values', () {
      // 90kg / (1.80m)² ≈ 27.8
      final bmi = FitnessCalculator.calculateBMI(weight: 90, height: 180);
      expect(bmi, closeTo(27.8, 0.1));
    });
  });

  group('FitnessCalculator.getBMICategory', () {
    test('classifies underweight', () {
      expect(FitnessCalculator.getBMICategory(17.5), 'Underweight');
    });
    test('classifies normal', () {
      expect(FitnessCalculator.getBMICategory(22.0), 'Normal weight');
    });
    test('classifies overweight', () {
      expect(FitnessCalculator.getBMICategory(27.0), 'Overweight');
    });
    test('classifies obese', () {
      expect(FitnessCalculator.getBMICategory(32.0), 'Obese');
    });
  });

  group('FitnessCalculator.calculateDailyCalorieTarget', () {
    test('weight loss target is less than maintenance', () {
      final maintenance = FitnessCalculator.calculateDailyCalorieTarget(
          gender: 'male',
          weight: 80,
          height: 175,
          age: 30,
          activityLevel: AppConstants.activityModeratelyActive,
          goal: AppConstants.goalMaintenance);
      final loss = FitnessCalculator.calculateDailyCalorieTarget(
          gender: 'male',
          weight: 80,
          height: 175,
          age: 30,
          activityLevel: AppConstants.activityModeratelyActive,
          goal: AppConstants.goalWeightLoss);
      expect(loss, lessThan(maintenance));
    });

    test('muscle gain target is greater than maintenance', () {
      final maintenance = FitnessCalculator.calculateDailyCalorieTarget(
          gender: 'male',
          weight: 80,
          height: 175,
          age: 30,
          activityLevel: AppConstants.activityModeratelyActive,
          goal: AppConstants.goalMaintenance);
      final gain = FitnessCalculator.calculateDailyCalorieTarget(
          gender: 'male',
          weight: 80,
          height: 175,
          age: 30,
          activityLevel: AppConstants.activityModeratelyActive,
          goal: AppConstants.goalMuscleGain);
      expect(gain, greaterThan(maintenance));
    });
  });

  group('FitnessCalculator.calculateMacros', () {
    test('macro grams sum reasonably to total calories', () {
      const dailyCal = 2000.0;
      final macros = FitnessCalculator.calculateMacros(
          dailyCalories: dailyCal,
          goal: AppConstants.goalMaintenance);

      final reconstituted =
          (macros['protein']! * 4) + (macros['carbs']! * 4) + (macros['fat']! * 9);
      expect(reconstituted, closeTo(dailyCal, 1));
    });
  });

  // ─────────────────────────────────────────────────────────
  // AppExceptions
  // ─────────────────────────────────────────────────────────

  group('NetworkException factories', () {
    test('noInternet has correct code', () {
      final e = NetworkException.noInternet();
      expect(e.code, 'NO_INTERNET');
      expect(e.message, isNotEmpty);
    });

    test('timeout has correct code', () {
      final e = NetworkException.timeout();
      expect(e.code, 'TIMEOUT');
    });

    test('unauthorized has correct code', () {
      final e = NetworkException.unauthorized();
      expect(e.code, 'UNAUTHORIZED');
    });

    test('rateLimited has correct code', () {
      final e = NetworkException.rateLimited();
      expect(e.code, 'RATE_LIMITED');
    });
  });

  group('AuthException factories', () {
    test('invalidCredentials has correct code', () {
      final e = AuthException.invalidCredentials();
      expect(e.code, 'INVALID_CREDENTIALS');
    });

    test('emailAlreadyInUse has correct code', () {
      final e = AuthException.emailAlreadyInUse();
      expect(e.code, 'EMAIL_IN_USE');
    });

    test('sessionExpired has correct code', () {
      final e = AuthException.sessionExpired();
      expect(e.code, 'SESSION_EXPIRED');
    });
  });

  group('AIException factories', () {
    test('quotaExceeded has correct code', () {
      final e = AIException.quotaExceeded();
      expect(e.code, 'AI_QUOTA_EXCEEDED');
      expect(e.message, contains('limit'));
    });
  });

  group('PaymentException factories', () {
    test('paymentFailed has correct code', () {
      final e = PaymentException.paymentFailed();
      expect(e.code, 'PAYMENT_FAILED');
    });

    test('subscriptionExpired has correct code', () {
      final e = PaymentException.subscriptionExpired();
      expect(e.code, 'SUBSCRIPTION_EXPIRED');
    });
  });

  // ─────────────────────────────────────────────────────────
  // Failure <-> Exception mapping
  // ─────────────────────────────────────────────────────────

  group('Failure.fromException', () {
    test('NetworkFailure carries message from NetworkException', () {
      final ex = NetworkException.noInternet();
      final failure = NetworkFailure.fromException(ex);
      expect(failure.message, ex.message);
      expect(failure.code, ex.code);
    });

    test('AuthFailure carries message from AuthException', () {
      final ex = AuthException.invalidCredentials();
      final failure = AuthFailure.fromException(ex);
      expect(failure.message, ex.message);
    });

    test('ValidationFailure preserves fieldErrors', () {
      final ex = ValidationException.multipleErrors({
        'email': 'Invalid',
        'password': 'Too weak',
      });
      final failure = ValidationFailure.fromException(ex);
      expect(failure.fieldErrors, containsPair('email', 'Invalid'));
      expect(failure.fieldErrors, containsPair('password', 'Too weak'));
    });
  });

  // ─────────────────────────────────────────────────────────
  // UserModel
  // ─────────────────────────────────────────────────────────

  group('UserModel', () {
    final baseUser = UserModel(
      id: 'user-123',
      email: 'test@example.com',
      name: 'Test User',
      age: 28,
      gender: 'male',
      height: 175.0,
      weight: 75.0,
      goal: AppConstants.goalWeightLoss,
      activityLevel: AppConstants.activityModeratelyActive,
      subscriptionPlan: AppConstants.planFree,
      createdAt: DateTime(2024, 1, 1),
    );

    test('isProfileComplete returns true when all fields set', () {
      expect(baseUser.isProfileComplete, isTrue);
    });

    test('isProfileComplete returns false when fields missing', () {
      final incomplete = baseUser.copyWith(age: null);
      expect(incomplete.isProfileComplete, isFalse);
    });

    test('isPremium is false for free plan', () {
      expect(baseUser.isPremium, isFalse);
    });

    test('isPremium is true for monthly plan', () {
      final premiumUser =
          baseUser.copyWith(subscriptionPlan: AppConstants.planPremiumMonthly);
      expect(premiumUser.isPremium, isTrue);
    });

    test('fromJson / toJson round-trip', () {
      final json = baseUser.toJson();
      final fromJson = UserModel.fromJson(json);
      expect(fromJson.id, baseUser.id);
      expect(fromJson.email, baseUser.email);
      expect(fromJson.name, baseUser.name);
      expect(fromJson.age, baseUser.age);
      expect(fromJson.weight, baseUser.weight);
      expect(fromJson.height, baseUser.height);
    });

    test('copyWith produces updated model', () {
      final updated = baseUser.copyWith(name: 'Updated Name', age: 30);
      expect(updated.name, 'Updated Name');
      expect(updated.age, 30);
      expect(updated.email, baseUser.email); // unchanged
    });

    test('equality is based on id', () {
      final copy = baseUser.copyWith(name: 'Different Name');
      expect(baseUser, equals(copy));
    });
  });

  // ─────────────────────────────────────────────────────────
  // AppConstants — smoke tests
  // ─────────────────────────────────────────────────────────

  group('AppConstants', () {
    test('activity multipliers cover all levels', () {
      for (final level in [
        AppConstants.activitySedentary,
        AppConstants.activityLightlyActive,
        AppConstants.activityModeratelyActive,
        AppConstants.activityVeryActive,
        AppConstants.activityExtraActive,
      ]) {
        expect(AppConstants.activityMultipliers.containsKey(level), isTrue);
      }
    });

    test('premium price is positive', () {
      expect(AppConstants.premiumMonthlyPrice, greaterThan(0));
      expect(AppConstants.premiumYearlyPrice, greaterThan(0));
    });

    test('yearly price gives a saving over 12 × monthly', () {
      expect(
        AppConstants.premiumYearlyPrice,
        lessThan(AppConstants.premiumMonthlyPrice * 12),
      );
    });

    test('spacing constants are positive and ordered', () {
      expect(AppConstants.spacingXs, lessThan(AppConstants.spacingSm));
      expect(AppConstants.spacingSm, lessThan(AppConstants.spacingMd));
      expect(AppConstants.spacingMd, lessThan(AppConstants.spacingLg));
    });
  });
}
