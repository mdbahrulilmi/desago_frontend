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

  void onUpdatePassword() async {
    if (isLoading.value) return;

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

    try{
      isLoading.value = true;
      
      await Future.delayed(const Duration(seconds: 2));

      if (token == 'expired') {
        throw 'TOKEN_EXPIRED';
      }

      final response = await DioService.instance.post(
        ApiConstant.newPassword, 
        data: {
          'token': token,
          'email': email,
          'password': passwordController.text,
        },
      );

      print(response);

      Get.snackbar(
        'Berhasil',
        'Kata sandi berhasil diperbarui',
        backgroundColor: AppColors.success,
        colorText: AppColors.white,
      );

      Get.offAllNamed('/login');

    } catch (e) {
    if (e == 'TOKEN_EXPIRED') {
      Get.snackbar(
        'Error',
        'Link reset sudah kadaluarsa',
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan, coba lagi',
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
      );
    }
  }

    
  }

  @override
  void onInit() {
    super.onInit();

    token = Get.parameters['token'] ?? '';
    email = Get.parameters['email'] ?? '';

    if (token.isEmpty) {
      Get.offAllNamed('/invalid-link');
      return;
    }

    passwordController.addListener(() {
      checkPasswordStrength(passwordController.text);
    });
  }


  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
