import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/nutrition_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../controllers/nutrition_controller.dart';

class AddMealScreen extends GetView<NutritionController> {
  const AddMealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Add Meal',
            style: AppTypography.titleLargeDark.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            )),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        child: Form(
          key: controller.addMealFormKey,
          child: Column(
            children: [
              AppTextField(
                label: 'Food Name',
                hint: 'e.g. Grilled Chicken',
                controller: controller.foodNameController,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppConstants.spacingMd),
              AppTextField(
                label: 'Calories',
                hint: '0',
                controller: controller.caloriesController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppConstants.spacingXl),
              Obx(() => AppButton(
                    label: 'Save Meal',
                    onPressed: controller.addMeal,
                    isLoading: controller.isAddingMeal.value,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
