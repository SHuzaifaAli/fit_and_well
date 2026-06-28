import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_text_field.dart';
import '../controllers/nutrition_controller.dart';

class NutritionScreen extends GetView<NutritionController> {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Nutrition',
          style: AppTypography.titleLargeDark.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today_outlined,
                size: 20,
                color: isDark ? AppColors.darkIcon : AppColors.lightIcon),
            onPressed: () => _pickDate(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMealSheet(context, isDark),
        backgroundColor: isDark ? AppColors.white : AppColors.black,
        child: Icon(Icons.add_rounded,
            color: isDark ? AppColors.black : AppColors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.loadTodayData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppConstants.spacingXl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Date Header ──────────────────────────────────────────
                _buildDateHeader(isDark),
                const SizedBox(height: AppConstants.spacingXl),

                // ── Calorie Summary ──────────────────────────────────────
                _buildCalorieSummary(isDark),
                const SizedBox(height: AppConstants.spacingXl),

                // ── Macros ───────────────────────────────────────────────
                _buildMacros(isDark),
                const SizedBox(height: AppConstants.spacingXl),

                // ── Water Intake ─────────────────────────────────────────
                _buildWaterCard(isDark),
                const SizedBox(height: AppConstants.spacingXl),

                // ── Meals ────────────────────────────────────────────────
                _buildMealSections(isDark),
                const SizedBox(height: 80), // FAB padding
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDateHeader(bool isDark) {
    return Obx(() {
      final date = controller.selectedDate.value;
      final now = DateTime.now();
      final isToday = date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;

      return Text(
        isToday
            ? 'Today'
            : '${date.day}/${date.month}/${date.year}',
        style: AppTypography.headlineSmallDark.copyWith(
          color:
              isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
      );
    });
  }

  Widget _buildCalorieSummary(bool isDark) {
    return AppCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calories',
                style: AppTypography.titleMediumDark.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              Obx(() => Text(
                    '${controller.totalCalories.toStringAsFixed(0)} / ${controller.dailyCalorieGoal.toStringAsFixed(0)} kcal',
                    style: AppTypography.bodyMediumDark.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  )),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Obx(() => ClipRRect(
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusFull),
                child: LinearProgressIndicator(
                  value: controller.calorieProgress,
                  minHeight: 10,
                  backgroundColor:
                      isDark ? AppColors.gray700 : AppColors.gray200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    controller.calorieProgress > 1.0
                        ? AppColors.error
                        : (isDark ? AppColors.white : AppColors.black),
                  ),
                ),
              )),
          const SizedBox(height: AppConstants.spacingMd),
          Obx(() {
            final remaining = controller.dailyCalorieGoal -
                controller.totalCalories;
            return Text(
              remaining >= 0
                  ? '${remaining.toStringAsFixed(0)} kcal remaining'
                  : '${(-remaining).toStringAsFixed(0)} kcal over goal',
              style: AppTypography.bodySmallDark.copyWith(
                color: remaining < 0
                    ? AppColors.errorLight
                    : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildMacros(bool isDark) {
    return Obx(() => Row(
          children: [
            Expanded(
                child: _MacroCard(
                    label: 'Protein',
                    value: controller.totalProtein,
                    unit: 'g',
                    isDark: isDark)),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
                child: _MacroCard(
                    label: 'Carbs',
                    value: controller.totalCarbs,
                    unit: 'g',
                    isDark: isDark)),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
                child: _MacroCard(
                    label: 'Fat',
                    value: controller.totalFat,
                    unit: 'g',
                    isDark: isDark)),
          ],
        )).animate(delay: 100.ms).fadeIn();
  }

  Widget _buildWaterCard(bool isDark) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Water Intake',
                style: AppTypography.titleMediumDark.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              Obx(() => Text(
                    '${(controller.waterIntakeMl.value / 1000).toStringAsFixed(1)}L / ${(controller.waterGoalMl / 1000).toStringAsFixed(1)}L',
                    style: AppTypography.bodyMediumDark.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  )),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Obx(() => ClipRRect(
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusFull),
                child: LinearProgressIndicator(
                  value: controller.waterProgress,
                  minHeight: 8,
                  backgroundColor:
                      isDark ? AppColors.gray700 : AppColors.gray200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? AppColors.white : AppColors.black,
                  ),
                ),
              )),
          const SizedBox(height: AppConstants.spacingMd),
          // Quick add buttons
          Row(
            children: [250, 500, 750].map((ml) {
              return Padding(
                padding:
                    const EdgeInsets.only(right: AppConstants.spacingSm),
                child: OutlinedButton(
                  onPressed: () => controller.addWater(ml.toDouble()),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingMd,
                        vertical: 6),
                    side: BorderSide(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMd),
                    ),
                  ),
                  child: Text(
                    '+${ml}ml',
                    style: AppTypography.labelSmallDark.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate(delay: 200.ms).fadeIn();
  }

  Widget _buildMealSections(bool isDark) {
    final mealTypes = ['breakfast', 'lunch', 'dinner', 'snack'];

    return Column(
      children: mealTypes.asMap().entries.map((entry) {
        final mealType = entry.value;
        return Obx(() {
          final meals = controller.mealsByType[mealType] ?? [];
          final mealCalories =
              meals.fold<double>(0, (sum, m) => sum + m.calories);

          return _MealSection(
            mealType: mealType,
            meals: meals,
            totalCalories: mealCalories,
            isDark: isDark,
            onDelete: controller.deleteMeal,
            onAdd: () => _showAddMealSheet(context, isDark,
                initialMealType: mealType),
          );
        });
      }).toList(),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) controller.changeDate(picked);
  }

  void _showAddMealSheet(BuildContext context, bool isDark,
      {String? initialMealType}) {
    if (initialMealType != null) {
      controller.selectedMealType.value = initialMealType;
    }

    Get.bottomSheet(
      _AddMealSheet(isDark: isDark),
      isScrollControlled: true,
      backgroundColor:
          isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusXl)),
      ),
    );
  }

  // ignore: use_build_context_synchronously
  BuildContext get context => Get.context!;
}

