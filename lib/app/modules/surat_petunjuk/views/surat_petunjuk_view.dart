import 'package:desago/app/components/custom_bottom_navigation_widget.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/surat_petunjuk_controller.dart';

class SuratPetunjukView extends GetView<SuratPetunjukController> {
  const SuratPetunjukView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        title: Text(
          'Surat',
          style: AppText.h5(color: AppColors.white),
        ),
        centerTitle: true,
        
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: AppResponsive.h(20)),
          Center(
              child: Text(
            'Petunjuk',
            style: AppText.h5(color: AppColors.dark),
          )),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. Pilih Jenis Surat',
                  style: AppText.p(color: AppColors.dark),
                ),
                Text(
                  '2. Isi Formulir yang akan dibuat',
                  style: AppText.p(color: AppColors.dark),
                ),
                Text(
                  '3. Ambil Surat di kantor desa',
                  style: AppText.p(color: AppColors.dark),
                ),
                SizedBox(
                  height: AppResponsive.h(2),
                ),
              ],
            ),
          ),
          Center(
            child: SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.SURAT_LIST_KATEGORI);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: AppResponsive.padding(vertical: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Buat Surat',
                  style: AppText.button(color: AppColors.white),
                ),
              ),
            ),
          ),
        ]),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
