import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/fitness_calculator.dart';
import '../../../data/models/nutrition_model.dart';
import '../../../data/repositories/nutrition_repository.dart';
import '../../../modules/auth/controllers/auth_controller.dart';

class NutritionController extends GetxController {
  final NutritionRepository _repository;
  AuthController get _auth => Get.find<AuthController>();

  NutritionController({NutritionRepository? repository})
      : _repository = repository ?? NutritionRepository();

  // ─── State ────────────────────────────────────────────────────────────────
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxList<NutritionLogModel> todayLogs = <NutritionLogModel>[].obs;
  final RxDouble waterIntakeMl = 0.0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isAddingMeal = false.obs;

  // ─── Add Meal Form ────────────────────────────────────────────────────────
  final foodNameController = TextEditingController();
  final caloriesController = TextEditingController();
  final proteinController = TextEditingController();
  final carbsController = TextEditingController();
  final fatController = TextEditingController();
  final RxString selectedMealType = 'breakfast'.obs;
  final addMealFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadTodayData();
  }

  @override
  void onClose() {
    foodNameController.dispose();
    caloriesController.dispose();
    proteinController.dispose();
    carbsController.dispose();
    fatController.dispose();
    super.onClose();
  }

  // ─── Computed Properties ──────────────────────────────────────────────────

  double get totalCalories =>
      todayLogs.fold(0, (sum, log) => sum + log.calories);

  double get totalProtein =>
      todayLogs.fold(0, (sum, log) => sum + (log.protein ?? 0));

  double get totalCarbs =>
      todayLogs.fold(0, (sum, log) => sum + (log.carbs ?? 0));

  double get totalFat =>
      todayLogs.fold(0, (sum, log) => sum + (log.fat ?? 0));

  double get dailyCalorieGoal {
    final user = _auth.currentUser.value;
    if (user == null || !user.isProfileComplete) return 2000;
    final bmr = FitnessCalculator.calculateBMR(
      weight: user.weight!,
      height: user.height!,
      age: user.age!,
      gender: user.gender ?? 'male',
    );
    return FitnessCalculator.calculateTDEEFromBMR(
      bmr: bmr,
      activityLevel: user.activityLevel ?? AppConstants.activityModeratelyActive,
    );
  }

  double get calorieProgress =>
      (totalCalories / dailyCalorieGoal).clamp(0.0, 1.0);

  double get waterGoalMl => 2500;
  double get waterProgress =>
      (waterIntakeMl.value / waterGoalMl).clamp(0.0, 1.0);

  Map<String, List<NutritionLogModel>> get mealsByType {
    final Map<String, List<NutritionLogModel>> grouped = {};
    for (final log in todayLogs) {
      grouped.putIfAbsent(log.mealType, () => []).add(log);
    }
    return grouped;
  }

  // ─── Load Data ────────────────────────────────────────────────────────────

  Future<void> loadTodayData() async {
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;

    isLoading.value = true;

    final logsResult = await _repository.getNutritionLogs(
      userId: userId,
      date: selectedDate.value,
    );
    logsResult.fold(
      (failure) {},
      (logs) => todayLogs.value = logs,
    );

    final waterResult = await _repository.getWaterIntake(
      userId: userId,
      date: selectedDate.value,
    );
    waterResult.fold(
      (failure) {},
      (ml) => waterIntakeMl.value = ml,
    );

    isLoading.value = false;
  }

  void changeDate(DateTime date) {
    selectedDate.value = date;
    loadTodayData();
  }

  // ─── Add Meal ─────────────────────────────────────────────────────────────

  Future<void> addMeal() async {
    if (!addMealFormKey.currentState!.validate()) return;

    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;

    isAddingMeal.value = true;

    final log = NutritionLogModel(
      id: const Uuid().v4(),
      userId: userId,
      mealType: selectedMealType.value,
      foodName: foodNameController.text.trim(),
      calories: double.tryParse(caloriesController.text) ?? 0,
      protein: double.tryParse(proteinController.text),
      carbs: double.tryParse(carbsController.text),
      fat: double.tryParse(fatController.text),
      date: selectedDate.value,
      createdAt: DateTime.now(),
    );

    final result = await _repository.addNutritionLog(log);

    isAddingMeal.value = false;

    result.fold(
      (failure) => Get.snackbar('Error', failure.message,
          snackPosition: SnackPosition.BOTTOM),
      (added) {
        todayLogs.add(added);
        _clearAddMealForm();
        Get.back();
        Get.snackbar('Added', '${added.foodName} logged',
            snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  Future<void> deleteMeal(String logId) async {
    final result = await _repository.deleteNutritionLog(logId);
    result.fold(
      (failure) => Get.snackbar('Error', failure.message,
          snackPosition: SnackPosition.BOTTOM),
      (_) {
        todayLogs.removeWhere((log) => log.id == logId);
      },
    );
  }

  // ─── Water Intake ─────────────────────────────────────────────────────────

  Future<void> addWater(double amountMl) async {
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;

    final result = await _repository.logWater(
      userId: userId,
      amountMl: amountMl,
    );

    result.fold(
      (failure) => Get.snackbar('Error', failure.message,
          snackPosition: SnackPosition.BOTTOM),
      (_) {
        waterIntakeMl.value += amountMl;
      },
    );
  }

  void _clearAddMealForm() {
    foodNameController.clear();
    caloriesController.clear();
    proteinController.clear();
    carbsController.clear();
    fatController.clear();
    selectedMealType.value = 'breakfast';
  }
}
