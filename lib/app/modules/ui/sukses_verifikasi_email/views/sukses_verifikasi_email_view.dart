import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/sukses_verifikasi_email_controller.dart';

class SuksesVerifikasiEmailView
    extends GetView<SuksesVerifikasiEmailController> {
  const SuksesVerifikasiEmailView({super.key});
  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: AppResponsive.padding(horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: AppResponsive.w(40),
                  height: AppResponsive.w(40),
                  child: Lottie.asset(
                    'assets/lottie/email.json',
                    repeat: false,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: AppResponsive.h(4)),
                Text(
                  'Verifikasi Email Terkirim!',
                  style: AppText.h4(color: AppColors.dark),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppResponsive.h(2)),
                Text(
                  'Silahkan cek email Anda untuk memverifikasi akun Anda.',
                  style: AppText.bodyMedium(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppResponsive.h(6)),
                SizedBox(
                  width: double.infinity,
                  height: AppResponsive.h(6),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.LOGIN);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Kembali ke Login',
                      style: AppText.button(color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
