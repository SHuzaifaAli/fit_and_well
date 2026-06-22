import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../modules/auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';

/// Onboarding controller managing multi-step profile setup
class OnboardingController extends GetxController {
  final UserRepository _userRepository;
  final StorageService _storageService = Get.find<StorageService>();
  AuthController get _authController => Get.find<AuthController>();

  OnboardingController({UserRepository? userRepository})
      : _userRepository = userRepository ?? UserRepository();

  // ─── Page State ───────────────────────────────────────────────────────────
  final RxInt currentPage = 0.obs;
  final PageController pageController = PageController();
  static const int totalPages = 5;

  // ─── Form Data ────────────────────────────────────────────────────────────
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  final RxString selectedGender = ''.obs;
  final RxString selectedGoal = ''.obs;
  final RxString selectedActivityLevel = ''.obs;
  final RxString selectedDietPreference = AppConstants.dietNone.obs;

  // ─── Loading State ────────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ─── Form Keys ────────────────────────────────────────────────────────────
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    // Pre-fill name if available
    final user = _authController.currentUser.value;
    if (user != null && user.name.isNotEmpty) {
      nameController.text = user.name;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    pageController.dispose();
    super.onClose();
  }

  // ─── Navigation ───────────────────────────────────────────────────────────

  void nextPage() {
    if (currentPage.value < totalPages - 1) {
      currentPage.value++;
      pageController.nextPage(
        duration: AppConstants.animNormal,
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      pageController.previousPage(
        duration: AppConstants.animNormal,
        curve: Curves.easeInOut,
      );
    }
  }

  bool get canGoNext {
    switch (currentPage.value) {
      case 0:
        return nameController.text.isNotEmpty;
      case 1:
        return selectedGender.value.isNotEmpty &&
            ageController.text.isNotEmpty;
      case 2:
        return weightController.text.isNotEmpty &&
            heightController.text.isNotEmpty;
      case 3:
        return selectedGoal.value.isNotEmpty;
      case 4:
        return selectedActivityLevel.value.isNotEmpty;
      default:
        return false;
    }
  }

  // ─── Selection Methods ────────────────────────────────────────────────────

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  void selectGoal(String goal) {
    selectedGoal.value = goal;
  }

  void selectActivityLevel(String level) {
    selectedActivityLevel.value = level;
  }

  void selectDietPreference(String diet) {
    selectedDietPreference.value = diet;
  }

  // ─── Complete Onboarding ──────────────────────────────────────────────────

  Future<void> completeOnboarding() async {
    final user = _authController.currentUser.value;
    if (user == null) return;

    isLoading.value = true;
    errorMessage.value = '';

    final updatedUser = user.copyWith(
      name: nameController.text.trim(),
      age: int.tryParse(ageController.text),
      gender: selectedGender.value,
      weight: double.tryParse(weightController.text),
      height: double.tryParse(heightController.text),
      goal: selectedGoal.value,
      activityLevel: selectedActivityLevel.value,
      dietPreference: selectedDietPreference.value,
    );

    final result = await _userRepository.updateUserProfile(updatedUser);

    isLoading.value = false;

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (user) {
        _authController.updateUser(user);
        _storageService.setOnboardingComplete(true);
        Get.offAllNamed(AppRoutes.dashboard);
      },
    );
  }

  void skipOnboarding() {
    _storageService.setOnboardingComplete(true);
    Get.offAllNamed(AppRoutes.dashboard);
  }
}
