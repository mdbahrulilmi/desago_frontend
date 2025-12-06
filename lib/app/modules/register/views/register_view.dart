import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
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
                  'Silahkan lengkapi data diri Anda untuk membuat akun baru.',
                  style: AppText.bodyMedium(color: AppColors.textSecondary),
                ),
                SizedBox(height: AppResponsive.h(4)),
                TextFormField(
                  style: AppText.bodyMedium(color: AppColors.dark),
                  controller: controller.namaLengkapController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama lengkap',
                    hintStyle:
                        AppText.bodyMedium(color: AppColors.textSecondary),
                    prefixIcon:
                        Icon(Remix.user_line, color: AppColors.textSecondary),
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
                SizedBox(height: AppResponsive.h(2)),
                TextFormField(
                  style: AppText.bodyMedium(color: AppColors.dark),
                  controller: controller.usernameController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan username',
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
                  cursorColor: AppColors.dark,
                ),
                SizedBox(height: AppResponsive.h(2)),
                TextFormField(
                  style: AppText.bodyMedium(color: AppColors.dark),
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Masukkan email',
                    hintStyle:
                        AppText.bodyMedium(color: AppColors.textSecondary),
                    prefixIcon:
                        Icon(Remix.mail_line, color: AppColors.textSecondary),
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
                  cursorColor: AppColors.dark,
                ),
                SizedBox(height: AppResponsive.h(2)),
                TextFormField(
                  style: AppText.bodyMedium(color: AppColors.dark),
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nomor HP/WhatsApp',
                    hintStyle:
                        AppText.bodyMedium(color: AppColors.textSecondary),
                    prefixIcon:
                        Icon(Remix.phone_line, color: AppColors.textSecondary),
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
                  cursorColor: AppColors.dark,
                ),
                SizedBox(height: AppResponsive.h(2)),
                Obx(() => TextFormField(
                      style: AppText.bodyMedium(color: AppColors.dark),
                      controller: controller.passwordController,
                      obscureText: controller.isPasswordHidden.value,
                      decoration: InputDecoration(
                        hintText: 'Masukkan kata sandi',
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
                      cursorColor: AppColors.dark,
                    )),
                SizedBox(height: AppResponsive.h(2)),
                Obx(() => TextFormField(
                      style: AppText.bodyMedium(color: AppColors.dark),
                      controller: controller.confirmPasswordController,
                      obscureText: controller.isConfirmPasswordHidden.value,
                      decoration: InputDecoration(
                        hintText: 'Konfirmasi kata sandi',
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
                      cursorColor: AppColors.dark,
                    )),
                SizedBox(height: AppResponsive.h(3)),
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: AppResponsive.h(6),
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.onRegister(),
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
                                    height: AppResponsive.h(3),
                                    width: AppResponsive.h(3),
                                    child: CircularProgressIndicator(
                                      color: AppColors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: AppResponsive.w(2)),
                                  Text(
                                    'Memproses...',
                                    style:
                                        AppText.button(color: AppColors.white),
                                  ),
                                ],
                              )
                            : Text(
                                'Daftar',
                                style: AppText.button(color: AppColors.white),
                              ),
                      ),
                    )),
                SizedBox(height: AppResponsive.h(2)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: AppText.bodyMedium(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () => controller.onLogin(),
                      child: Text(
                        'Masuk',
                        style: AppText.bodyLarge(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppResponsive.h(2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
