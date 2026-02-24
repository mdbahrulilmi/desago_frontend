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
                  Padding(
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
                                  '${controller.data['jenis_surat']['nama'] ?? "-"}',
                                  style: AppText.h6(color: AppColors.text),
                                ),
                                SizedBox(height: AppResponsive.h(0.5)),
                                Text(
                                  'No. Reg: ${controller.data['reg'] ?? "-"}',
                                  style: AppText.bodyMedium(color: AppColors.text),
                                ),
                              ],
                            ),
                          ],
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
                                    controller.data['created_at'] != null
                                    ? controller.perngajuanFormat.format(
                                      DateTime.parse(controller.data['created_at']),
                                    )

                                    : '-',
                                    style: AppText.bodyMediumBold(color: AppColors.text),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pemohon:',
                                    style: AppText.bodySmall(color: AppColors.textSecondary),
                                  ),
                                  SizedBox(height: AppResponsive.h(0.5)),
                                  Text(
                                    '${controller.dataForm['nama'] ?? "-"}',
                                    style: AppText.bodyMediumBold(color: AppColors.text),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: AppResponsive.h(3)),
                  Text(
                    'Status Pengajuan',
                    style: AppText.h5(color: AppColors.text),
                  ),
                  SizedBox(height: AppResponsive.h(2)),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.trackingStatus.length,
                    itemBuilder: (context, index) {
                      final item = controller.trackingStatus[index];
                      final bool isLast = index == controller.trackingStatus.length - 1;
                      final bool isDone = item['isDone'] == true;
                      final bool isRejected = item['isRejected'] == true;
                      final bool isProses = item['isProses'] == true;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: AppResponsive.w(6),
                                height: AppResponsive.w(6),
                                decoration: BoxDecoration(
                                    color: isRejected
                                      ? AppColors.danger
                                      : isDone
                                          ? AppColors.lightGreen
                                          : isProses
                                              ? AppColors.lightBlue
                                              : AppColors.grey,

                                              

                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isRejected
                                      ? AppColors.danger
                                      : isDone
                                          ? AppColors.lightGreen
                                          : isProses
                                              ? Colors.blue
                                              : AppColors.grey,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.shadow.withOpacity(0.1),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: isRejected
                                  ? Icon(
                                    Icons.close,
                                    size: 15,
                                    color: AppColors.secondary) 
                                    : isDone 
                                  ? Icon(
                                    Icons.check,
                                    size: 15,
                                    color: AppColors.secondary) 
                                    : isProses 
                                  ? Icon(
                                    Icons.edit_document,
                                    size: 15,
                                    color: AppColors.secondary) 
                                    : Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Container(
                                        width: 5,
                                        height: 5,
                                        decoration: BoxDecoration(
                                        color: AppColors.border,
                                        shape: BoxShape.circle
                                        ),
                                      ),
                                    ),
                              ),
                              if (!isLast)
                                Container(
                                  width: 2,
                                  height: AppResponsive.h(10),
                                  color: item['isDone'] ? AppColors.success : AppColors.border.withOpacity(0.5),
                                ),
                            ],
                          ),
                          
                          SizedBox(width: AppResponsive.w(2)),
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
                                    item['date'],
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
                ],
              ),
            )
      ),
    );
  }
}