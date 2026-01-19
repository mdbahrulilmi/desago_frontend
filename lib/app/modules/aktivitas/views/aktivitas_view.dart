import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/aktivitas_controller.dart';

class AktivitasView extends GetView<AktivitasController> {
  const AktivitasView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Aktivitas',
        style: AppText.h5(color: AppColors.white),),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _buildReportCard(
            icon: Remix.alarm_warning_fill,
            title: 'Lapor',
            subtitle: 'Laporan Kebersihan - LPR001',
            date: '01 December 2025, 09.50',
            onPressed: () {
              // Aksi ketika card ditekan
              Get.snackbar('Info', 'Laporan Kebersihan dibuka');
            },
          ),
          _buildReportCard(
             icon: Remix.mail_send_fill,
            title: 'Surat',
            subtitle: 'Pengajuan Surat Izin',
            date: '01 Juni 2025, 10.50',
            onPressed: () {
              // Aksi ketika card ditekan
              Get.snackbar('Info', 'Surat Izin dibuka');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String date,
    VoidCallback? onPressed,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon,
                      color: AppColors.secondary),
                    ),
                const SizedBox(width: 16),
                // Content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                  ],
                ),
              ),
              // Button
              Container(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(6)
                ),
                child: const Text(
                  'Terkirim',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: AppColors.border,
          height: AppResponsive.h(1),
          thickness: 2,
        )
      ],
    );
  }
}