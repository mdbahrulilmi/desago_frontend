import 'package:desago/app/controllers/auth_controller.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class VerificationMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthController>();

    if (auth.user.value == null) {
      return const RouteSettings(name: Routes.LOGIN);
    }

    if (auth.isPending) {
      Get.snackbar(
        'Error',
        'Akun Anda belum diverifikasi',
        backgroundColor: AppColors.warning,
        colorText: AppColors.text,
      );
      return const RouteSettings();
    }

    if (!auth.isVerified && !auth.isPending) {
      return const RouteSettings(name: Routes.TAUTKAN_AKUN);
    }

    return null;
  }
}