class _MacroCard extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final bool isDark;

  const _MacroCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Text(
            '${value.toStringAsFixed(0)}$unit',
            style: AppTypography.titleLargeDark.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          Text(
            label,
            style: AppTypography.bodySmallDark.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MealSection extends StatelessWidget {
  final String mealType;
  final List meals;
  final double totalCalories;
  final bool isDark;
  final Function(String) onDelete;
  final VoidCallback onAdd;

  const _MealSection({
    required this.mealType,
    required this.meals,
    required this.totalCalories,
    required this.isDark,
    required this.onDelete,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              mealType[0].toUpperCase() + mealType.substring(1),
              style: AppTypography.titleSmallDark.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            Row(
              children: [
                if (totalCalories > 0)
                  Text(
                    '${totalCalories.toStringAsFixed(0)} kcal',
                    style: AppTypography.bodySmallDark.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                const SizedBox(width: AppConstants.spacingSm),
                IconButton(
                  icon: Icon(Icons.add_circle_outline_rounded,
                      size: 20,
                      color:
                          isDark ? AppColors.darkIcon : AppColors.lightIcon),
                  onPressed: onAdd,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
        if (meals.isEmpty)
          Padding(
            padding:
                const EdgeInsets.only(bottom: AppConstants.spacingMd),
            child: Text(
              'No items logged',
              style: AppTypography.bodySmallDark.copyWith(
                color: isDark
                    ? AppColors.darkTextTertiary
                    : AppColors.lightTextTertiary,
              ),
            ),
          )
        else
          ...meals.map((meal) => _MealItem(
                meal: meal,
                isDark: isDark,
                onDelete: () => onDelete(meal.id),
              )),
        const SizedBox(height: AppConstants.spacingMd),
      ],
    );
  }
}

class _MealItem extends StatelessWidget {
  final meal;
  final bool isDark;
  final VoidCallback onDelete;

  const _MealItem(
      {required this.meal, required this.isDark, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(meal.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppConstants.spacingXl),
        color: AppColors.error,
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                meal.foodName,
                style: AppTypography.bodyMediumDark.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ),
            Text(
              '${meal.calories.toStringAsFixed(0)} kcal',
              style: AppTypography.labelMediumDark.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddMealSheet extends GetView<NutritionController> {
  final bool isDark;

  const _AddMealSheet({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppConstants.spacingXl,
        right: AppConstants.spacingXl,
        top: AppConstants.spacingXl,
        bottom: MediaQuery.of(context).viewInsets.bottom +
            AppConstants.spacingXl,
      ),
      child: Form(
        key: controller.addMealFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Log Food',
              style: AppTypography.titleLargeDark.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingXl),

            // Meal type selector
            Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['breakfast', 'lunch', 'dinner', 'snack']
                        .map((type) {
                      final isSelected =
                          controller.selectedMealType.value == type;
                      return GestureDetector(
                        onTap: () =>
                            controller.selectedMealType.value = type,
                        child: AnimatedContainer(
                          duration: AppConstants.animFast,
                          margin: const EdgeInsets.only(
                              right: AppConstants.spacingSm),
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingMd,
                              vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark
                                    ? AppColors.white
                                    : AppColors.black)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusFull),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : (isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder),
                            ),
                          ),
                          child: Text(
                            type[0].toUpperCase() + type.substring(1),
                            style: AppTypography.labelSmallDark.copyWith(
                              color: isSelected
                                  ? (isDark
                                      ? AppColors.black
                                      : AppColors.white)
                                  : (isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )),

            const SizedBox(height: AppConstants.spacingMd),

            AppTextField(
              label: 'Food Name',
              hint: 'e.g. Grilled Chicken',
              controller: controller.foodNameController,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: AppConstants.spacingMd),

            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Calories',
                    hint: '0',
                    controller: controller.caloriesController,
                    keyboardType: TextInputType.number,
                    validator: Validators.positiveNumber,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  child: AppTextField(
                    label: 'Protein (g)',
                    hint: '0',
                    controller: controller.proteinController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingMd),

            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Carbs (g)',
                    hint: '0',
                    controller: controller.carbsController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  child: AppTextField(
                    label: 'Fat (g)',
                    hint: '0',
                    controller: controller.fatController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingXl),

            Obx(() => AppButton(
                  label: 'Add Food',
                  onPressed: controller.addMeal,
                  isLoading: controller.isAddingMeal.value,
                )),
          ],
        ),
      ),
    );
  }
}
