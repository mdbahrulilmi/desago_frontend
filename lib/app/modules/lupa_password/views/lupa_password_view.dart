import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '../controllers/lupa_password_controller.dart';

class LupaPasswordView extends GetView<LupaPasswordController> {
  const LupaPasswordView({super.key});
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
                  'Masukkan username dan nomor HP/WhatsApp yang terdaftar untuk melanjutkan proses reset kata sandi.',
                  style: AppText.bodyMedium(color: AppColors.textSecondary),
                ),

                SizedBox(height: AppResponsive.h(4)),

                // Form Fields
                TextFormField(
                  controller: controller.emailController,
                  style: AppText.bodyMedium(color: AppColors.dark),
                  decoration: InputDecoration(
                    hintText: 'Masukkan Email Anda',
                    hintStyle:
                        AppText.bodyMedium(color: AppColors.textSecondary),
                    prefixIcon:
                        Icon(Remix.at_line, color: AppColors.textSecondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.muted),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.muted),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                SizedBox(
                  height: AppResponsive.h(2),
                ),
                SizedBox(
                  width: double.infinity,
                  height: AppResponsive.h(6),
                  child: Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.onVerifyIdentity(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.white),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Memproses...',
                                    style:
                                        AppText.button(color: AppColors.white),
                                  ),
                                ],
                              )
                            : Text(
                                'Kirim',
                                style: AppText.button(color: AppColors.white),
                              ),
                      )),
                ),
                SizedBox(height: AppResponsive.h(2)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Kembali ke ',
                      style: AppText.bodyMedium(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding:
                            AppResponsive.padding(horizontal: 2, vertical: 1),
                        minimumSize:
                            Size(AppResponsive.w(20), AppResponsive.h(4)),
                      ),
                      child: Text(
                        'Halaman Login',
                        style: AppText.bodyMedium(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
