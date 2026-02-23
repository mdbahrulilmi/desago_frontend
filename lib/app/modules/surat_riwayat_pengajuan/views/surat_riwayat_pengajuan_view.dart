import 'package:desago/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/surat_riwayat_pengajuan_controller.dart';

class SuratRiwayatPengajuanView
    extends GetView<SuratRiwayatPengajuanController> {
  const SuratRiwayatPengajuanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        title: Text(
          'Riwayat Pengajuan Surat',
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
      ),
      body: Column(
        children: [
          Padding(
            padding: AppResponsive.padding(horizontal: 4, vertical: 2),
            child: TextField(
              controller: controller.searchController,
              onChanged: (value) => controller.filterData(),
              decoration: InputDecoration(
                hintText: 'Cari pengajuan surat...',
                hintStyle: AppText.bodyMedium(color: AppColors.textSecondary),
                prefixIcon:
                    Icon(Remix.search_2_line, color: AppColors.textSecondary),
                fillColor: AppColors.grey.withOpacity(0.1),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Remix.filter_2_line),
                  onPressed: () => _showFilterBottomSheet(context),
                ),
              ),
            ),
          ),

          Obx(() {
            bool hasFilters = controller.selectedStatus.value != 'Semua' ||
                controller.startDate.value != null ||
                controller.endDate.value != null;

            if (!hasFilters) return SizedBox.shrink();

            return Container(
              height: AppResponsive.h(4),
              padding: AppResponsive.padding(horizontal: 4),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (controller.selectedStatus.value != 'Semua')
                    Padding(
                      padding: AppResponsive.padding(right: 1),
                      child: Chip(
                        backgroundColor: AppColors.skyBlue,
                        label: Text(
                          'Status: ${controller.selectedStatus.value}',
                          style: AppText.small(color: AppColors.info),
                        ),
                        deleteIcon: Icon(Icons.close, size: 16),
                        onDeleted: () {
                          controller.setStatusFilter('Semua');
                        },
                      ),
                    ),
                  if (controller.startDate.value != null)
                    Padding(
                      padding: AppResponsive.padding(right: 1),
                      child: Chip(
                        backgroundColor: AppColors.skyBlue,
                        label: Text(
                          'Dari: ${controller.dateFormat.format(controller.startDate.value!)}',
                          style: AppText.small(color: AppColors.info),
                        ),
                        deleteIcon: Icon(Icons.close, size: 16),
                        onDeleted: () {
                          controller.startDate.value = null;
                          controller.filterData();
                        },
                      ),
                    ),
                  if (controller.endDate.value != null)
                    Chip(
                      backgroundColor: AppColors.skyBlue,
                      label: Text(
                        'Sampai: ${controller.dateFormat.format(controller.endDate.value!)}',
                        style: AppText.small(color: AppColors.info),
                      ),
                      deleteIcon: Icon(Icons.close, size: 16),
                      onDeleted: () {
                        controller.endDate.value = null;
                        controller.filterData();
                      },
                    ),
                ],
              ),
            );
          }),

          Expanded(
            child: Obx(() {
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async => await controller.fetchData(),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: AppResponsive.padding(horizontal: 4, vertical: 1),
                  itemCount: controller.isLoading.value
                      ? 1
                      : controller.filteredData.isEmpty
                          ? 1
                          : controller.filteredData.length,
                  itemBuilder: (context, index) {
                    if (controller.isLoading.value) {
                      return SizedBox(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                      );
                    } else if (controller.filteredData.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off,
                                  size: AppResponsive.sp(60), color: AppColors.grey),
                              SizedBox(height: AppResponsive.h(2)),
                              Text(
                                'Tidak ada data yang ditemukan',
                                style: AppText.bodyLarge(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      final item = controller.filteredData[index];

                      return InkWell(
                        onTap: () {
                          Get.toNamed(
                            Routes.SURAT_RIWAYAT_PENGAJUAN_DETAIL,
                            arguments: {
                              'id': item['id'],
                              'data': item,
                            },
                          );
                        },
                        child: Card(
                          color: AppColors.white,
                          margin: AppResponsive.margin(bottom: 1.5),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Padding(
                            padding: AppResponsive.padding(horizontal: 4, vertical: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: AppResponsive.h(28),
                                      child: Text(
                                        '${item['jenis_surat']['nama']}',
                                        style: AppText.h6(color: AppColors.text),
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                    Container(
                                      padding: AppResponsive.padding(
                                          horizontal: 3, vertical: 0.8),
                                      decoration: BoxDecoration(
                                        color: controller
                                            .getStatusColor(item['status'])
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '${item['status']}',
                                        style: AppText.smallBold(
                                          color: controller.getStatusColor(item['status']),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppResponsive.h(1)),
                                Row(
                                  children: [
                                    Icon(Icons.numbers,
                                        size: AppResponsive.sp(16),
                                        color: AppColors.textSecondary),
                                    SizedBox(width: AppResponsive.w(0.5)),
                                    Text(
                                      'No. Pengajuan - ${item['id']}',
                                      style:
                                          AppText.pSmall(color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppResponsive.h(0.5)),
                                Row(
                                  children: [
                                    Icon(Icons.date_range,
                                        size: AppResponsive.sp(16),
                                        color: AppColors.textSecondary),
                                    SizedBox(width: AppResponsive.w(0.5)),
                                    Text(
                                      'Tanggal: ${item['created_at'] != null ? controller.dateFormat.format(DateTime.parse(item['created_at'])) : '-'}',
                                      style:
                                          AppText.pSmall(color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppResponsive.h(0.5)),
                                Text(
                                  'Keterangan: ${item['catatan_admin'] ?? '-'}',
                                  style: AppText.pSmall(color: AppColors.text),
                                ),
                                SizedBox(height: AppResponsive.h(0.2)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
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
                  'Filter',
                  style: AppText.h5(color: AppColors.text),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: AppResponsive.sp(24)),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            SizedBox(height: AppResponsive.h(2)),

            // Status filter
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
                        }
                      },
                    );
                  }).toList(),
                )),

            SizedBox(height: AppResponsive.h(2)),

            // Date filter
            Text(
              'Rentang Tanggal',
              style: AppText.h6(color: AppColors.text),
            ),
            SizedBox(height: AppResponsive.h(1)),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => controller.selectStartDate(context),
                    child: Container(
                      padding:
                          AppResponsive.padding(horizontal: 1.5, vertical: 1.5),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Obx(() => Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: AppResponsive.sp(16),
                                  color: AppColors.textSecondary),
                              SizedBox(width: AppResponsive.w(1)),
                              Text(
                                controller.startDate.value != null
                                    ? controller.dateFormat
                                        .format(controller.startDate.value!)
                                    : 'Tanggal Mulai',
                                style: AppText.small(
                                  color: controller.startDate.value != null
                                      ? AppColors.text
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                SizedBox(width: AppResponsive.w(1)),
                Expanded(
                  child: InkWell(
                    onTap: () => controller.selectEndDate(context),
                    child: Container(
                      padding:
                          AppResponsive.padding(horizontal: 1.5, vertical: 1.5),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Obx(() => Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: AppResponsive.sp(16),
                                  color: AppColors.textSecondary),
                              SizedBox(width: AppResponsive.w(1)),
                              Text(
                                controller.endDate.value != null
                                    ? controller.dateFormat
                                        .format(controller.endDate.value!)
                                    : 'Tanggal Akhir',
                                style: AppText.small(
                                  color: controller.endDate.value != null
                                      ? AppColors.text
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppResponsive.h(3)),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.resetFilters();
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: AppResponsive.padding(vertical: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(color: AppColors.primary),
                    ),
                    child: Text(
                      'Reset',
                      style: AppText.button(color: AppColors.primary),
                    ),
                  ),
                ),
                SizedBox(width: AppResponsive.w(2)),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.filterData();
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
                      'Terapkan',
                      style: AppText.button(color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
