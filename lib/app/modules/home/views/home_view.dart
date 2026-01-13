import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:desago/app/components/custom_bottom_navigation_controller.dart';
import 'package:desago/app/components/custom_bottom_navigation_widget.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: controller.refreshData,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: AppResponsive.w(3)),
                      Expanded(
                          child: Image.asset(
                        'assets/img/logo.png',
                        height: AppResponsive.h(6),
                      )),
                    ],
                  ),
                  SizedBox(height: AppResponsive.h(2)),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: AppResponsive.h(20),
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1,
                    ),
                    items: [
                      'assets/img/slide1.jpg',
                      'assets/img/slide2.jpg',
                      'assets/img/slide3.jpg',
                    ].map((imagePath) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: AppResponsive.h(2)),
                  InkWell(
                    onTap: () {
                      Get.toNamed(Routes.TAUTKAN_AKUN);
                    },
                    child: Container(
                      height: AppResponsive.h(12),
                      width: double.infinity,
                      padding: AppResponsive.padding(vertical: 1),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.info,
                              AppColors.lightBlue.withOpacity(1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            tileMode: TileMode.repeated,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tautkan Akun Anda Dengan Desa',
                                style: AppText.button(color: AppColors.white),
                              ),
                              Text(
                                'Tautkan akun anda untuk mendapatkan pelayanan maksimal',
                                style: AppText.small(color: AppColors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                
                  SizedBox(height: AppResponsive.h(2)),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: AppResponsive.w(2)),
                      Text(
                        'Layanan Untukmu',
                        style: AppText.h5(color: AppColors.dark),
                      ),
                    ],
                  ),
                  SizedBox(height: AppResponsive.h(1)),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: GridView.count(
                          childAspectRatio: 0.8,
                          crossAxisCount: 4,
                          crossAxisSpacing: AppResponsive.w(4),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            _buildMenuItem(Remix.bank_line, 'Profile Desa',
                                AppColors.primary, 
                                AppColors.secondary, () {
                              Get.toNamed(Routes.PROFIL_DESA);
                            }),
                            _buildMenuItem(Remix.alarm_warning_line, 'Lapor',
                                AppColors.primary,
                                AppColors.secondary, () {
                              Get.toNamed(Routes.LAPOR);
                            }),
                            _buildMenuItem(null, 'No Darurat',
                                AppColors.primary,
                                AppColors.secondary, () {
                              Get.toNamed(Routes.NOMOR_PENTING);
                            }),
                            _buildMenuItem(Remix.mail_fill, 'Surat',
                                AppColors.primary,
                                AppColors.secondary, () {
                                 Get.toNamed(Routes.SURAT_PETUNJUK);
                                }),                            
                            _buildMenuItem(Remix.file_chart_fill, 'Dana Desa',
                                AppColors.secondary,
                                AppColors.primary, () {
                                  Get.toNamed(Routes.DANA_DESA);
                                }),                      
                            _buildMenuItem(Remix.box_3_fill,
                                'UMKM', AppColors.secondary,
                                AppColors.primary, () {
                                  Get.toNamed(Routes.PRODUK_LIST_SEMUA);
                               }),                            
                            _buildMenuItem(Remix.calendar_todo_fill, 'Agenda',
                                AppColors.secondary,
                                AppColors.primary, () {
                                  Get.toNamed(Routes.AGENDA);
                                }),
                            
                            _buildMenuItem(Remix.newspaper_fill, 'Berita',
                            AppColors.secondary,
                            AppColors.primary, () {
                              Get.toNamed(Routes.BERITA_LIST);
                            }),            
                          ],
                        ),
                      ),
                      SizedBox(
                        height: AppResponsive.h(2),
                      )
                    ],
                  ),
                  _buildNewsSection(context),
                  SizedBox(height: AppResponsive.h(2)),
                 _buildProductSection(context),
                 SizedBox(height: AppResponsive.h(10)),
                ]),
          ),
        ),
      )),
    );
  }

  Widget _buildMenuItem(
      IconData? icon, String label, Color color, Color iconColor, VoidCallback onTap,) {
      return  icon == null ? 
          InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: AppColors.border
              ),
              color: color,
            ),
            padding: EdgeInsets.all(AppResponsive.w(3)),
            child: SvgPicture.asset(
              'assets/icons/emergency-call.svg',
              width: AppResponsive.sp(26),
              height: AppResponsive.sp(26),
            )
          ),
          SizedBox(height: AppResponsive.h(1)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppResponsive.w(0)),
            child: Text(
              label,
              style: AppText.smallBold(color: AppColors.text),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),
        ],
      ),
          )
    : InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: AppColors.border
              ),
              color: color,
            ),
            padding: EdgeInsets.all(AppResponsive.w(3)),
            child: Icon(
              icon,
              color: iconColor,
              size: AppResponsive.sp(26),
            ),
          ),
          SizedBox(height: AppResponsive.h(1)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppResponsive.w(0)),
            child: Text(
              label,
              style: AppText.smallBold(color: AppColors.text),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildProductCard(
  BuildContext context,
  Map<String, dynamic> product,
) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow.withOpacity(0.1),
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(12),
          ),
          child: AspectRatio(
            aspectRatio: 16 / 14,
            child: Image.asset(
              product['image'],
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: Text(
            product['category'] ?? "Makanan",
            style: AppText.bodySmall(color: AppColors.grey),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: AutoSizeText(
          product['name'],
          style: AppText.h6(color: AppColors.text),
          textAlign: TextAlign.start,
          maxLines: 2,
          minFontSize: 10,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.bottonGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Remix.whatsapp_line,
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  "Pesan Sekarang",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

      ],
    ),
  );
}

 Widget _buildProductSection(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: EdgeInsets.only(left: 9, right: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "UMKM Desa",
              style: AppText.h5(color: AppColors.dark),
            ),
          ],
        ),
      ),
      SizedBox(height: AppResponsive.h(3)),
      CarouselSlider(
        carouselController: controller.carouselController,
        options: CarouselOptions(
          height: AppResponsive.h(35),
          viewportFraction: 0.52,
          enableInfiniteScroll: false,
          padEnds: false,
          autoPlayInterval: Duration(seconds: 3),
          onPageChanged: (index, reason) {
            controller.changeSlide(index);
          },
        ),
        items: controller.products.map((product) {
          return _buildProductCard(
            context, 
            product,
          );
        }).toList(),
      ),
      SizedBox(height: AppResponsive.h(2)),
    ],
  );
}

  Widget _buildNewsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 9, right: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Berita Desa",
                style: AppText.h5(color: AppColors.dark),
              ),
            ],
          ),
        ),
        SizedBox(height: AppResponsive.h(2)),
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            height: AppResponsive.h(30),
            viewportFraction: 0.70,
            autoPlayCurve: Curves.fastOutSlowIn,
            autoPlayAnimationDuration: const Duration(milliseconds: 1000),
            pauseAutoPlayOnTouch: true,
            padEnds: false,
            enlargeCenterPage: false,
          ),
          items: [
            _buildNewsCard(
              context,
              'Pembangunan Infrastruktur Desa Tahap Kedua Dimulai',
              'assets/img/berita_1.jpg',
              '12 Mei 2024',
            ),
            _buildNewsCard(
              context,
              'Pelatihan UMKM Dorong Ekonomi Kreatif Warga Desa',
              'assets/img/berita_2.jpeg',
              '15 Mei 2024',
            ),
            _buildNewsCard(
              context,
              'Festival Budaya Lokal Tingkatkan Pariwisata Desa',
              'assets/img/berita_3.jpg',
              '18 Mei 2024',
            ),
            _buildNewsCard(
              context,
              'Program Penanaman Pohon Serentak Capai 1000 Bibit',
              'assets/img/berita_4.jpg',
              '20 Mei 2024',
            ),
          ],
        ),
      ],
    );
  }
  

 Widget _buildNewsCard(
  BuildContext context,
  String title,
  String imagePath,
  String date,
) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow.withOpacity(0.1),
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🖼 IMAGE (16:9)
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(12),
          ),
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),

        // 📝 TEXT SECTION
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppText.h6(color: AppColors.dark),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                date,
                style: AppText.caption(color: AppColors.grey),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

}
