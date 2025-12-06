import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: AppColors.white,
            ),
            onPressed: () {
              controller.refreshData();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          controller.buatLaporanBaru();
        },
        child: Icon(Icons.add, color: AppColors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: AppResponsive.padding(horizontal: 4, vertical: 2),
            child: TextField(
              controller: controller.searchController,
              onChanged: (value) => controller.filterLaporan(),
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
                suffixIcon: IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () => _showFilterBottomSheet(context),
                ),
              ),
            ),
          ),
          Container(
            height: AppResponsive.h(5),
            margin: EdgeInsets.only(top: 2, bottom: 4),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.statusOptions.length,
              padding: EdgeInsets.symmetric(horizontal: AppResponsive.w(4)),
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
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [AppColors.primary, AppColors.info],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color:
                            isSelected ? null : AppColors.grey.withOpacity(0.1),
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
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                    child: CircularProgressIndicator(color: AppColors.primary));
              }

              if (controller.filteredLaporanList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off,
                          size: AppResponsive.sp(60), color: AppColors.grey),
                      SizedBox(height: AppResponsive.h(2)),
                      Text(
                        'Tidak ada laporan yang ditemukan',
                        style:
                            AppText.bodyLarge(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: AppResponsive.padding(horizontal: 4, vertical: 1),
                itemCount: controller.filteredLaporanList.length,
                itemBuilder: (context, index) {
                  final laporan = controller.filteredLaporanList[index];

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
                                child: Image.asset(
                                  laporan['foto'],
                                  width: double.infinity,
                                  height: AppResponsive.h(18),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: AppResponsive.h(1),
                                left: AppResponsive.w(2),
                                child: Container(
                                  padding: AppResponsive.padding(
                                      horizontal: 1.5, vertical: 0.5),
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        controller.getKategoriIcon(
                                            laporan['kategori']),
                                        size: AppResponsive.sp(14),
                                        color: AppColors.primary,
                                      ),
                                      SizedBox(width: AppResponsive.w(0.5)),
                                      Text(
                                        laporan['kategori'],
                                        style: AppText.small(
                                            color: AppColors.text),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: AppResponsive.h(1),
                                right: AppResponsive.w(2),
                                child: Container(
                                  padding: AppResponsive.padding(
                                      horizontal: 1.5, vertical: 0.5),
                                  decoration: BoxDecoration(
                                    color: controller
                                        .getStatusColor(laporan['status'])
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    laporan['status'],
                                    style: AppText.small(
                                      color: controller
                                          .getStatusColor(laporan['status']),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: AppResponsive.padding(
                                      horizontal: 2, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                  child: Text(
                                    laporan['judul'],
                                    style: AppText.h6(color: AppColors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: AppResponsive.padding(all: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'ID: ${laporan['id']}',
                                      style: AppText.bodySmall(
                                          color: AppColors.textSecondary),
                                    ),
                                    SizedBox(width: AppResponsive.w(1)),
                                    Expanded(
                                      child: Text(
                                        controller.dateFormat
                                            .format(laporan['tanggal']),
                                        style: AppText.bodySmall(
                                            color: AppColors.textSecondary),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppResponsive.h(1)),
                                Text(
                                  laporan['deskripsi'],
                                  style: AppText.bodyMedium(
                                      color: AppColors.textSecondary),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: AppResponsive.h(1)),
                                if (laporan['keterangan'] != null)
                                  Container(
                                    width: double.infinity,
                                    padding: AppResponsive.padding(all: 1.5),
                                    decoration: BoxDecoration(
                                      color: AppColors.muted,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      laporan['keterangan'],
                                      style: AppText.bodySmall(
                                          color: AppColors.textSecondary),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                SizedBox(height: AppResponsive.h(1)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (laporan['tanggapan'] != null)
                                      Chip(
                                        backgroundColor: AppColors.skyBlue,
                                        label: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.chat,
                                                size: AppResponsive.sp(14),
                                                color: AppColors.info),
                                            SizedBox(
                                                width: AppResponsive.w(0.5)),
                                            Text(
                                              'Ada Tanggapan',
                                              style: AppText.smallBold(
                                                  color: AppColors.info),
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.zero,
                                      ),
                                    Spacer(),
                                    TextButton.icon(
                                      onPressed: () =>
                                          controller.viewDetail(laporan),
                                      icon: Icon(Icons.visibility,
                                          size: AppResponsive.sp(16),
                                          color: AppColors.info),
                                      label: Text(
                                        'Lihat Detail',
                                        style: AppText.smallBold(
                                            color: AppColors.info),
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
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: AppResponsive.padding(horizontal: 4, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Laporan',
                  style: AppText.h5(color: AppColors.text),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: AppResponsive.sp(24)),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            SizedBox(height: AppResponsive.h(2)),
            Text(
              'Status',
              style: AppText.h6(color: AppColors.text),
            ),
            SizedBox(height: AppResponsive.h(1)),
            Obx(() => Wrap(
                  spacing: AppResponsive.w(1),
                  runSpacing: AppResponsive.h(1),
                  children: controller.statusOptions.map((status) {
                    bool isSelected = controller.selectedStatus.value == status;
                    return ChoiceChip(
                      selected: isSelected,
                      label: Text(status),
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      backgroundColor: AppColors.muted,
                      labelStyle: AppText.small(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          controller.setStatusFilter(status);
                          Get.back();
                        }
                      },
                    );
                  }).toList(),
                )),
            SizedBox(height: AppResponsive.h(3)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.searchController.clear();
                  controller.selectedStatus.value = 'Semua';
                  controller.filterLaporan();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: AppResponsive.padding(vertical: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Reset Filter',
                  style: AppText.button(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
