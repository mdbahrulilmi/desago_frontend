import 'package:carousel_slider/carousel_slider.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/utils/app_colors.dart' show AppColors;
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/surat_list_kategori_controller.dart';

class SuratListKategoriView extends GetView<SuratListKategoriController> {
  const SuratListKategoriView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize responsive sizing
    AppResponsive().init(context);

    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Kategori Surat', style: AppText.h5(color: AppColors.dark)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.dark,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pengajuan Surat Header
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       'Pengajuan Surat',
              //       style: AppText.h5(color: AppColors.dark),
              //     ),
              //     TextButton(
              //       onPressed: () {},
              //       child: Text(
              //         'Lihat Semua',
              //         style: AppText.button(color: AppColors.warning),
              //       ),
              //     ),
              //   ],
              // ),

              // Perbaikan UI Carousel dengan card yang mengintip dan shadow yang lebih tepat
              // Padding(
              //   padding: EdgeInsets.only(
              //       bottom: 24), // Tambahkan padding di bagian bawah
              //   child: Column(
              //     children: [
              //       Obx(
              //         () => controller.isLoading.value
              //             ? Center(child: CircularProgressIndicator())
              //             : CarouselSlider.builder(
              //                 itemCount: controller.pengajuanSuratList.length,
              //                 options: CarouselOptions(
              //                   height: 160,
              //                   autoPlay: true,
              //                   aspectRatio: 16 / 9,
              //                   viewportFraction: 0.9,
              //                   onPageChanged: (index, reason) {
              //                     controller.currentCardIndex.value = index;
              //                   },
              //                 ),
              //                 itemBuilder: (context, index, realIndex) {
              //                   final item =
              //                       controller.pengajuanSuratList[index];
              //                   return Padding(
              //                     padding: const EdgeInsets.all(10),
              //                     child: Container(
              //                       margin: EdgeInsets.symmetric(horizontal: 5),
              //                       decoration: BoxDecoration(
              //                         color: AppColors.white,
              //                         borderRadius: BorderRadius.circular(12),
              //                         boxShadow: [
              //                           BoxShadow(
              //                             color: AppColors.shadow
              //                                 .withOpacity(0.12),
              //                             blurRadius: 8,
              //                             offset: Offset(0, 4),
              //                             spreadRadius: 0,
              //                           ),
              //                         ],
              //                       ),
              //                       child: ClipRRect(
              //                         borderRadius: BorderRadius.circular(
              //                             12), // Pastikan content tidak keluar
              //                         child: Padding(
              //                           padding: EdgeInsets.all(16),
              //                           child: Column(
              //                             crossAxisAlignment:
              //                                 CrossAxisAlignment.start,
              //                             children: [
              //                               Row(
              //                                 mainAxisAlignment:
              //                                     MainAxisAlignment
              //                                         .spaceBetween,
              //                                 children: [
              //                                   Container(
              //                                     padding: EdgeInsets.symmetric(
              //                                         horizontal: 10,
              //                                         vertical: 5),
              //                                     decoration: BoxDecoration(
              //                                       color: _getStatusColor(
              //                                               item['status'])
              //                                           .withOpacity(0.2),
              //                                       borderRadius:
              //                                           BorderRadius.circular(
              //                                               16),
              //                                     ),
              //                                     child: Text(
              //                                       item['status'],
              //                                       style: AppText.small(
              //                                           color: _getStatusColor(
              //                                               item['status'])),
              //                                     ),
              //                                   ),
              //                                   Text(
              //                                     item['date'],
              //                                     style: AppText.small(
              //                                         color: AppColors
              //                                             .textSecondary),
              //                                   ),
              //                                 ],
              //                               ),
              //                               SizedBox(height: 12),
              //                               Text(
              //                                 item['title'],
              //                                 style: AppText.h6(
              //                                     color: AppColors.dark),
              //                                 maxLines: 1,
              //                                 overflow: TextOverflow.ellipsis,
              //                               ),
              //                               SizedBox(height: 8),
              //                               Expanded(
              //                                 child: Text(
              //                                   item['description'],
              //                                   style: AppText.bodyMedium(
              //                                       color: AppColors
              //                                           .textSecondary),
              //                                   maxLines: 2,
              //                                   overflow: TextOverflow.ellipsis,
              //                                 ),
              //                               ),
              //                             ],
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                   );
              //                 },
              //               ),
              //       ),
              //       if (controller.pengajuanSuratList.length > 1)
              //         Padding(
              //           padding: EdgeInsets.only(top: 12),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: controller.pengajuanSuratList
              //                 .asMap()
              //                 .entries
              //                 .map((entry) {
              //               return Container(
              //                 width:
              //                     controller.currentCardIndex.value == entry.key
              //                         ? 16
              //                         : 8,
              //                 height: 8,
              //                 margin: EdgeInsets.symmetric(horizontal: 4),
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(4),
              //                   color: controller.currentCardIndex.value ==
              //                           entry.key
              //                       ? AppColors.primary
              //                       : AppColors.muted,
              //                 ),
              //               );
              //             }).toList(),
              //           ),
              //         ),
              //     ],
              //   ),
              // ),
              // Buat Surat Section
              SizedBox(height: 8),
              Text(
                'Buat Surat',
                style: AppText.h5(color: AppColors.dark),
              ),
              SizedBox(height: 8),
              Text(
                'Ajukan pembuatan surat yang sesuai kebutuhan Anda. Pilih kategori di bawah ini.',
                style: AppText.bodyMedium(color: AppColors.textSecondary),
              ),
              SizedBox(height: 16),

              // Grid layout for surat categories
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  // Surat Keterangan
                  _buildCategoryCard(
                    icon: Icons.info_outline,
                    iconColor: AppColors.purple,
                    title: 'Surat Keterangan',
                    count: '20 jenis surat',
                    onTap: () => controller.navigateToSuratKeterangan(),
                  ),

                  // Surat Pengantar
                  _buildCategoryCard(
                    icon: Remix.file_paper_2_line,
                    iconColor: AppColors.lightBlue,
                    title: 'Surat Pengantar',
                    count: '5 jenis surat',
                    onTap: () => controller.navigateToSuratPengantar(),
                  ),

                  // Surat Rekomendasi
                  _buildCategoryCard(
                    icon: Remix.file_edit_line,
                    iconColor: AppColors.success,
                    title: 'Surat Rekomendasi',
                    count: '1 jenis surat',
                    onTap: () => controller.navigateToSuratRekomendasi(),
                  ),

                  // Surat Lainnya
                  _buildCategoryCard(
                    icon: Remix.file_list_3_line,
                    iconColor: AppColors.orange,
                    title: 'Surat Lainnya',
                    count: '9 jenis surat',
                    onTap: () => controller.navigateToSuratLainnya(),
                  ),
                ],
              ),
              SizedBox(height: AppResponsive.h(3),),
              Container(
                width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.SURAT_RIWAYAT_PENGAJUAN);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Remix.history_line,
                          color: AppColors.white,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Riwayat Pengajuan Surat',
                          style: AppText.button(color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 45,
                ),
              ),
              Spacer(),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: AppText.h6(color: AppColors.dark),
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    count,
                    style: AppText.small(color: AppColors.textSecondary),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'diproses':
      return AppColors.warning;
    case 'diterima':
      return AppColors.success;
    case 'ditolak':
      return AppColors.danger;
    case 'selesai':
      return AppColors.info;
    default:
      return AppColors.warning;
  }
}
