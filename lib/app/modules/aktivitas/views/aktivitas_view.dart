import 'package:desago/app/helpers/time_helper.dart';
import 'package:desago/app/utils/app_colors.dart';
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
        /// Loading pertama kali
        if (controller.isLoading.value &&
            controller.aktivitas.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        /// Kosong
        if (controller.aktivitas.isEmpty) {
          return const Center(
            child: Text('Belum ada aktivitas'),
          );
        }

        /// LIST
        return RefreshIndicator(
          onRefresh: controller.refreshAktivitas,
          child: ListView.separated(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
            itemCount: controller.aktivitas.length +
                (controller.isLoadingMore.value ? 1 : 0),
            separatorBuilder: (_, __) => Divider(
              color: AppColors.border,
              height: 1,
              thickness: 1,
            ),
            itemBuilder: (context, index) {
              /// Loading More Indicator
              if (index >= controller.aktivitas.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final item = controller.aktivitas[index];
              final isLapor = item['tipe'] == 'lapor';

              return RepaintBoundary(
                child: _ReportCard(
                  icon: isLapor
                      ? Remix.alarm_warning_fill
                      : Remix.mail_send_fill,
                  route: isLapor
                      ? 'lapor-riwayat'
                      : 'surat-riwayat-pengajuan',
                  title: isLapor ? 'Lapor' : 'Surat',
                  subtitle: item['aktivitas'] ?? '-',
                  date: TimeHelper.formatTanggal(
                    item['created_at'] ?? '-',
                  ),
                  status: 'Terkirim',
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String date;
  final String status;
  final String route;

  const _ReportCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.status,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed('/$route'),
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
                crossAxisAlignment:
                    CrossAxisAlignment.start,
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
              padding: const EdgeInsets.symmetric(
                  vertical: 3, horizontal: 6),
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
    );
  }
}