import 'package:desago/app/controllers/auth_controller.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class VerificationMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  GetPage? onPageCalled(GetPage? page) {
    final auth = Get.find<AuthController>();

    if (auth.user.value == null) {
      Future.microtask(() {
        Get.toNamed(Routes.LOGIN);
      });
      return null;
    }

    if (auth.isPending) {
      Future.microtask(() {
        Get.snackbar(
          'Error',
          'Akun Anda belum diverifikasi',
          backgroundColor: AppColors.primary,
          colorText: AppColors.secondary,
        );
      });
      return null;
    }

    if (!auth.isVerified) {
      Future.microtask(() {
        Get.toNamed(Routes.TAUTKAN_AKUN);
      });
      return null;
    }

    return page;
  }
}