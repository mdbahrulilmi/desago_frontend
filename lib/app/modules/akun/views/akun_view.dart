import 'dart:io';

import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '../../../utils/app_responsive.dart';
import '../controllers/akun_controller.dart';

class AkunView extends GetView<AkunController> {
  const AkunView({super.key});
  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    return Scaffold(
      backgroundColor: AppColors.light,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppResponsive.padding(all: 3.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Akun Saya',
                    style: AppText.h4(color: AppColors.dark),
                  ),
                ),
                SizedBox(height: AppResponsive.h(2)),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: AppResponsive.padding(all: 1),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Obx(() {
                            final String? avatarUrl =
                                controller.user.value?.getAvatar;
                            return CircleAvatar(
                              radius: AppResponsive.w(9),
                              backgroundColor: Colors.grey[200],
                              backgroundImage: 
                              // avatarUrl != null
                                  // ? avatarUrl.startsWith('https')
                                      // ?  NetworkImage(
                                      //      'https://sgdiyrucfgwacuycrhvz.supabase.co/storage/v1/object/public/desago_bucket/$avatarUrl')
                                  //     : FileImage(
                                  //         File(avatarUrl)) 
                                  // : 
                                  AssetImage(
                                          'assets/img/kepala_desa.jpg')
                                      as ImageProvider,
                              child: avatarUrl == null
                                  ? Icon(Remix.user_3_line,
                                      color: Colors.grey,
                                      size: AppResponsive.w(9))
                                  : null,
                            );
                          }),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                controller.showAvatarOptions();
                              },
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.info,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Remix.pencil_line,
                                  color: AppColors.white,
                                  size: AppResponsive.w(5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: AppResponsive.w(3)),
                      Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.user.value?.name ?? 'Nama',
                              style: AppText.h6(color: AppColors.dark),
                            ),
                            Text(
                              controller.user.value?.email ??
                                  'Email Tidak Tersedia',
                              style: AppText.bodySmall(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: AppResponsive.h(2)),
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.TAUTKAN_AKUN);
                  },
                  child: Container(
                    height: AppResponsive.h(12),
                    width: double.infinity,
                    padding: AppResponsive.padding(vertical: 1),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.info,
                            AppColors.lightBlue.withOpacity(1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          tileMode: TileMode.repeated,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tautkan Akun Anda Dengan Desa',
                              style: AppText.button(color: AppColors.white),
                            ),
                            Text(
                              'Tautkan akun anda untuk mendapatkan pelayanan maksimal',
                              style: AppText.small(color: AppColors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppResponsive.h(3)),
                    _buildListTile(
                      Remix.id_card_line,
                      'Biodata',
                      (){
                        Get.toNamed(Routes.AKUN_BIODATA);
                      }
                    ),
                    Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.divider,
                      ),
                    _buildListTile(Remix.lock_password_line, 'Ubah Password', (){
                      Get.toNamed(Routes.AKUN_UBAH_PASSWORD);
                    }),
                    Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.divider,
                      ),
                    Obx(
                      () => SwitchListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 9),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Remix.notification_2_line,
                                color: AppColors.primary),
                            SizedBox(
                              width: AppResponsive.w(4),
                            ),
                            Text(
                              'Notifikasi',
                              style: AppText.bodyLarge(color: AppColors.dark),
                            ),
                          ],
                        ),
                        value: controller.isNotificationActive.value,
                        onChanged: (value) {
                          controller.toggleNotification(value);
                        },
                        activeColor: AppColors.primary,
                        inactiveThumbColor: AppColors.secondary,
                        inactiveTrackColor:
                            AppColors.textSecondary.withOpacity(0.5),
                      ),
                    ),
                    Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.divider,
                      ),
                SizedBox(
                  height: AppResponsive.h(3),
                ),
                InkWell(
                  onTap: () {
                    controller.logout();
                  },
                  child: Center(
                    child: Container(
                      height: AppResponsive.h(8),
                      width: AppResponsive.w(80),
                      padding: AppResponsive.padding(vertical: 1),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.botton,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Keluar',
                                style: AppText.button(color: AppColors.white),
                              ),
                              SizedBox(width: AppResponsive.w(2)),
                            ],
                          ),
                        ),
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

  Widget _buildSection(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

 Widget _buildListTile(
  IconData iconLeft,
  String title,
  [VoidCallback? onTap]
) {
  return ListTile(
    title: Row(
      children: [
        Icon(iconLeft, color: AppColors.primary),
        SizedBox(
          width: AppResponsive.w(4),
        ),
        Text(
          title,
          style: AppText.bodyLarge(color: AppColors.dark),
        ),
      ],
    ),
    trailing: Icon(
      Remix.arrow_right_s_line,
      color: AppColors.textSecondary,
    ),
    contentPadding: AppResponsive.padding(horizontal: 2),
    onTap: onTap,
  );
}
}