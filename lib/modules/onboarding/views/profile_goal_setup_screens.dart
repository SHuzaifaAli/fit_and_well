import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

/// Thin redirect wrapper — keeps legacy route alive while onboarding
/// is now handled as a unified multi-step flow in OnboardingScreen.
class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  void initState() {
    // If someone navigates here directly, send them to the unified flow.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAllNamed(AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

/// Thin redirect wrapper for /goal-setup
class GoalSetupScreen extends StatelessWidget {
  const GoalSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAllNamed(AppRoutes.onboarding);
    });
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
