import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '../controllers/loker_desa_controller.dart';

class LokerDesaView extends GetView<LokerDesaController> {
  const LokerDesaView({super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Loker Desa',
          style: AppText.h5(color: AppColors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Search Container
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: controller.cariLokerDesaController,
                onChanged: controller.filterLokerDesa,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintText: 'Cari lowongan kerja...',
                  prefixIcon: Icon(Remix.search_line, color: AppColors.primary),
                  suffixIcon:
                      Obx(() => controller.cariLokerDesaText.value.isNotEmpty
                          ? IconButton(
                              icon: Icon(Remix.close_line,
                                  color: AppColors.primary),
                              onPressed: () {
                                controller.cariLokerDesaController.clear();
                                controller.filterLokerDesa('');
                              },
                            )
                          : const SizedBox.shrink()),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // List of Job Vacancies with rounded images
          Expanded(
            child: Obx(() {
              if (controller.filteredLokerDesa.isEmpty) {
                return Center(
                  child: Text(
                    'Tidak ada lowongan kerja ditemukan',
                    style: AppText.bodyMedium(color: AppColors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.filteredLokerDesa.length,
                itemBuilder: (context, index) {
                  final loker = controller.filteredLokerDesa[index];

                  return InkWell(
                    onTap: () {
                     Get.toNamed(
                        Routes.LOKER_DESA_DETAIL,
                        arguments: {'loker': loker},
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Rounded Image using loker.gambar_loker
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              loker.gambar_loker,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback jika image tidak ditemukan
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: AppColors.grey.withOpacity(0.3),
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: AppColors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          // Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loker.judul,
                                  style: AppText.h6(color: AppColors.dark),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  loker.instansi,
                                  style:
                                      AppText.bodyMedium(color: AppColors.grey),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today_outlined,
                                        size: 14, color: AppColors.danger),
                                    SizedBox(width: 4),
                                    Text(
                                      'Batas: ${loker.batasPendaftaran}',
                                      style: AppText.bodySmall(
                                          color: AppColors.danger),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Arrow icon
                          Icon(Icons.chevron_right, color: AppColors.dark),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
