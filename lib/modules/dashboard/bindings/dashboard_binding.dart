import 'package:get/get.dart';
import '../../ai_coach/controllers/ai_coach_controller.dart';
import '../../nutrition/controllers/nutrition_controller.dart';
import '../../progress/controllers/progress_controller.dart';
import '../../workouts/controllers/workout_controller.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<WorkoutController>(() => WorkoutController(), fenix: true);
    Get.lazyPut<NutritionController>(() => NutritionController(), fenix: true);
    Get.lazyPut<ProgressController>(() => ProgressController(), fenix: true);
    Get.lazyPut<AiCoachController>(() => AiCoachController(), fenix: true);
  }
}
