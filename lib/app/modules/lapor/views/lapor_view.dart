import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/lapor_controller.dart';

class LaporView extends GetView<LaporController> {
  const LaporView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        title: Text(
          'Lapor',
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
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Gunakan fitur ini untuk melaporkan keadaan darurat atau kondisi penting yang perlu ditindaklanjuti',
              style: AppText.bodyMedium(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
          
          Expanded(
            child: Center(
              child: InkWell(
                onTap: () {
                  controller.captureLaporImage();
                },
                customBorder: CircleBorder(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 220,
                      height: 220,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Lottie.asset(
                          'assets/lottie/lapor.json',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Text(
                        'LAPOR',
                        style: AppText.h3(color: AppColors.danger),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Ketuk untuk membuat laporan',
                        style: AppText.caption(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.LAPOR_RIWAYAT);
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
                  Icon(Remix.history_line, color: AppColors.white,),
                  SizedBox(width: 12),
                  Text(
                    'Riwayat Laporan',
                    style: AppText.button(color: AppColors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
