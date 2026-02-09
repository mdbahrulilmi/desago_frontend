import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '../controllers/akun_edit_controller.dart';

class AkunEditView extends GetView<AkunEditController> {
  const AkunEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Edit Akun',
        style: AppText.h5(color: AppColors.secondary)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () {
            controller.avatar.value = null;
            Get.back();
          },
        ),

      ),
      body: SingleChildScrollView(
      padding: AppResponsive.padding(all: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() {
          final file = controller.avatar.value;
          final String? avatarUrl = controller.user.value?.getAvatar;

          return CircleAvatar(
            radius: AppResponsive.w(16),
            backgroundColor: Colors.grey[200],
            backgroundImage: file != null
                ? FileImage(file) as ImageProvider
                : (avatarUrl != null ? NetworkImage('https://backend.desagodigital.id/$avatarUrl') : null),
            child: file == null && avatarUrl == null
                ? Icon(
                    Remix.user_3_line,
                    color: Colors.grey,
                    size: AppResponsive.w(9),
                  )
                : null,
          );
        }),


          SizedBox(height: AppResponsive.h(1)),

          TextButton(
            onPressed: controller.showAvatarOptions,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              overlayColor: Colors.transparent,
            ),
            child: Text(
              "Edit Foto",
              style: AppText.bodyMediumBold(color: AppColors.text),
            ),
          ),

          SizedBox(height: AppResponsive.h(5)),

          /// EMAIL
          SizedBox(
            width: double.infinity,
            child: TextFormField(
              style: AppText.bodyMedium(color: AppColors.dark),
              controller: controller.emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.borderDana),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              cursorColor: AppColors.dark,
            ),
          ),

          SizedBox(height: AppResponsive.h(2)),

          /// NO TELEPON
          SizedBox(
            width: double.infinity,
            child: TextFormField(
              style: AppText.bodyMedium(color: AppColors.dark),
              controller: controller.phoneController,
              maxLength: 15,
              decoration: InputDecoration(
                labelText: "No Telepon",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.borderDana),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              cursorColor: AppColors.dark,
            ),
          ),

          SizedBox(height: AppResponsive.h(4)),

          /// BUTTON SIMPAN
          SizedBox(
            width: double.infinity,
            child: Obx(() => ElevatedButton(
              onPressed: () {
                controller.updateProfile();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: AppResponsive.padding(vertical: 1.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child:  controller.isLoading.value
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text('Simpan', style: AppText.button(color: AppColors.white))))
          ),
        ],
      ),
    ),
  );
  }
}
