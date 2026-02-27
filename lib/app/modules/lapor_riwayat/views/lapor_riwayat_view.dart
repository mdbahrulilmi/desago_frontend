import 'package:desago/app/helpers/empty_helper.dart';
import 'package:desago/app/helpers/string_casing_extension.dart';
import 'package:desago/app/helpers/time_helper.dart';
import 'package:desago/app/models/LaporModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';

import '../controllers/lapor_riwayat_controller.dart';

class LaporRiwayatView extends GetView<LaporRiwayatController> {
  const LaporRiwayatView({super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Riwayat Laporan Pengaduan',
          style: AppText.h5(color: AppColors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: Get.back,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: Get.back,
        child: Icon(Icons.add, color: AppColors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: AppResponsive.padding(horizontal: 4, vertical: 2),
            child: TextField(
              controller: controller.searchController,
              onChanged: (_) => controller.filterLaporan(),
              decoration: InputDecoration(
                hintText: 'Cari laporan...',
                hintStyle: AppText.bodyMedium(color: AppColors.textSecondary),
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                fillColor: AppColors.grey.withOpacity(0.1),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Container(
            height: AppResponsive.h(5),
            margin: EdgeInsets.only(top: 2, bottom: 4),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppResponsive.w(4)),
              itemCount: controller.statusOptions.length,
              itemBuilder: (context, index) {
                final status = controller.statusOptions[index];

                return Obx(() {
                  final isSelected = controller.selectedStatus.value == status;

                  return GestureDetector(
                    onTap: () => controller.setStatusFilter(status),
                    child: Container(
                      margin: EdgeInsets.only(right: AppResponsive.w(3)),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.w(4),
                        vertical: AppResponsive.h(1),
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          status,
                          style: AppText.small(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          SizedBox(height: AppResponsive.h(1)),
          Expanded(
            child: Obx(() {
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async => await controller.refreshData(),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: AppResponsive.padding(horizontal: 4, vertical: 1),
                  itemCount: controller.isLoading.value
                      ? 1
                      : controller.filteredLaporanList.isEmpty
                          ? 1
                          : controller.filteredLaporanList.length,
                  itemBuilder: (context, index) {
                    if (controller.isLoading.value) {
                    } else if (controller.filteredLaporanList.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(
                          child: EmptyStateWidget(
                            title: "Tidak ada Laporan",
                            message: "Saat ini tidak ada laporan yang tersedia",
                          ),
                        ),
                      );
                    } else {
                      final laporan = controller.filteredLaporanList[index];
                      return _buildLaporanCard(laporan);
                    }
                  },
                ),
              );
            }),
          ),],
        ),
      );
    }

  Widget _buildLaporanCard(LaporModel laporan) {
    return InkWell(
      onTap: () => controller.viewDetail(laporan),
      child: Card(
        color: AppColors.white,
        margin: AppResponsive.margin(bottom: 1.5),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: laporan.gambar != null
                      ? Image.network(
                          "https://backend.desagodigital.id/uploads/lapor/${laporan.gambar}",
                          width: double.infinity,
                          height: AppResponsive.h(18),
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: double.infinity,
                          height: AppResponsive.h(18),
                          color: AppColors.grey.withOpacity(0.2),
                          child: Icon(Icons.image, size: 50, color: AppColors.grey),
                        ),
                ),
                Positioned(
                  top: AppResponsive.h(1),
                  left: AppResponsive.w(2),
                  child: Container(
                    padding: AppResponsive.padding(horizontal: 1.5, vertical: 0.5),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Kategori: ${laporan.kategori?.nama}",
                      style: AppText.small(color: AppColors.text),
                    ),
                  ),
                ),
                Positioned(
                  top: AppResponsive.h(1),
                  right: AppResponsive.w(2),
                  child: Container(
                    padding: AppResponsive.padding(horizontal: 1.5, vertical: 0.5),
                    decoration: BoxDecoration(
                      color: controller.getStatusColor(laporan.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      laporan.status.capitalizeEachWord(),
                      style: AppText.small(color: AppColors.secondary),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: AppResponsive.padding(vertical: 2, horizontal: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${laporan.id}',
                      style: AppText.bodySmall(color: AppColors.textSecondary)),
                  SizedBox(height: AppResponsive.h(1)),
                  Text(
                    laporan.judul,
                    style: AppText.h6(color: AppColors.text),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppResponsive.h(1)),
                  Text(
                    laporan.deskripsi,
                    style: AppText.bodyMedium(color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppResponsive.h(1)),
                  Container(
                    width: double.infinity,
                    padding: AppResponsive.padding(vertical: 1.5, horizontal: 3),
                    decoration: BoxDecoration(
                      color: AppColors.muted,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      laporan.tanggapan.length > 1 ? laporan.tanggapan: "Tanggapan belum tersedia",
                      style: AppText.bodySmall(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}