import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/sukses_reset_password_controller.dart';

class SuksesResetPasswordView extends GetView<SuksesResetPasswordController> {
  const SuksesResetPasswordView({super.key});
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
                  'Link Reset Password Terkirim!',
                  style: AppText.h4(color: AppColors.dark),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppResponsive.h(2)),

                Text(
                  'Silahkan cek email/wa Anda untuk mengatur ulang kata sandi.',
                  style: AppText.bodyMedium(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppResponsive.h(6)),
                SizedBox(
                  width: double.infinity,
                  height: AppResponsive.h(6),
                  child: ElevatedButton(
                    onPressed: () => controller.onBackToLogin(),
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
