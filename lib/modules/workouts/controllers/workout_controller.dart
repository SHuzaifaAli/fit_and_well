import 'dart:async';
import 'package:get/get.dart';
import '../../../data/models/workout_model.dart';
import '../../../data/repositories/workout_repository.dart';
import '../../../modules/auth/controllers/auth_controller.dart';

class WorkoutController extends GetxController {
  final WorkoutRepository _repository;
  AuthController get _auth => Get.find<AuthController>();

  WorkoutController({WorkoutRepository? repository})
      : _repository = repository ?? WorkoutRepository();

  // ─── Workout Library ──────────────────────────────────────────────────────
  final RxList<WorkoutModel> allWorkouts = <WorkoutModel>[].obs;
  final RxList<WorkoutModel> filteredWorkouts = <WorkoutModel>[].obs;
  final RxString selectedDifficulty = 'all'.obs;
  final RxBool isLoadingWorkouts = false.obs;

  // ─── Active Workout ───────────────────────────────────────────────────────
  final Rx<WorkoutModel?> activeWorkout = Rx<WorkoutModel?>(null);
  final RxInt currentExerciseIndex = 0.obs;
  final RxBool isWorkoutActive = false.obs;
  final RxBool isResting = false.obs;
  final RxInt elapsedSeconds = 0.obs;
  final RxInt restSecondsRemaining = 0.obs;
  Timer? _workoutTimer;
  Timer? _restTimer;

  // ─── History ──────────────────────────────────────────────────────────────
  final RxList<UserWorkoutModel> workoutHistory = <UserWorkoutModel>[].obs;
  final RxInt workoutStreak = 0.obs;
  final RxBool isLoadingHistory = false.obs;

  // ─── Selected Workout Detail ──────────────────────────────────────────────
  final Rx<WorkoutModel?> selectedWorkout = Rx<WorkoutModel?>(null);
  final RxBool isLoadingDetail = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadWorkouts();
    loadWorkoutHistory();
    loadStreak();
  }

  @override
  void onClose() {
    _workoutTimer?.cancel();
    _restTimer?.cancel();
    super.onClose();
  }

  // ─── Load Workouts ────────────────────────────────────────────────────────

  Future<void> loadWorkouts({bool refresh = false}) async {
    if (isLoadingWorkouts.value && !refresh) return;
    isLoadingWorkouts.value = true;

    final difficulty =
        selectedDifficulty.value == 'all' ? null : selectedDifficulty.value;

    final result = await _repository.getWorkouts(difficulty: difficulty);

    result.fold(
      (failure) => Get.snackbar('Error', failure.message,
          snackPosition: SnackPosition.BOTTOM),
      (workouts) {
        allWorkouts.value = workouts;
        filteredWorkouts.value = workouts;
      },
    );

    isLoadingWorkouts.value = false;
  }

  void filterByDifficulty(String difficulty) {
    selectedDifficulty.value = difficulty;
    loadWorkouts(refresh: true);
  }

  Future<void> loadWorkoutDetail(String workoutId) async {
    isLoadingDetail.value = true;
    final result = await _repository.getWorkoutById(workoutId);
    result.fold(
      (failure) {},
      (workout) => selectedWorkout.value = workout,
    );
    isLoadingDetail.value = false;
  }

  // ─── Active Workout Session ───────────────────────────────────────────────

  void startWorkout(WorkoutModel workout) {
    activeWorkout.value = workout;
    currentExerciseIndex.value = 0;
    isWorkoutActive.value = true;
    isResting.value = false;
    elapsedSeconds.value = 0;
    _startTimer();
  }

  void _startTimer() {
    _workoutTimer?.cancel();
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedSeconds.value++;
    });
  }

  void nextExercise() {
    final workout = activeWorkout.value;
    if (workout == null) return;

    if (currentExerciseIndex.value < workout.exercises.length - 1) {
      final restTime =
          workout.exercises[currentExerciseIndex.value].restTimeSeconds;
      _startRest(restTime);
    } else {
      completeWorkout();
    }
  }

  void _startRest(int seconds) {
    isResting.value = true;
    restSecondsRemaining.value = seconds;
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (restSecondsRemaining.value <= 1) {
        timer.cancel();
        isResting.value = false;
        currentExerciseIndex.value++;
      } else {
        restSecondsRemaining.value--;
      }
    });
  }

  void skipRest() {
    _restTimer?.cancel();
    isResting.value = false;
    currentExerciseIndex.value++;
  }

  Future<void> completeWorkout() async {
    _workoutTimer?.cancel();
    _restTimer?.cancel();
    isWorkoutActive.value = false;

    final workout = activeWorkout.value;
    final userId = _auth.currentUser.value?.id;
    if (workout == null || userId == null) return;

    final durationMinutes = (elapsedSeconds.value / 60).round();

    await _repository.logWorkout(
      userId: userId,
      workoutId: workout.id,
      status: 'completed',
      durationMinutes: durationMinutes,
      caloriesBurned: workout.caloriesBurned,
    );

    activeWorkout.value = null;
    await loadWorkoutHistory();
    await loadStreak();

    Get.back();
    Get.snackbar(
      'Workout Complete! 🎉',
      'You burned ~${workout.caloriesBurned} kcal in $durationMinutes min',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }

  void cancelWorkout() {
    _workoutTimer?.cancel();
    _restTimer?.cancel();
    isWorkoutActive.value = false;
    activeWorkout.value = null;
    Get.back();
  }

  // ─── History & Stats ──────────────────────────────────────────────────────

  Future<void> loadWorkoutHistory() async {
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;

    isLoadingHistory.value = true;
    final result =
        await _repository.getUserWorkoutHistory(userId: userId);
    result.fold(
      (failure) {},
      (history) => workoutHistory.value = history,
    );
    isLoadingHistory.value = false;
  }

  Future<void> loadStreak() async {
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    final result = await _repository.getWorkoutStreak(userId);
    result.fold((f) {}, (streak) => workoutStreak.value = streak);
  }

  String get formattedElapsedTime {
    final minutes = elapsedSeconds.value ~/ 60;
    final seconds = elapsedSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  ExerciseModel? get currentExercise {
    final workout = activeWorkout.value;
    if (workout == null || workout.exercises.isEmpty) return null;
    final idx = currentExerciseIndex.value;
    if (idx >= workout.exercises.length) return null;
    return workout.exercises[idx];
  }

  double get workoutProgress {
    final workout = activeWorkout.value;
    if (workout == null || workout.exercises.isEmpty) return 0;
    return currentExerciseIndex.value / workout.exercises.length;
  }
}
