import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../core/utils/fitness_calculator.dart';
import '../../../data/models/progress_model.dart';
import '../../../data/repositories/progress_repository.dart';
import '../../../modules/auth/controllers/auth_controller.dart';
import '../../../modules/workouts/controllers/workout_controller.dart';

class ProgressController extends GetxController {
  final ProgressRepository _repository;
  AuthController get _auth => Get.find<AuthController>();

  ProgressController({ProgressRepository? repository})
      : _repository = repository ?? ProgressRepository();

  // ─── State ────────────────────────────────────────────────────────────────
  final RxList<WeightLogModel> weightLogs = <WeightLogModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt totalWorkouts = 0.obs;
  final RxString selectedPeriod = 'weekly'.obs; // weekly, monthly, yearly

  // ─── Add Weight Form ──────────────────────────────────────────────────────
  final weightController = TextEditingController();
  final bodyFatController = TextEditingController();
  final notesController = TextEditingController();
  final addWeightFormKey = GlobalKey<FormState>();
  final RxBool isSavingWeight = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  @override
  void onClose() {
    weightController.dispose();
    bodyFatController.dispose();
    notesController.dispose();
    super.onClose();
  }

  // ─── Computed Properties ──────────────────────────────────────────────────

  WeightLogModel? get latestLog =>
      weightLogs.isNotEmpty ? weightLogs.first : null;

  WeightLogModel? get oldestLog =>
      weightLogs.isNotEmpty ? weightLogs.last : null;

  double? get weightChange {
    if (weightLogs.length < 2) return null;
    return weightLogs.first.weight - weightLogs.last.weight;
  }

  double? get currentBMI {
    final user = _auth.currentUser.value;
    if (user?.weight == null || user?.height == null) return null;
    final w = latestLog?.weight ?? user!.weight!;
    return FitnessCalculator.calculateBMI(
        weight: w, height: user!.height!);
  }

  int get workoutStreak {
    try {
      return Get.find<WorkoutController>().workoutStreak.value;
    } catch (_) {
      return 0;
    }
  }

  List<WeightLogModel> get filteredLogs {
    final now = DateTime.now();
    DateTime cutoff;
    switch (selectedPeriod.value) {
      case 'weekly':
        cutoff = now.subtract(const Duration(days: 7));
        break;
      case 'monthly':
        cutoff = now.subtract(const Duration(days: 30));
        break;
      case 'yearly':
        cutoff = now.subtract(const Duration(days: 365));
        break;
      default:
        cutoff = now.subtract(const Duration(days: 7));
    }
    return weightLogs
        .where((log) => log.date.isAfter(cutoff))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // ─── Load Data ────────────────────────────────────────────────────────────

  Future<void> loadData() async {
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;

    isLoading.value = true;

    final logsResult =
        await _repository.getWeightLogs(userId: userId, limit: 90);
    logsResult.fold(
      (failure) {},
      (logs) => weightLogs.value = logs,
    );

    final workoutsResult =
        await _repository.getTotalWorkoutsCompleted(userId);
    workoutsResult.fold(
      (failure) {},
      (count) => totalWorkouts.value = count,
    );

    isLoading.value = false;
  }

  // ─── Add Weight ───────────────────────────────────────────────────────────

  Future<void> addWeightLog() async {
    if (!addWeightFormKey.currentState!.validate()) return;

    final userId = _auth.currentUser.value?.id;
    final user = _auth.currentUser.value;
    if (userId == null) return;

    isSavingWeight.value = true;

    final weight = double.parse(weightController.text);
    final bmi = user?.height != null
        ? FitnessCalculator.calculateBMI(
            weight: weight, height: user!.height!)
        : null;

    final log = WeightLogModel(
      id: const Uuid().v4(),
      userId: userId,
      weight: weight,
      bodyFatPercentage: double.tryParse(bodyFatController.text),
      bmi: bmi,
      notes: notesController.text.trim().isNotEmpty
          ? notesController.text.trim()
          : null,
      date: DateTime.now(),
      createdAt: DateTime.now(),
    );

    final result = await _repository.addWeightLog(log);

    isSavingWeight.value = false;

    result.fold(
      (failure) => Get.snackbar('Error', failure.message,
          snackPosition: SnackPosition.BOTTOM),
      (added) {
        weightLogs.insert(0, added);
        _clearForm();
        Get.back();
        Get.snackbar('Logged', 'Weight recorded: ${weight}kg',
            snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  Future<void> deleteWeightLog(String logId) async {
    final result = await _repository.deleteWeightLog(logId);
    result.fold(
      (failure) => Get.snackbar('Error', failure.message,
          snackPosition: SnackPosition.BOTTOM),
      (_) => weightLogs.removeWhere((log) => log.id == logId),
    );
  }

  void _clearForm() {
    weightController.clear();
    bodyFatController.clear();
    notesController.clear();
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
  }
}
