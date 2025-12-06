import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '../controllers/password_baru_controller.dart';

class PasswordBaruView extends GetView<PasswordBaruController> {
  const PasswordBaruView({super.key});
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
                  'Buat Kata Sandi Baru',
                  style: AppText.h4(color: AppColors.primary),
                ),

                SizedBox(height: AppResponsive.h(2)),

                Text(
                  'Buat kata sandi baru yang kuat dengan minimal 8 karakter.',
                  style: AppText.bodyMedium(color: AppColors.textSecondary),
                ),

                SizedBox(height: AppResponsive.h(4)),

                // Password Field
                Obx(() => TextFormField(
                      controller: controller.passwordController,
                      style: AppText.bodyMedium(color: AppColors.dark),
                      obscureText: controller.isPasswordHidden.value,
                      decoration: InputDecoration(
                        hintText: 'Masukkan kata sandi baru',
                        hintStyle:
                            AppText.bodyMedium(color: AppColors.textSecondary),
                        prefixIcon: Icon(Remix.lock_line,
                            color: AppColors.textSecondary),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              controller.togglePasswordVisibility(),
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Remix.eye_off_line
                                : Remix.eye_line,
                            color: AppColors.textSecondary,
                          ),
                        ),
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
                    )),

                SizedBox(height: AppResponsive.h(2)),

                // Confirm Password Field
                Obx(() => TextFormField(
                      controller: controller.confirmPasswordController,
                      style: AppText.bodyMedium(color: AppColors.dark),
                      obscureText: controller.isConfirmPasswordHidden.value,
                      decoration: InputDecoration(
                        hintText: 'Konfirmasi kata sandi baru',
                        hintStyle:
                            AppText.bodyMedium(color: AppColors.textSecondary),
                        prefixIcon: Icon(Remix.lock_line,
                            color: AppColors.textSecondary),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              controller.toggleConfirmPasswordVisibility(),
                          icon: Icon(
                            controller.isConfirmPasswordHidden.value
                                ? Remix.eye_off_line
                                : Remix.eye_line,
                            color: AppColors.textSecondary,
                          ),
                        ),
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
                    )),

                SizedBox(height: AppResponsive.h(2)),

                // Password Strength Indicator
                Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kekuatan Kata Sandi:',
                          style: AppText.small(color: AppColors.textSecondary),
                        ),
                        SizedBox(height: AppResponsive.h(1)),
                        LinearProgressIndicator(
                          value: controller.passwordStrength.value,
                          backgroundColor: AppColors.muted,
                          color: controller.passwordStrengthColor.value,
                        ),
                        SizedBox(height: AppResponsive.h(1)),
                        Text(
                          controller.passwordStrengthText.value,
                          style: AppText.small(
                            color: controller.passwordStrengthColor.value,
                          ),
                        ),
                      ],
                    )),

                SizedBox(height: AppResponsive.h(4)),

                // Update Password Button
                SizedBox(
                  width: double.infinity,
                  height: AppResponsive.h(6),
                  child: ElevatedButton(
                    onPressed: () => controller.onUpdatePassword(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Perbarui Kata Sandi',
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
