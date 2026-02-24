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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.chevron_left, color: AppColors.primary),
          iconSize: 32
        ),
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppResponsive.padding(horizontal: 6, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppResponsive.h(8)),
                Center(
                  child: Text("Lupa Kata Sandi",
                  style: AppText.h3(color: AppColors.dark),)
                ),

                SizedBox(height: AppResponsive.h(1)),
                 Center(
                  child: Text(
                    'Masukkan email yang pernah dibuat!',
                    style: AppText.bodyLarge(color: AppColors.dark),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: AppResponsive.h(4)),
                TextFormField(
                  controller: controller.emailController,
                  style: AppText.bodyMedium(color: AppColors.dark),
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
                ),
                SizedBox(
                  height: AppResponsive.h(4),
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
                SizedBox(height: AppResponsive.h(1)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(),
                      child: Row(
                        children: [
                          Text(
                            'Kirim Ulang',
                            style: AppText.bodyMedium(color: AppColors.dark),
                          ),
                          SizedBox(width: AppResponsive.w(1)),
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(3.14159),
                            child: Icon(Icons.refresh, color: AppColors.dark)
                          )
                        ],
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
