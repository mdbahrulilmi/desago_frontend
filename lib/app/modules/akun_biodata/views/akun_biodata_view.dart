import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '../controllers/akun_biodata_controller.dart';

class AkunBiodataView extends GetView<AkunBiodataController> {
  const AkunBiodataView({super.key});
@override
Widget build(BuildContext context) {
  AppResponsive().init(context);

  return Scaffold(
    backgroundColor: AppColors.secondary,
    body: Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
            await controller.fetchUserData();
          },
        child: SingleChildScrollView(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  _buildHeader(),
              SizedBox(height: AppResponsive.h(1)),
              _buildBiodataCard(),
                ],
              ),
              Positioned(
                top: 250,
                left: 0,
                right: 0,
                child: Center(child: _verificationCard()),
              ),
            ],
          ),
        ),
      );
}),
  );
}
  Widget _buildVerifiedBadge() {
    return Container(
      padding: AppResponsive.padding(horizontal: 2, vertical: 0.5),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Remix.checkbox_circle_fill, color: AppColors.success, size: 16),
          SizedBox(width: 5),
          Text(
            'Terverifikasi',
            style: AppText.small(color: AppColors.success),
          ),
        ],
      ),
    );
  }

  Widget _buildUnverifiedBadge() {
    return Container(
      padding: AppResponsive.padding(horizontal: 2, vertical: 0.5),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Remix.error_warning_fill, color: AppColors.warning, size: 16),
          SizedBox(width: 5),
          Text(
            'Belum Terverifikasi',
            style: AppText.small(color: AppColors.warning),
          ),
        ],
      ),
    );
  }

  Widget _buildBiodataCard() {
    return Container(
      margin: AppResponsive.padding(all: 5),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppResponsive.padding(horizontal: 1, vertical: 2),
            child: Row(
              children: [
                Icon(Remix.user_line, color: AppColors.text),
                SizedBox(width: AppResponsive.w(3)),
                Text(
                  'Data Pribadi',
                  style: AppText.h5(color: AppColors.text),
                ),
              ],
            ),
          ),          
          Obx(() => Column(
            children: [
              _buildBiodataItem(
                title: 'Nama Lengkap',
                value: controller.nama,
                icon: Remix.user_3_line,
              ),
              _buildBiodataItem(
                title: 'NIK',
                value: controller.nik,
                icon: Remix.id_card_line,
              ),
              _buildBiodataItem(
                title: 'Tempat Lahir',
                value: controller.tempatLahir,
                icon: Remix.map_pin_line,
              ),
              _buildBiodataItem(
                title: 'Tanggal Lahir',
                value: controller.tanggalLahir,
                icon: Remix.calendar_line,
              ),
              _buildBiodataItem(
                title: 'Jenis Kelamin',
                value: controller.jenisKelamin,
                icon: Remix.men_line,
              ),
              _buildBiodataItem(
                title: 'Golongan Darah',
                value: controller.golonganDarah,
                icon: Remix.heart_pulse_line,
              ),
              _buildBiodataItem(
                title: 'Alamat',
                value: controller.alamat,
                icon: Remix.home_4_line,
                isMultiline: true,
              ),
              _buildBiodataItem(
                title: 'Agama',
                value: controller.agama,
                icon: Remix.book_open_line,
              ),
              _buildBiodataItem(
                title: 'Status Perkawinan',
                value: controller.statusPerkawinan,
                icon: Remix.heart_2_line,
              ),
              _buildBiodataItem(
                title: 'Pekerjaan',
                value: controller.pekerjaan,
                icon: Remix.briefcase_4_line,
              ),
              _buildBiodataItem(
                title: 'Kewarganegaraan',
                value: controller.kewarganegaraan,
                icon: Remix.global_line,
              ),
              _buildBiodataItem(
                title: 'Berlaku Hingga',
                value: controller.berlakuHingga,
                icon: Remix.timer_line,
                isLast: true,
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildBiodataItem({
    required String title,
    required String value,
    required IconData icon,
    bool isMultiline = false,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: AppResponsive.padding(horizontal: 3, vertical: 2),
          child: Row(
            crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Container(
                width: AppResponsive.w(10),
                height: AppResponsive.w(10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  color: AppColors.secondary,
                  size: AppResponsive.w(5),
                ),
              ),
              SizedBox(width: AppResponsive.w(3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppText.small(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 4),
                    Text(
                      value,
                      style: AppText.bodyLarge(color: AppColors.dark),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
Widget _buildHeader() {
  return Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFE00004),
                    Color(0xFFB80003),
                    Color(0xFFE00004),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),
              child: SafeArea(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 16,
                      top: 16,
                      child: _circleButton(
                        icon: Icons.arrow_back_ios_new,
                        onTap: () => Get.back(),
                      ),
                    ),
                    Positioned(
                      left: AppResponsive.w(20),
                      top: AppResponsive.h(3),
                      child: Text("Biodata Saya",style: AppText.h5(color: AppColors.white),)
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Avatar
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 110,
                                height: 110,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.secondary,
                                ),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary,
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      "https://backend.desagodigital.id/${controller.avatar}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 2,
                                right: 10,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.secondary,
                                    border: Border.all(
                                      color: AppColors.bottonGreen,
                                      width: 4,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
}

Widget _verificationCard() {
  return Obx(() {
    return Container(
      width: AppResponsive.w(90),
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      padding: AppResponsive.padding(all: 1),
      child: Padding(
        padding: AppResponsive.padding(horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Status Kependudukan',
              style: AppText.bodyMedium(color: AppColors.textSecondary),
            ),
            SizedBox(height: AppResponsive.h(0.1)),
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.isVerified
                        ? AppColors.bottonGreen
                        : AppColors.warning,
                  ),
                ),
                SizedBox(width: AppResponsive.w(2)),
                Text(
                  controller.isVerified
                      ? 'Aktif/Terverifikasi'
                      : 'Belum Terverifikasi',
                  style: AppText.bodyMediumBold(
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  });
}

Widget _circleButton({
  required IconData icon,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
      ),
      child: Icon(icon, color: Colors.white),
    ),
  );
}

}
