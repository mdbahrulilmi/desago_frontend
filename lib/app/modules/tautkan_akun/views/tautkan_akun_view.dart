import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:remixicon/remixicon.dart';

import '../controllers/tautkan_akun_controller.dart';

class TautkanAkunView extends GetView<TautkanAkunController> {
  const TautkanAkunView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Tautkan Akun',
          style: AppText.h5(color: AppColors.dark),
        ),
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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: AppResponsive.w(70),
              height: AppResponsive.w(70),
              child: Lottie.asset(
                'assets/lottie/tautkan.json',
                repeat: true,
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text('Tautkan Akun Anda Dengan Desa',
                            style: AppText.h6(color: AppColors.light)),
                        Text('Dapatkan akses layanan lengkap di desa anda',
                            textAlign: TextAlign.center,
                            style: AppText.pSmall(color: AppColors.light)),
                        SizedBox(height: AppResponsive.h(2)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/biodata.svg',
                              color: Colors.white,
                              width: 65,
                              height: 65,
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Biodata',
                                    style:
                                        AppText.bodyLarge(color: AppColors.white),
                                    softWrap: true,
                                  ),
                                  SizedBox(height: AppResponsive.h(1)),
                                  Text(
                                    'Lihat informasi biodata anda secara lengkap',
                                    style:
                                        AppText.caption(color: AppColors.white),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppResponsive.h(4)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/surat.svg',
                              color: Colors.white,
                              width: 65,
                              height: 65,
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Layanan Surat',
                                    style:
                                        AppText.bodyLarge(color: AppColors.white),
                                    softWrap: true,
                                  ),
                                  SizedBox(height: AppResponsive.h(1)),
                                  Text(
                                    'Buat permohonana surat ke desa',
                                    style:
                                        AppText.caption(color: AppColors.white),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppResponsive.h(4)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/berita.svg',
                              color: Colors.white,
                              width: 65,
                              height: 65,
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Berita',
                                    style:
                                        AppText.bodyLarge(color: AppColors.white),
                                    softWrap: true,
                                  ),
                                  SizedBox(height: AppResponsive.h(1)),
                                  Text(
                                    'Baca berita terbaru desa anda',
                                    style:
                                        AppText.caption(color: AppColors.white),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: AppResponsive.h(3),
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(Routes.TAUTKAN_AKUN_FORM);
                          },
                          child: Container(
                            height: AppResponsive.h(8),
                            width: double.infinity,
                            padding: AppResponsive.padding(vertical: 1),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.light),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Tautkan',
                                      style: AppText.button(
                                          color: AppColors.primary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
