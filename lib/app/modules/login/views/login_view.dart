import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
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
              children: [
                SizedBox(height: AppResponsive.h(8)),
                Center(
                  child: Text("Masuk",
                  style:AppText.h3(color: AppColors.dark)
                  )
                ),
                SizedBox(height: AppResponsive.h(2)),
                Center(
                  child: Text(
                    'Selamat datang di DesaGo.id',
                    style: AppText.bodyLarge(color: AppColors.dark),
                  ),
                ),
                SizedBox(height: AppResponsive.h(4)),
                TextFormField(
                  style: AppText.bodyMedium(color: AppColors.dark),
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    label: Text("Email"),
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
                        label: Text("Kata Sandi"),
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
                SizedBox(height: AppResponsive.h(1)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => controller.onForgotPassword(),
                      child: Text(
                        'Lupa Kata Sandi',
                        style: AppText.caption(color: AppColors.dark),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppResponsive.h(2)),
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: AppResponsive.h(6),
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            // onPressed: () => Get.toNamed('password-baru'),
                            : () => controller.onLogin(),
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
                                'Masuk',
                                style: AppText.button(color: AppColors.white),
                              ),
                      ),
                    )),
                SizedBox(height: AppResponsive.h(2)),
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.muted)),
                    Padding(
                      padding: AppResponsive.padding(horizontal: 2),
                      child: Text(
                        'Atau',
                        style: AppText.small(color: AppColors.textSecondary),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.muted)),
                  ],
                ),
                SizedBox(height: AppResponsive.h(2)),
                SizedBox(
                  width: double.infinity,
                  height: AppResponsive.h(6),
                  child: OutlinedButton.icon(
                    onPressed: () => controller.handleGoogleSignIn(),
                    icon: Icon(Remix.google_fill, color: AppColors.text),
                    label: Text(
                      'Lanjutkan dengan Google',
                      style: AppText.button(color: AppColors.text),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.muted),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppResponsive.h(2)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Belum punya akun?"),
                    TextButton(
                      onPressed: () => controller.onCreateAccount(),
                      style: TextButton.styleFrom(
                        padding:
                            AppResponsive.padding(horizontal: 2, vertical: 1),
                        minimumSize:
                            Size(AppResponsive.w(20), AppResponsive.h(4)),
                      ),
                      child: Text(
                        'Buat Akun Baru',
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
