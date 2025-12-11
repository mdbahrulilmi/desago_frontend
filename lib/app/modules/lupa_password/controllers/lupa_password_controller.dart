import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LupaPasswordController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;

  void skipTest() {
    Get.toNamed('/password-baru');
  }

  void onVerifyIdentity() async {
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email tidak boleh kosong',
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
      );
      return;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar(
        'Error',
        'Format email tidak valid',
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
      );
      return;
    }
    try {
      isLoading.value = true;

      final options = Options(
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      final email = emailController.text.trim();
      final response = await DioService.instance.post(
        ApiConstant.sendLinkPassword,
        data: {
          'email': email,
        },
        options: options,
      );
      if (!Get.isRegistered<LupaPasswordController>()) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        await Get.snackbar(
          'Berhasil',
          'Link reset password telah dikirim ke email Anda',
          backgroundColor: AppColors.success,
          colorText: AppColors.white,
          duration: const Duration(seconds: 2),
        ).future;
        await Future.delayed(const Duration(milliseconds: 500));
        if (!Get.isRegistered<LupaPasswordController>()) return;
        Get.offNamed(Routes.SUKSES_RESET_PASSWORD);
      }
    } catch (e) {
      if (!Get.isRegistered<LupaPasswordController>()) return;
      String errorMessage = 'Terjadi kesalahan, silahkan coba lagi';

      if (e is DioException) {
        if (e.response != null) {
          errorMessage = e.response?.data['message'] ?? errorMessage;
        } else {
          switch (e.type) {
            case DioExceptionType.receiveTimeout:
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.sendTimeout:
              errorMessage = 'Koneksi timeout, periksa koneksi internet Anda';
              break;
            case DioExceptionType.connectionError:
              errorMessage =
                  'Tidak dapat terhubung ke server, periksa koneksi Anda';
              break;
            default:
              errorMessage = 'Terjadi kesalahan, silahkan coba lagi';
          }
        }
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      if (Get.isRegistered<LupaPasswordController>()) {
        isLoading.value = false;
      }
    }
  }

  void onBackToLogin() {
    Get.back();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
