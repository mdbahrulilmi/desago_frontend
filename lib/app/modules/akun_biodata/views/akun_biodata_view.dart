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
      backgroundColor: AppColors.backgroundScaffold,
      appBar: AppBar(
        title: Text('Biodata', style: AppText.h5(color: AppColors.dark)),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.dark),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Remix.edit_2_line, color: AppColors.primary),
            onPressed: controller.editData,
          ),
        ],
      ),
      body: Obx(() => controller.isLoading.value
        ? Center(child: CircularProgressIndicator(color: AppColors.primary))
        : SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildBiodataCard(),
                  SizedBox(height: AppResponsive.h(2)),
                  _buildVerificationSection(),
                  SizedBox(height: AppResponsive.h(3)),
                ],
              ),
            ),
          ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: AppResponsive.padding(vertical: 3, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: AppResponsive.w(15),
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              controller.nama.value.isNotEmpty 
                ? controller.nama.value.split(' ').map((e) => e[0]).take(2).join()
                : 'JS',
              style: AppText.h2(color: AppColors.primary),
            ),
          ),
          SizedBox(height: AppResponsive.h(2)),
          Obx(() => Text(
            controller.nama.value,
            style: AppText.h4(color: AppColors.dark),
            textAlign: TextAlign.center,
          )),
          SizedBox(height: AppResponsive.h(0.5)),
          Obx(() => Text(
            'NIK: ${controller.nik.value}',
            style: AppText.bodyMedium(color: AppColors.textSecondary),
          )),
          SizedBox(height: AppResponsive.h(1)),
          Obx(() => controller.isVerified.value
            ? _buildVerifiedBadge()
            : _buildUnverifiedBadge(),
          ),
        ],
      ),
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
      margin: AppResponsive.padding(all: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppResponsive.padding(all: 3),
            child: Text(
              'Data Pribadi',
              style: AppText.h5(color: AppColors.dark),
            ),
          ),
          Divider(height: 1, color: AppColors.muted),
          
          // Biodata items
          Obx(() => Column(
            children: [
              _buildBiodataItem(
                title: 'Nama Lengkap',
                value: controller.nama.value,
                icon: Remix.user_3_line,
              ),
              _buildBiodataItem(
                title: 'NIK',
                value: controller.nik.value,
                icon: Remix.id_card_line,
              ),
              _buildBiodataItem(
                title: 'Tempat Lahir',
                value: controller.tempatLahir.value,
                icon: Remix.map_pin_line,
              ),
              _buildBiodataItem(
                title: 'Tanggal Lahir',
                value: controller.tanggalLahir.value,
                icon: Remix.calendar_line,
              ),
              _buildBiodataItem(
                title: 'Jenis Kelamin',
                value: controller.jenisKelamin.value,
                icon: Remix.men_line,
              ),
              _buildBiodataItem(
                title: 'Golongan Darah',
                value: controller.golonganDarah.value,
                icon: Remix.heart_pulse_line,
              ),
              _buildBiodataItem(
                title: 'Alamat',
                value: controller.alamat.value,
                icon: Remix.home_4_line,
                isMultiline: true,
              ),
              _buildBiodataItem(
                title: 'Agama',
                value: controller.agama.value,
                icon: Remix.book_open_line,
              ),
              _buildBiodataItem(
                title: 'Status Perkawinan',
                value: controller.statusPerkawinan.value,
                icon: Remix.heart_2_line,
              ),
              _buildBiodataItem(
                title: 'Pekerjaan',
                value: controller.pekerjaan.value,
                icon: Remix.briefcase_4_line,
              ),
              _buildBiodataItem(
                title: 'Kewarganegaraan',
                value: controller.kewarganegaraan.value,
                icon: Remix.global_line,
              ),
              _buildBiodataItem(
                title: 'Berlaku Hingga',
                value: controller.berlakuHingga.value,
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
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
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
        if (!isLast) Divider(height: 1, indent: 20, endIndent: 20, color: AppColors.muted),
      ],
    );
  }

  Widget _buildVerificationSection() {
    return Obx(() => !controller.isVerified.value
      ? Container(
          margin: AppResponsive.padding(horizontal: 4),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.isLoading.value ? null : controller.requestVerification,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: AppResponsive.padding(vertical: 1.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
            ),
            child: controller.isLoading.value
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : Text(
                  'MINTA VERIFIKASI DATA',
                  style: AppText.button(color: AppColors.white),
                ),
          ),
        )
      : Container(
          margin: AppResponsive.padding(horizontal: 4),
          padding: AppResponsive.padding(all: 3),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Remix.information_line, color: AppColors.success),
              SizedBox(width: AppResponsive.w(3)),
              Expanded(
                child: Text(
                  'Data Anda telah terverifikasi oleh admin desa.',
                  style: AppText.bodyMedium(color: AppColors.success),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
