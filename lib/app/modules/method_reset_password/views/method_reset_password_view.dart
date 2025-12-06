import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:remixicon/remixicon.dart';

import '../controllers/method_reset_password_controller.dart';

class MethodResetPasswordView extends GetView<MethodResetPasswordController> {
  const MethodResetPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppResponsive.padding(horizontal: 6, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Center(
                  child: Image.asset(
                    'assets/img/logo.png',
                    width: AppResponsive.w(65),
                    height: AppResponsive.h(15),
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: AppResponsive.h(2)),

                Text(
                  'Reset Kata Sandi',
                  style: AppText.h4(color: AppColors.primary),
                ),

                SizedBox(height: AppResponsive.h(2)),

                Text(
                  'Pilih metode untuk reset kata sandi Anda',
                  style: AppText.bodyMedium(color: AppColors.textSecondary),
                ),

                SizedBox(height: AppResponsive.h(4)),

                // Row untuk Card Email dan WhatsApp
                Row(
                  children: [
                    // Card Email
                    Expanded(
                      child: Card(
                        color: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                              color: AppColors.primary.withOpacity(0.5)),
                        ),
                        child: InkWell(
                          onTap: () => controller.onEmailMethodSelected(),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: AppResponsive.padding(
                                horizontal: 3, vertical: 4),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: AppResponsive.h(8),
                                  child: Lottie.asset(
                                    'assets/lottie/mail.json',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(height: AppResponsive.h(2)),
                                Text(
                                  'Via Email',
                                  style:
                                      AppText.bodyLarge(color: AppColors.dark),
                                ),
                                SizedBox(height: AppResponsive.h(1)),
                                Text(
                                  'Link reset ke email',
                                  style: AppText.small(
                                      color: AppColors.textSecondary),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: AppResponsive.w(4)),


                    Expanded(
                      child: Card(
                        color: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                              color: AppColors.primary.withOpacity(0.5)),
                        ),
                        child: InkWell(
                          onTap: () => controller.onWhatsAppMethodSelected(),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: AppResponsive.padding(
                                horizontal: 3, vertical: 4),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: AppResponsive.h(7),
                                  child: Lottie.asset(
                                    'assets/lottie/wa.json',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(height: AppResponsive.h(2)),
                                Text(
                                  'Via WhatsApp',
                                  style:
                                      AppText.bodyLarge(color: AppColors.dark),
                                ),
                                SizedBox(height: AppResponsive.h(1)),
                                Text(
                                  'Link reset password via WhatsApp',
                                  style: AppText.small(
                                      color: AppColors.textSecondary),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppResponsive.h(4)),
                SizedBox(
                  width: double.infinity,
                  height: AppResponsive.h(6),
                  child: ElevatedButton.icon(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Remix.arrow_left_line,
                      color: AppColors.white,
                    ),
                    label: Text(
                      'Kembali ke Login',
                      style: AppText.button(color: AppColors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
