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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
        margin: EdgeInsets.only(left: 12),
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        child: IconButton(
          onPressed: ()=> Get.back(),
          icon: Icon(
            Icons.chevron_left_rounded,
          size: 24,
          color: AppColors.primary,
          )          
        ),
      ),


      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppResponsive.padding(horizontal: 6, top: 4),
            child: Column(
              children: [
                SizedBox(height: AppResponsive.h(8)),
                Center(
                  child: Text("Buat Akun Baru",
                  style:AppText.h3(color: AppColors.dark)
                  )
                ),
                SizedBox(height: AppResponsive.h(2)),
                 Center(
                  child: Text(
                    'Buat akun sehingga Anda dapat\nmenjelajahi semua layanan yang ada',
                    style: AppText.bodyLarge(color: AppColors.dark),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: AppResponsive.h(4)),
                SizedBox(height: AppResponsive.h(2)),
                TextFormField(
                  style: AppText.bodyMedium(color: AppColors.dark),
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
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
                TextFormField(
                  style: AppText.bodyMedium(color: AppColors.dark),
                  controller: controller.usernameController,
                  decoration: InputDecoration(
                    label: Text("Username"),
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
                        label: Text("Password"),
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
                SizedBox(height: AppResponsive.h(3)),
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: AppResponsive.h(6),
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.validateAndSubmit(),
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
                SizedBox(height: AppResponsive.h(1)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Sudah punya akun',
                        style: AppText.bodyLarge(color: AppColors.dark),
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
