import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:desago/app/utils/app_responsive.dart';
import '../controllers/surat_riwayat_pengajuan_detail_controller.dart';

class SuratRiwayatPengajuanDetailView extends GetView<SuratRiwayatPengajuanDetailController> {
  const SuratRiwayatPengajuanDetailView({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Initialize responsive sizing
    AppResponsive().init(context);
    
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Detail Pengajuan Surat',
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
      body: Obx(() => controller.data.isEmpty
          ? Center(
              child: Text(
                'Data tidak ditemukan',
                style: AppText.bodyLarge(color: AppColors.textSecondary),
              ),
            )
          : SingleChildScrollView(
              padding: AppResponsive.padding(horizontal: 4, vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Card(
                    color: AppColors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: AppResponsive.padding(all: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nomor Pengajuan:',
                                    style: AppText.bodySmall(color: AppColors.textSecondary),
                                  ),
                                  SizedBox(height: AppResponsive.h(0.5)),
                                  Text(
                                    '${controller.data['id'] ?? "-"}',
                                    style: AppText.h5(color: AppColors.text),
                                  ),
                                ],
                              ),
                              Container(
                                padding: AppResponsive.padding(horizontal: 1.5, vertical: 0.8),
                                decoration: BoxDecoration(
                                  color: controller.getStatusColor(controller.data['status']).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${controller.data['status'] ?? "-"}',
                                  style: AppText.pSmallBold(
                                    color: controller.getStatusColor(controller.data['status']),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppResponsive.h(2)),
                          Text(
                            'Jenis Surat:',
                            style: AppText.bodySmall(color: AppColors.textSecondary),
                          ),
                          SizedBox(height: AppResponsive.h(0.5)),
                          Text(
                            '${controller.data['jenis'] ?? "-"}',
                            style: AppText.h6(color: AppColors.text),
                          ),
                          SizedBox(height: AppResponsive.h(2)),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tanggal Pengajuan:',
                                      style: AppText.bodySmall(color: AppColors.textSecondary),
                                    ),
                                    SizedBox(height: AppResponsive.h(0.5)),
                                    Text(
                                      controller.data['tanggal'] != null
                                          ? controller.dateFormat.format(controller.data['tanggal'])
                                          : "-",
                                      style: AppText.bodyMedium(color: AppColors.text),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Keterangan:',
                                      style: AppText.bodySmall(color: AppColors.textSecondary),
                                    ),
                                    SizedBox(height: AppResponsive.h(0.5)),
                                    Text(
                                      '${controller.data['keterangan'] ?? "-"}',
                                      style: AppText.bodyMedium(color: AppColors.text),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: AppResponsive.h(3)),
                  
                  // Status Tracking
                  Text(
                    'Status Pengajuan',
                    style: AppText.h5(color: AppColors.text),
                  ),
                  SizedBox(height: AppResponsive.h(2)),
                  
                  // Tracking Timeline
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.trackingStatus.length,
                    itemBuilder: (context, index) {
                      final item = controller.trackingStatus[index];
                      final bool isLast = index == controller.trackingStatus.length - 1;
                      
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Timeline Line and Dot
                          Column(
                            children: [
                              Container(
                                width: AppResponsive.w(3),
                                height: AppResponsive.w(3),
                                decoration: BoxDecoration(
                                  color: item['isDone'] 
                                    ? (item['isRejected'] ?? false) 
                                      ? AppColors.danger 
                                      : AppColors.success
                                    : AppColors.grey,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.white,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.shadow.withOpacity(0.1),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                              if (!isLast)
                                Container(
                                  width: 2,
                                  height: AppResponsive.h(10),
                                  color: item['isDone'] ? AppColors.success : AppColors.grey.withOpacity(0.5),
                                ),
                            ],
                          ),
                          
                          SizedBox(width: AppResponsive.w(2)),
                          
                          // Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'],
                                  style: AppText.h6(
                                    color: item['isDone'] 
                                      ? (item['isRejected'] ?? false) 
                                        ? AppColors.danger 
                                        : AppColors.text
                                      : AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: AppResponsive.h(0.5)),
                                if (item['date'] != null)
                                  Text(
                                    controller.dateFormat.format(item['date']),
                                    style: AppText.bodySmall(color: AppColors.textSecondary),
                                  ),
                                SizedBox(height: AppResponsive.h(0.5)),
                                Text(
                                  item['description'],
                                  style: AppText.bodyMedium(
                                    color: (item['isRejected'] ?? false) 
                                      ? AppColors.danger 
                                      : AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: AppResponsive.h(2)),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  
                  SizedBox(height: AppResponsive.h(3)),
                  
                  if (controller.data['status'] == 'Ditolak')
                    ElevatedButton.icon(
                      onPressed: () {
              
                      },
                      icon: Icon(Icons.refresh, color: AppColors.white),
                      label: Text('Ajukan Ulang', style: AppText.button(color: AppColors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: Size(double.infinity, AppResponsive.h(6)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    
                  if (controller.data['status'] == 'Selesai')
                    ElevatedButton.icon(
                      onPressed: () {
                     
                      },
                      icon: Icon(Icons.download, color: AppColors.white),
                      label: Text('Unduh Surat', style: AppText.button(color: AppColors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        minimumSize: Size(double.infinity, AppResponsive.h(6)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                ],
              ),
            )
      ),
    );
  }
}