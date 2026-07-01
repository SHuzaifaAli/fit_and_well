import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/fitness_calculator.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../modules/auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final UserRepository _repository;
  AuthController get _auth => Get.find<AuthController>();

  ProfileController({UserRepository? repository})
      : _repository = repository ?? UserRepository();

  // ─── State ────────────────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isUploadingAvatar = false.obs;

  // ─── Edit Profile Form ────────────────────────────────────────────────────
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final selectedGender = 'male'.obs;
  final selectedGoal = 'general_fitness'.obs;
  final selectedActivityLevel = 'moderately_active'.obs;
  final selectedDietPreference = 'none'.obs;
  final editFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.onClose();
  }

  // ─── Load Profile ─────────────────────────────────────────────────────────
  Future<void> loadProfile() async {
    final user = _auth.currentUser.value;
    if (user == null) return;

    nameController.text = user.name;
    if (user.age != null) ageController.text = user.age.toString();
    if (user.weight != null) weightController.text = user.weight.toString();
    if (user.height != null) heightController.text = user.height.toString();
    if (user.gender != null) selectedGender.value = user.gender!;
    if (user.goal != null) selectedGoal.value = user.goal!;
    if (user.activityLevel != null) selectedActivityLevel.value = user.activityLevel!;
    if (user.dietPreference != null) selectedDietPreference.value = user.dietPreference!;
  }

  // ─── Save Profile ─────────────────────────────────────────────────────────
  Future<void> saveProfile() async {
    if (!editFormKey.currentState!.validate()) return;

    isSaving.value = true;

    try {
      final user = _auth.currentUser.value;
      if (user == null) return;

      final updatedUser = user.copyWith(
        name: nameController.text.trim(),
        age: int.tryParse(ageController.text),
        weight: double.tryParse(weightController.text),
        height: double.tryParse(heightController.text),
        gender: selectedGender.value,
        goal: selectedGoal.value,
        activityLevel: selectedActivityLevel.value,
        dietPreference: selectedDietPreference.value,
      );

      final result = await _repository.updateUserProfile(updatedUser);
      
      result.fold(
        (failure) => Get.snackbar('Error', failure.message,
            snackPosition: SnackPosition.BOTTOM),
        (_) {
          _auth.currentUser.value = updatedUser;
          Get.snackbar('Success', 'Profile updated',
              snackPosition: SnackPosition.BOTTOM);
          Get.back();
        },
      );
    } finally {
      isSaving.value = false;
    }
  }

  // ─── Avatar Upload ────────────────────────────────────────────────────────
  Future<void> pickAndUploadAvatar() async {
    isUploadingAvatar.value = true;
    // TODO: Implement image picker + upload
    await Future.delayed(const Duration(seconds: 1));
    isUploadingAvatar.value = false;
  }

  // ─── User Stats ───────────────────────────────────────────────────────────
  double? get userBMI {
    final user = _auth.currentUser.value;
    if (user?.weight == null || user?.height == null) return null;
    return FitnessCalculator.calculateBMI(
      weight: user!.weight!,
      height: user.height!,
    );
  }

  String? get userBMICategory {
    final bmi = userBMI;
    if (bmi == null) return null;
    return FitnessCalculator.getBMICategory(bmi);
  }

  double? get userBMR {
    final user = _auth.currentUser.value;
    if (user?.weight == null ||
        user?.height == null ||
        user?.age == null ||
        user?.gender == null) return null;
    return FitnessCalculator.calculateBMR(
      weight: user!.weight!,
      height: user.height!,
      age: user.age!,
      gender: user.gender!,
    );
  }

  double? get userTDEE {
    final user = _auth.currentUser.value;
    final bmr = userBMR;
    if (bmr == null) return null;
    return FitnessCalculator.calculateTDEEFromBMR(
      bmr: bmr,
      activityLevel: user!.activityLevel ?? 'moderately_active',
    );
  }
}
