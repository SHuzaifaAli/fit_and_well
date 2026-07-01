import '../constants/app_constants.dart';

/// Input validation utilities for forms
class Validators {
  Validators._();

  // ─── Email ────────────────────────────────────────────────────────────────
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // ─── Password ─────────────────────────────────────────────────────────────
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password is too long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != originalPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  // ─── Name ─────────────────────────────────────────────────────────────────
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < AppConstants.minNameLength) {
      return 'Name must be at least ${AppConstants.minNameLength} characters';
    }
    if (value.trim().length > AppConstants.maxNameLength) {
      return 'Name is too long';
    }
    if (!RegExp(r'^[a-zA-Z\s\-\.]+$').hasMatch(value.trim())) {
      return 'Name can only contain letters, spaces, hyphens, and periods';
    }
    return null;
  }

  // ─── Age ──────────────────────────────────────────────────────────────────
  static String? age(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }
    if (age < AppConstants.minAge) {
      return 'You must be at least ${AppConstants.minAge} years old';
    }
    if (age > AppConstants.maxAge) {
      return 'Please enter a valid age';
    }
    return null;
  }

  // ─── Weight ───────────────────────────────────────────────────────────────
  static String? weight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Weight is required';
    }
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid weight';
    }
    if (weight < AppConstants.minWeight) {
      return 'Weight must be at least ${AppConstants.minWeight} kg';
    }
    if (weight > AppConstants.maxWeight) {
      return 'Please enter a valid weight';
    }
    return null;
  }

  // ─── Height ───────────────────────────────────────────────────────────────
  static String? height(String? value) {
    if (value == null || value.isEmpty) {
      return 'Height is required';
    }
    final height = double.tryParse(value);
    if (height == null) {
      return 'Please enter a valid height';
    }
    if (height < AppConstants.minHeight) {
      return 'Height must be at least ${AppConstants.minHeight} cm';
    }
    if (height > AppConstants.maxHeight) {
      return 'Please enter a valid height';
    }
    return null;
  }

  // ─── Required ─────────────────────────────────────────────────────────────
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  // ─── Calories ─────────────────────────────────────────────────────────────
  static String? calories(String? value) {
    if (value == null || value.isEmpty) {
      return 'Calories is required';
    }
    final cal = double.tryParse(value);
    if (cal == null || cal < 0) {
      return 'Please enter valid calories';
    }
    if (cal > 10000) {
      return 'Calories value seems too high';
    }
    return null;
  }

  // ─── Protein/Carbs/Fat ────────────────────────────────────────────────────
  static String? macroGrams(String? value, String macroName) {
    if (value == null || value.isEmpty) {
      return null; // Optional
    }
    final grams = double.tryParse(value);
    if (grams == null || grams < 0) {
      return 'Please enter valid $macroName grams';
    }
    if (grams > 1000) {
      return '$macroName value seems too high';
    }
    return null;
  }
  /// Validate positive numeric input
  static String? positiveNumber(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    final num = double.tryParse(value);
    if (num == null || num <= 0) return 'Must be greater than 0';
    return null;
  }
}
