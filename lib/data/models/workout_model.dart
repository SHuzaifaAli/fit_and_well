/// Workout data model
class WorkoutModel {
  final String id;
  final String title;
  final String? description;
  final String difficulty; // beginner, intermediate, advanced
  final int durationMinutes;
  final int caloriesBurned;
  final String? imageUrl;
  final String? category; // chest, back, legs, etc.
  final List<ExerciseModel> exercises;
  final bool isActive;
  final DateTime createdAt;

  const WorkoutModel({
    required this.id,
    required this.title,
    this.description,
    required this.difficulty,
    required this.durationMinutes,
    required this.caloriesBurned,
    this.imageUrl,
    this.category,
    this.exercises = const [],
    this.isActive = true,
    required this.createdAt,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      difficulty: json['difficulty'] as String? ?? 'beginner',
      durationMinutes: json['duration'] as int? ?? 30,
      caloriesBurned: json['calories'] as int? ?? 200,
      imageUrl: json['image'] as String?,
      category: json['category'] as String?,
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((e) =>
                  ExerciseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(
          json['created_at'] as String? ??
              DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (description != null) 'description': description,
      'difficulty': difficulty,
      'duration': durationMinutes,
      'calories': caloriesBurned,
      if (imageUrl != null) 'image': imageUrl,
      if (category != null) 'category': category,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }

  WorkoutModel copyWith({
    String? id,
    String? title,
    String? description,
    String? difficulty,
    int? durationMinutes,
    int? caloriesBurned,
    String? imageUrl,
    String? category,
    List<ExerciseModel>? exercises,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      exercises: exercises ?? this.exercises,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Exercise data model
class ExerciseModel {
  final String id;
  final String workoutId;
  final String name;
  final String? instructions;
  final String? muscleGroup;
  final int sets;
  final int reps;
  final int restTimeSeconds;
  final String? videoUrl;
  final String? imageUrl;
  final int? durationSeconds; // For time-based exercises
  final int orderIndex;

  const ExerciseModel({
    required this.id,
    required this.workoutId,
    required this.name,
    this.instructions,
    this.muscleGroup,
    this.sets = 3,
    this.reps = 10,
    this.restTimeSeconds = 60,
    this.videoUrl,
    this.imageUrl,
    this.durationSeconds,
    this.orderIndex = 0,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] as String,
      workoutId: json['workout_id'] as String? ?? '',
      name: json['name'] as String,
      instructions: json['instructions'] as String?,
      muscleGroup: json['muscle_group'] as String?,
      sets: json['sets'] as int? ?? 3,
      reps: json['reps'] as int? ?? 10,
      restTimeSeconds: json['rest_time'] as int? ?? 60,
      videoUrl: json['video_url'] as String?,
      imageUrl: json['image_url'] as String?,
      durationSeconds: json['duration_seconds'] as int?,
      orderIndex: json['order_index'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workout_id': workoutId,
      'name': name,
      if (instructions != null) 'instructions': instructions,
      if (muscleGroup != null) 'muscle_group': muscleGroup,
      'sets': sets,
      'reps': reps,
      'rest_time': restTimeSeconds,
      if (videoUrl != null) 'video_url': videoUrl,
      if (imageUrl != null) 'image_url': imageUrl,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      'order_index': orderIndex,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// User workout log model
class UserWorkoutModel {
  final String id;
  final String userId;
  final String workoutId;
  final String status; // pending, in_progress, completed, skipped
  final DateTime? completedAt;
  final int? durationMinutes;
  final int? caloriesBurned;
  final DateTime createdAt;

  const UserWorkoutModel({
    required this.id,
    required this.userId,
    required this.workoutId,
    required this.status,
    this.completedAt,
    this.durationMinutes,
    this.caloriesBurned,
    required this.createdAt,
  });

  bool get isCompleted => status == 'completed';

  factory UserWorkoutModel.fromJson(Map<String, dynamic> json) {
    return UserWorkoutModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      workoutId: json['workout_id'] as String,
      status: json['status'] as String? ?? 'pending',
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      durationMinutes: json['duration_minutes'] as int?,
      caloriesBurned: json['calories_burned'] as int?,
      createdAt: DateTime.parse(
          json['created_at'] as String? ??
              DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'workout_id': workoutId,
      'status': status,
      if (completedAt != null)
        'completed_at': completedAt!.toIso8601String(),
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (caloriesBurned != null) 'calories_burned': caloriesBurned,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
