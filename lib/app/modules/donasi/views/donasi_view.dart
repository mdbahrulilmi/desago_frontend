import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '../controllers/donasi_controller.dart';

class DonasiView extends GetView<DonasiController> {
  const DonasiView({super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Donasi',
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
                controller: controller.cariDonasiController,
                onChanged: controller.filterDonasi,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintText: 'Cari program donasi...',
                  prefixIcon: Icon(Remix.search_line, color: AppColors.primary),
                  suffixIcon: Obx(() => 
                    controller.cariDonasiText.value.isNotEmpty
                      ? IconButton(
                          icon: Icon(Remix.close_line, color: AppColors.primary),
                          onPressed: () {
                            controller.cariDonasiController.clear();
                            controller.filterDonasi('');
                          },
                        )
                      : const SizedBox.shrink()
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // List of Donations
          Expanded(
            child: Obx(() {
              if (controller.filteredDonasi.isEmpty) {
                return Center(
                  child: Text(
                    'Tidak ada program donasi ditemukan',
                    style: AppText.bodyMedium(color: AppColors.grey),
                  ),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.filteredDonasi.length,
                itemBuilder: (context, index) {
                  final donasi = controller.filteredDonasi[index];
                  return InkWell(
                    onTap: () {
                      // Navigasi ke halaman detail donasi
                      Get.toNamed(
                        '/donasi-detail',
                        arguments: {'donasi': donasi},
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Rounded Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              donasi.gambar_donasi,
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
                                  donasi.judul,
                                  style: AppText.h6(color: AppColors.dark),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  donasi.organisasi,
                                  style: AppText.bodyMedium(color: AppColors.grey),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined, 
                                      size: 14, 
                                      color: AppColors.danger
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Berakhir: ${donasi.tanggalBerakhir}',
                                      style: AppText.bodySmall(color: AppColors.danger),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                // Progress bar donasi
                                LinearProgressIndicator(
                                  value: _calculateProgress(donasi.terkumpul, donasi.targetDonasi),
                                  backgroundColor: AppColors.grey.withOpacity(0.2),
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
                                  minHeight: 6,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      donasi.terkumpul,
                                      style: AppText.bodySmall(color: AppColors.success),
                                    ),
                                    Text(
                                      'Target: ${donasi.targetDonasi}',
                                      style: AppText.bodySmall(color: AppColors.dark),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Arrow icon
                          Icon(
                            Icons.chevron_right, 
                            color: AppColors.dark
                          ),
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
  
  double _calculateProgress(String terkumpul, String target) {
    try {
      String cleanTerkumpul = terkumpul.replaceAll('Rp ', '').replaceAll('.', '').trim();
      String cleanTarget = target.replaceAll('Rp ', '').replaceAll('.', '').trim();
      
      double terkumpulValue = double.parse(cleanTerkumpul);
      double targetValue = double.parse(cleanTarget);
      
      if (targetValue == 0) return 0.0;
      return terkumpulValue / targetValue;
    } catch (e) {
      return 0.0;
    }
  }
}