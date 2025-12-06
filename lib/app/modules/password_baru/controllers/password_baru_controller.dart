import 'package:desago/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordBaruController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final passwordStrength = 0.0.obs;
  final passwordStrengthText = ''.obs;
  final passwordStrengthColor = AppColors.danger.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void checkPasswordStrength(String value) {
    if (value.isEmpty) {
      passwordStrength.value = 0.0;
      passwordStrengthText.value = '';
      passwordStrengthColor.value = AppColors.danger;
      return;
    }

    bool hasMinLength = value.length >= 8;
    bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
    bool hasDigits = value.contains(RegExp(r'[0-9]'));
    bool hasLowercase = value.contains(RegExp(r'[a-z]'));
    bool hasSpecialCharacters = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    int strength = 0;
    if (hasMinLength) strength++;
    if (hasUppercase) strength++;
    if (hasDigits) strength++;
    if (hasLowercase) strength++;
    if (hasSpecialCharacters) strength++;

    passwordStrength.value = strength / 5;

    if (strength <= 2) {
      passwordStrengthText.value = 'Lemah';
      passwordStrengthColor.value = AppColors.danger;
    } else if (strength <= 4) {
      passwordStrengthText.value = 'Sedang';
      passwordStrengthColor.value = AppColors.warning;
    } else {
      passwordStrengthText.value = 'Kuat';
      passwordStrengthColor.value = AppColors.success;
    }
  }

  void onUpdatePassword() {
    // Validasi password
    if (passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Mohon lengkapi semua field',
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Konfirmasi kata sandi tidak cocok',
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
      );
      return;
    }

    if (passwordStrength.value < 0.6) {
      Get.snackbar(
        'Error',
        'Kata sandi terlalu lemah',
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
      );
      return;
    }

    // Implement update password logic
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
