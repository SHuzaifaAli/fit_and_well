import 'package:get/get.dart';
import '../../../modules/auth/controllers/auth_controller.dart';
import '../../../modules/nutrition/controllers/nutrition_controller.dart';
import '../../../modules/workouts/controllers/workout_controller.dart';

class DashboardController extends GetxController {
  AuthController get _auth => Get.find<AuthController>();

  final RxInt currentTabIndex = 0.obs;

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String get userName {
    final name = _auth.currentUser.value?.name ?? '';
    return name.split(' ').first;
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  Future<void> refreshAll() async {
    try {
      await Get.find<NutritionController>().loadTodayData();
    } catch (_) {}
    try {
      await Get.find<WorkoutController>().loadWorkouts(refresh: true);
    } catch (_) {}
  }
}
