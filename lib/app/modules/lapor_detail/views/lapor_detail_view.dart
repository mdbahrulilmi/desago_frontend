import 'package:desago/app/helpers/time_helper.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/lapor_detail_controller.dart';

class LaporDetailView extends GetView<LaporDetailController> {
  const LaporDetailView({super.key});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Detail pengaduan',
          style: AppText.h5(color: AppColors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: Get.back,
        ),
      ),
      body: Expanded(
        child: SingleChildScrollView(
          child: Container(
            padding: AppResponsive.padding(horizontal:  5, vertical: 2),
            child: Column(
              children: [
                Card(
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
                            child: Image.network(
                              "https://backend.desago.id/uploads/lapor/${controller.laporan['image']}",
                              width: double.infinity,
                              height: AppResponsive.h(24),
                              fit: BoxFit.cover,
                            ),
                          )],
                      ),
                      Padding(
                        padding: AppResponsive.padding(vertical: 2, horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                controller.laporan['title'],
                                style: AppText.h6(color: AppColors.text),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            SizedBox(height: AppResponsive.h(1)),
                            Text(
                              "Status",
                              style:AppText.bodyMediumBold(color: AppColors.text)),
                              SizedBox(height: AppResponsive.h(0.5)),
                            Text(
                              controller.laporan['status'],
                              style: AppText.bodyMedium(color: AppColors.textSecondary),
                            ),
                            SizedBox(height: AppResponsive.h(1)),
                            Text(
                              "Ditujukan ke",
                              style:AppText.bodyMediumBold(color: AppColors.text)),
                              SizedBox(height: AppResponsive.h(0.5)),
                            Text(
                              controller.laporan['ditujukan'],
                              style: AppText.bodyMedium(color: AppColors.textSecondary),
                            ),
                            SizedBox(height: AppResponsive.h(1)),
                            Text(
                              "Kategori",
                              style:AppText.bodyMediumBold(color: AppColors.text)),
                              SizedBox(height: AppResponsive.h(0.5)),
                            Text(
                              controller.laporan['kategori']['name'],
                              style: AppText.bodyMedium(color: AppColors.textSecondary),
                            ),
                            SizedBox(height: AppResponsive.h(1)),
                            Text(
                              "Waktu",
                              style:AppText.bodyMediumBold(color: AppColors.text)),
                              SizedBox(height: AppResponsive.h(0.5)),
                            Text(
                              TimeHelper.formatJam(controller.laporan['created_at']),
                              style: AppText.bodyMedium(color: AppColors.textSecondary),
                            ),
                            SizedBox(height: AppResponsive.h(1)),
                            Text(
                              "Tanggal",
                              style:AppText.bodyMediumBold(color: AppColors.text)),
                              SizedBox(height: AppResponsive.h(0.5)),
                            Text(
                              TimeHelper.formatTanggalIndonesia(controller.laporan['created_at']),
                              style: AppText.bodyMedium(color: AppColors.textSecondary),
                            ),
                            SizedBox(height: AppResponsive.h(1)),
                            Text(
                              "Deskripsi",
                              style:AppText.bodyMediumBold(color: AppColors.text)),
                              SizedBox(height: AppResponsive.h(0.5)),
                            Text(
                              controller.laporan['description'],
                              style: AppText.bodyMedium(color: AppColors.textSecondary),
                              textAlign: TextAlign.justify
                            ),
                            SizedBox(height: AppResponsive.h(1)),
                            Text(
                              "Tanggapan",
                              style:AppText.bodyMediumBold(color: AppColors.text)),
                              SizedBox(height: AppResponsive.h(0.5)),
                            Text(
                              controller.laporan['tanggapan'] ?? "Malas menanggapi",
                              style: AppText.bodyMedium(color: AppColors.textSecondary),
                            ),
                            SizedBox(height: AppResponsive.h(1)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppResponsive.h(1)),
                Container(
                  margin: AppResponsive.padding(horizontal: 5),
                  child: SizedBox(
                        width: double.infinity,
                        height: AppResponsive.h(6),
                        child: ElevatedButton(
                          onPressed: () => {Get.back()},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Selesai',
                            style: AppText.button(color: AppColors.white),
                          ),
                        ),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
