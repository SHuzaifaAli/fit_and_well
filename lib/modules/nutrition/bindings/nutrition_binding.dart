import 'package:get/get.dart';
import '../controllers/nutrition_controller.dart';

class NutritionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NutritionController>(
        () => NutritionController(), fenix: true);
  }
}
