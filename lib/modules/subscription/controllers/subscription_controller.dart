import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/subscription_model.dart';
import '../../../modules/auth/controllers/auth_controller.dart';

class SubscriptionController extends GetxController {
  AuthController get _auth => Get.find<AuthController>();

  final RxBool isLoading = false.obs;
  final RxString selectedPlan = 'monthly'.obs;
  final Rx<SubscriptionModel?> currentSubscription =
      Rx<SubscriptionModel?>(null);

  bool get isPremium => _auth.currentUser.value?.isPremium ?? false;

  final List<Map<String, dynamic>> plans = [
    {
      'id': 'monthly',
      'label': 'Monthly',
      'price': '\$4.99',
      'period': '/month',
      'description': 'Billed monthly',
      'savings': null,
    },
    {
      'id': 'yearly',
      'label': 'Yearly',
      'price': '\$39.99',
      'period': '/year',
      'description': 'Billed annually',
      'savings': 'Save 33%',
    },
    {
      'id': 'lifetime',
      'label': 'Lifetime',
      'price': '\$79.99',
      'period': '',
      'description': 'One-time purchase',
      'savings': 'Best Value',
    },
  ];

  final List<Map<String, dynamic>> premiumFeatures = [
    {
      'icon': '🤖',
      'title': 'Unlimited AI Coach',
      'description': 'Chat with your AI coach anytime',
    },
    {
      'icon': '🍽️',
      'title': 'Personalized Meal Plans',
      'description': 'AI-generated daily meal plans',
    },
    {
      'icon': '📊',
      'title': 'Advanced Analytics',
      'description': 'Detailed progress insights & predictions',
    },
    {
      'icon': '⌚',
      'title': 'Wearable Sync',
      'description': 'Connect Apple Health & Samsung Health',
    },
    {
      'icon': '🎯',
      'title': 'Custom Workout Plans',
      'description': 'AI-tailored workout programs',
    },
  ];

  void selectPlan(String planId) {
    selectedPlan.value = planId;
  }

  Future<void> subscribe() async {
    isLoading.value = true;

    // Simulate purchase flow — integrate with RevenueCat / Stripe in production
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    Get.snackbar(
      'Coming Soon',
      'In-app purchases will be available in the next release.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> restorePurchases() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    Get.snackbar(
      'Restore Purchases',
      'No active subscription found.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
