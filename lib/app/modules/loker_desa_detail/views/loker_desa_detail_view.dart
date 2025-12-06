import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '../controllers/loker_desa_detail_controller.dart';

class LokerDesaDetailView extends GetView<LokerDesaDetailController> {
  const LokerDesaDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Detail Lowongan',
          style: AppText.h5(color: AppColors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.lokerDesa.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Remix.error_warning_line,
                    size: 48, color: AppColors.danger),
                const SizedBox(height: 16),
                Text(
                  'Lowongan tidak ditemukan',
                  style: AppText.h5(color: AppColors.dark),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Kembali ke daftar lowongan',
                    style: AppText.button(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          );
        }

        final loker = controller.lokerDesa.value!;

        return Column(
          children: [
            // Content - Scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Header
                    Container(
                      width: double.infinity,
                      height: AppResponsive.h(25),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(loker.gambar_loker),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Content Container
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            loker.judul,
                            style: AppText.h4(color: AppColors.dark),
                          ),

                          const SizedBox(height: 8),

                          // Instansi
                          Row(
                            children: [
                              Icon(Remix.building_line,
                                  size: 18, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Text(
                                loker.instansi,
                                style: AppText.bodyLarge(
                                    color: AppColors.textSecondary),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Deadline with Icon
                          Row(
                            children: [
                              Icon(Remix.calendar_event_line,
                                  size: 18, color: AppColors.danger),
                              const SizedBox(width: 8),
                              Text(
                                'Batas Pendaftaran: ${loker.batasPendaftaran}',
                                style:
                                    AppText.bodyLarge(color: AppColors.danger),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Deskripsi Pekerjaan
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deskripsi Pekerjaan',
                              style: AppText.h5(color: AppColors.dark),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              loker.deskripsi,
                              style: AppText.bodyMedium(
                                  color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                   ),
                   const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kualifikasi',
                            style: AppText.h5(color: AppColors.dark),
                          ),
                          const SizedBox(height: 8),
                          _buildPersyaratanList(loker.persyaratan),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Button - Hubungi
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => controller.hubungiPenyedia(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Hubungi Penyedia Lowongan',
                  style: AppText.button(color: AppColors.white),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPersyaratanList(String persyaratanText) {
    // Split persyaratan by comma or new line
    final List<String> persyaratanList = persyaratanText
        .split(RegExp(r',|\n'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: persyaratanList
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Remix.checkbox_circle_fill,
                      size: 16,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style:
                            AppText.bodyMedium(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
