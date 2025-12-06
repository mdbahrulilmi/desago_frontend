import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LupaPasswordWaController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final isLoading = false.obs;

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor WhatsApp wajib diisi';
    }
    String pattern = r'(^(?:[+62])?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Nomor WhatsApp tidak valid';
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

  Future<void> onSubmit() async {
    if (phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nomor Wajib diisi',
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
      final phone = phoneController.text.trim();
      final response = await DioService.instance.get(
        ApiConstant.sendLinkWa,
        data: {
          'phone': phone,
        },
        options: options,
      );
      if (!Get.isRegistered<LupaPasswordWaController>()) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        await Get.snackbar(
          'Berhasil',
          'Link reset password telah dikirim ke Whatsapp Anda',
          backgroundColor: AppColors.success,
          colorText: AppColors.white,
          duration: const Duration(seconds: 2),
        ).future;
        await Future.delayed(const Duration(milliseconds: 500));
        if (!Get.isRegistered<LupaPasswordWaController>()) return;
        Get.offNamed(Routes.SUKSES_RESET_PASSWORD);
      }
    } catch (e) {
      if (!Get.isRegistered<LupaPasswordWaController>()) return;
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
      if (Get.isRegistered<LupaPasswordWaController>()) {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
