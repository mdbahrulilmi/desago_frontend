import 'package:desago/app/helpers/time_helper.dart';
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
    final controller = Get.put(AktivitasController());
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Aktivitas',
          style: AppText.h5(color: AppColors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
        elevation: 1,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.aktivitas.isEmpty) {
          return const Center(child: Text('Belum ada aktivitas'));
        }

       return RefreshIndicator(
  onRefresh: () => controller.refreshAktivitas(),
  child: ListView(
    padding: const EdgeInsets.symmetric(vertical: 8),
    children: [

      /// =====================
      /// LIST DATA
      /// =====================
      ...controller.aktivitas.map((item) {

        final isLapor = item['tipe'] == 'lapor';

        return _buildReportCard(
          icon: isLapor
              ? Remix.alarm_warning_fill
              : Remix.mail_send_fill,
          route: isLapor
              ? 'lapor-riwayat'
              : 'surat-riwayat-pengajuan',
          title: isLapor ? 'Lapor' : 'Surat',
          subtitle: item['aktivitas'] ?? '-',
          date: TimeHelper.formatTanggal(
              item['created_at'] ?? '-'),
          status: 'Terkirim',
          onPressed: () {},
        );
      }).toList(),

      /// =====================
        /// NUMBER PAGINATION
        /// =====================
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(controller.lastPage, (index) {
              final page = index + 1;
              final isActive = page == controller.currentPage;

              return GestureDetector(
                onTap: () => controller.goToPage(page),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "$page",
                    style: TextStyle(
                      color: isActive
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      /// =====================
      /// END OF DATA
      /// =====================
      if (controller.currentPage >= controller.lastPage)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              "Tidak ada data lagi",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
    ],
  ),
);
}),
    );
  }

  Widget _buildReportCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String date,
    required String status,
    required String route,
    VoidCallback? onPressed,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Get.toNamed('/${route}'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: AppColors.secondary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: AppColors.border,
          height: AppResponsive.h(1),
          thickness: 2,
        ),
      ],
    );
  }
}