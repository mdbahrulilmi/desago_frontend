import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/UserModel.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/services/storage_services.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final namaLengkapController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  Future<void> onRegister() async {
    try {
      isLoading.value = true;

      final response = await DioService.instance.post(
        ApiConstant.register,
        data: {
          'username': usernameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'desa_id': ApiConstant.desaId
        },
      );

      final responseData = response.data as Map<String, dynamic>;
  
      if (response.statusCode == 200 || response.data['success'] == true) {
        Get.snackbar(
          'Registrasi Berhasil',
          responseData['message'] ?? 'Selamat datang! Silakan login.',
          backgroundColor: AppColors.success,
          colorText: AppColors.white,
        );

        await Future.delayed(const Duration(seconds: 1));

        if (Get.currentRoute != Routes.LOGIN) {
          Get.offNamedUntil(Routes.LOGIN, (route) => route.isFirst);
        }
      }
    } on DioException catch (e) {
      String errorMessage = 'Terjadi kesalahan';
      if (e.response != null) {
        if (e.response!.statusCode == 422) {
          final errors = e.response!.data['errors'];
          errorMessage = errors.values.first[0] ?? 'Validasi gagal';
        } else {
          errorMessage =
              e.response!.data['message'] ?? 'Gagal terhubung ke server';
        }
      }
      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onLogin() {
    Get.back();
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama lengkap wajib diisi';
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username wajib diisi';
    }
    if (value.length < 4) {
      return 'Username minimal 4 karakter';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email wajib diisi';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Email tidak valid';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor HP wajib diisi';
    }
    String pattern = r'(^(?:[+62])?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Nomor HP tidak valid';
    }
    return null;
  }
  

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung huruf besar';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password harus mengandung huruf kecil';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung angka';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password wajib diisi';
    }
    if (value != passwordController.text) {
      return 'Konfirmasi password tidak cocok';
    }
    return null;
  }

  void formatPhoneNumber(String value) {
    String numbers = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbers.startsWith('0')) {
      numbers = '62${numbers.substring(1)}';
    } else if (!numbers.startsWith('62')) {
      numbers = '62$numbers';
    }

    phoneController.text = numbers;
    phoneController.selection = TextSelection.collapsed(
      offset: phoneController.text.length,
    );
  }

  void validateAndSubmit() {
    final usernameError = validateUsername(usernameController.text);
    final emailError = validateEmail(emailController.text);
    final passwordError = validatePassword(passwordController.text);

    if (usernameError != null) {
      showError(usernameError);
      return;
    }

    if (emailError != null) {
      showError(emailError);
      return;
    }

    if (passwordError != null) {
      showError(passwordError);
      return;
    }

    onRegister();
  }

  void showError(String message) {
    Get.snackbar(
      'Validasi Gagal',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
