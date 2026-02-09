import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordBaruController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  late final String token;
  late final String email;

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  final passwordStrength = 0.0.obs;
  final passwordStrengthText = ''.obs;
  final passwordStrengthColor = AppColors.danger.obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    token = Get.parameters['token'] ?? '';
    email = Get.parameters['email'] ?? '';

    passwordController.addListener(() {
      checkPasswordStrength(passwordController.text);
    });
  }

  @override
  void onReady() {
    super.onReady();

    if (token.isEmpty || email.isEmpty) {
      Get.offAllNamed('/login');
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.toggle();
  }

  void checkPasswordStrength(String value) {
    if (value.isEmpty) {
      passwordStrength.value = 0;
      passwordStrengthText.value = '';
      passwordStrengthColor.value = AppColors.danger;
      return;
    }

    int strength = 0;
    if (value.length >= 8) strength++;
    if (value.contains(RegExp(r'[A-Z]'))) strength++;
    if (value.contains(RegExp(r'[a-z]'))) strength++;
    if (value.contains(RegExp(r'[0-9]'))) strength++;
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

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

  Future<void> onUpdatePassword() async {
    if (isLoading.value) return;

    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _error('Mohon lengkapi semua field');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _error('Konfirmasi kata sandi tidak cocok');
      return;
    }

    if (passwordStrength.value < 0.6) {
      _error('Kata sandi terlalu lemah');
      return;
    }

    try {
      isLoading.value = true;

      await DioService.instance.post(
        ApiConstant.newPassword,
        data: {
          'token': token,
          'email': email,
          'password': passwordController.text,
        },
      );

      Get.snackbar(
        'Berhasil',
        'Kata sandi berhasil diperbarui',
        backgroundColor: AppColors.success,
        colorText: AppColors.white,
      );

      Get.offAllNamed('/login');
    } catch (_) {
      _error('Link reset sudah tidak berlaku');
    } finally {
      isLoading.value = false;
    }
  }

  void _error(String msg) {
    Get.snackbar(
      'Error',
      msg,
      backgroundColor: AppColors.danger,
      colorText: AppColors.white,
    );
  }
}
