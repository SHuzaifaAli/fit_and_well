import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../modules/auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final UserRepository _userRepository;
  AuthController get _authController => Get.find<AuthController>();

  ProfileController({UserRepository? userRepository})
      : _userRepository = userRepository ?? UserRepository();

  final RxBool isUploadingAvatar = false.obs;

  // Edit profile form
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final RxString selectedGender = ''.obs;
  final RxString selectedGoal = ''.obs;
  final RxString selectedActivityLevel = ''.obs;
  final RxString selectedDietPreference = ''.obs;
  final editFormKey = GlobalKey<FormState>();
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    _populateForm();
  }

  @override
  void onClose() {
    nameController.dispose();
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.onClose();
  }

  void _populateForm() {
    final user = _authController.currentUser.value;
    if (user == null) return;
    nameController.text = user.name;
    ageController.text = user.age?.toString() ?? '';
    weightController.text = user.weight?.toString() ?? '';
    heightController.text = user.height?.toString() ?? '';
    selectedGender.value = user.gender ?? '';
    selectedGoal.value = user.goal ?? '';
    selectedActivityLevel.value = user.activityLevel ?? '';
    selectedDietPreference.value =
        user.dietPreference ?? AppConstants.dietNone;
  }

  Future<void> pickAndUploadAvatar() async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;

    final user = _authController.currentUser.value;
    if (user == null) return;

    isUploadingAvatar.value = true;
    final bytes = await picked.readAsBytes();
    final fileName =
        'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final result = await _userRepository.uploadProfileImage(
      userId: user.id,
      imageBytes: bytes,
      fileName: fileName,
    );

    isUploadingAvatar.value = false;

    result.fold(
      (failure) => Get.snackbar('Error', failure.message,
          snackPosition: SnackPosition.BOTTOM),
      (url) {
        _authController.updateUser(user.copyWith(avatarUrl: url));
        Get.snackbar('Success', 'Profile photo updated',
            snackPosition: SnackPosition.BOTTOM);
      },
    );
  }

  Future<void> saveProfile() async {
    if (!editFormKey.currentState!.validate()) return;

    final user = _authController.currentUser.value;
    if (user == null) return;

    isSaving.value = true;

    final updated = user.copyWith(
      name: nameController.text.trim(),
      age: int.tryParse(ageController.text),
      weight: double.tryParse(weightController.text),
      height: double.tryParse(heightController.text),
      gender: selectedGender.value.isNotEmpty ? selectedGender.value : null,
      goal: selectedGoal.value.isNotEmpty ? selectedGoal.value : null,
      activityLevel: selectedActivityLevel.value.isNotEmpty
          ? selectedActivityLevel.value
          : null,
      dietPreference: selectedDietPreference.value,
    );

    final result = await _userRepository.updateUserProfile(updated);

    isSaving.value = false;

    result.fold(
      (failure) => Get.snackbar('Error', failure.message,
          snackPosition: SnackPosition.BOTTOM),
      (user) {
        _authController.updateUser(user);
        Get.back();
        Get.snackbar('Saved', 'Profile updated successfully',
            snackPosition: SnackPosition.BOTTOM);
      },
    );
  }
}
