import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

/// Authentication controller managing auth state and operations
class AuthController extends GetxController {
  final AuthRepository _authRepository;
  final StorageService _storageService = Get.find<StorageService>();

  AuthController({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();

  // ─── Reactive State ───────────────────────────────────────────────────────
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isAuthenticated = false.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Form Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  // Form Keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final forgotPasswordFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _checkAuthState();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  // ─── Auth State Check ─────────────────────────────────────────────────────

  Future<void> _checkAuthState() async {
    isLoading.value = true;
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        currentUser.value = user;
        isAuthenticated.value = true;
        _navigateAfterAuth(user);
      } else {
        isAuthenticated.value = false;
        Get.offAllNamed(AppRoutes.login);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Email Sign In ────────────────────────────────────────────────────────

  Future<void> signInWithEmail() async {
    if (!loginFormKey.currentState!.validate()) return;

    _clearError();
    isLoading.value = true;

    final result = await _authRepository.signInWithEmail(
      email: emailController.text,
      password: passwordController.text,
    );

    isLoading.value = false;

    result.fold(
      (failure) => _setError(failure.message),
      (user) {
        currentUser.value = user;
        isAuthenticated.value = true;
        _navigateAfterAuth(user);
      },
    );
  }

  // ─── Email Sign Up ────────────────────────────────────────────────────────

  Future<void> signUpWithEmail() async {
    if (!registerFormKey.currentState!.validate()) return;

    _clearError();
    isLoading.value = true;

    final result = await _authRepository.signUpWithEmail(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
    );

    isLoading.value = false;

    result.fold(
      (failure) => _setError(failure.message),
      (user) {
        currentUser.value = user;
        isAuthenticated.value = true;
        // New user goes to onboarding
        Get.offAllNamed(AppRoutes.onboarding);
      },
    );
  }

  // ─── Google Sign In ───────────────────────────────────────────────────────

  Future<void> signInWithGoogle() async {
    _clearError();
    isLoading.value = true;

    final result = await _authRepository.signInWithGoogle();

    isLoading.value = false;

    result.fold(
      (failure) => _setError(failure.message),
      (user) {
        currentUser.value = user;
        isAuthenticated.value = true;
        _navigateAfterAuth(user);
      },
    );
  }

  // ─── Apple Sign In ────────────────────────────────────────────────────────

  Future<void> signInWithApple() async {
    _clearError();
    isLoading.value = true;

    final result = await _authRepository.signInWithApple();

    isLoading.value = false;

    result.fold(
      (failure) => _setError(failure.message),
      (user) {
        currentUser.value = user;
        isAuthenticated.value = true;
        _navigateAfterAuth(user);
      },
    );
  }

  // ─── Forgot Password ──────────────────────────────────────────────────────

  Future<void> sendPasswordResetEmail() async {
    if (!forgotPasswordFormKey.currentState!.validate()) return;

    _clearError();
    isLoading.value = true;

    final result = await _authRepository.sendPasswordResetEmail(
      emailController.text,
    );

    isLoading.value = false;

    result.fold(
      (failure) => _setError(failure.message),
      (_) {
        Get.snackbar(
          'Email Sent',
          'Password reset email sent to ${emailController.text}',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.back();
      },
    );
  }

  // ─── Sign Out ─────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    isLoading.value = true;

    final result = await _authRepository.signOut();

    isLoading.value = false;

    result.fold(
      (failure) => _setError(failure.message),
      (_) {
        currentUser.value = null;
        isAuthenticated.value = false;
        _storageService.clearAll();
        Get.offAllNamed(AppRoutes.login);
      },
    );
  }

  // ─── Navigation Logic ─────────────────────────────────────────────────────

  void _navigateAfterAuth(UserModel user) {
    if (!user.isProfileComplete) {
      Get.offAllNamed(AppRoutes.onboarding);
    } else if (!_storageService.isOnboardingComplete) {
      Get.offAllNamed(AppRoutes.onboarding);
    } else {
      Get.offAllNamed(AppRoutes.dashboard);
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  void _setError(String message) {
    errorMessage.value = message;
  }

  void _clearError() {
    errorMessage.value = '';
  }

  void clearForm() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();
    _clearError();
  }

  void updateUser(UserModel user) {
    currentUser.value = user;
  }
}
