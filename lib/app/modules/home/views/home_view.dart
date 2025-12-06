import 'package:carousel_slider/carousel_slider.dart';
import 'package:desago/app/components/custom_bottom_navigation_controller.dart';
import 'package:desago/app/components/custom_bottom_navigation_widget.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
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
            padding: EdgeInsets.all(8),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary,
                      ),
                      SizedBox(width: AppResponsive.w(3)),
                      Expanded(
                          child: Image.asset(
                        'assets/img/logo.png',
                        height: AppResponsive.h(6),
                      )),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.muted,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Remix.settings_3_line,
                              color: AppColors.primary),
                        ),
                      )
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
                        padding: const EdgeInsets.all(16),
                        child: GridView.count(
                          childAspectRatio: 0.8,
                          crossAxisCount: 4,
                          crossAxisSpacing: AppResponsive.w(4),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            _buildMenuItem(Remix.mail_fill, 'Surat',
                                AppColors.info, () {
                                 BottomNavigationController.to.navigateToRoute(Routes.SURAT_PETUNJUK);
                                }),
                            _buildMenuItem(Remix.alarm_warning_line, 'Lapor',
                                AppColors.danger, () {
                              Get.toNamed(Routes.LAPOR);
                            }),
                            _buildMenuItem(Remix.bank_line, 'Dana Desa',
                                AppColors.lime, () {
                                  Get.toNamed(Routes.DANA_DESA);
                                }),
                            _buildMenuItem(Remix.phone_line, 'No Telp Penting',
                                AppColors.warning, () {
                              Get.toNamed(Routes.NOMOR_PENTING);
                            }),
                            _buildMenuItem(Remix.profile_line, 'Profile Desa',
                                AppColors.amber, () {
                              Get.toNamed(Routes.PROFIL_DESA);
                            }),
                            _buildMenuItem(Remix.newspaper_line, 'Berita',
                                AppColors.teal, () {
                                  BottomNavigationController.to.navigateToRoute(Routes.BERITA_LIST);
                                }),
                            _buildMenuItem(Remix.calendar_event_line, 'Agenda',
                                AppColors.tertiary, () {
                                  Get.toNamed(Routes.AGENDA);
                                }),
                            _buildMenuItem(Remix.product_hunt_line,
                                'Produk Desa', AppColors.lightBlue, () {
                                  Get.toNamed(Routes.PRODUK_LIST_SEMUA);
                               }),
                            _buildMenuItem(Remix.gift_2_line, 'Cek Bansos',
                                AppColors.blueGrey, () {
                                  Get.toNamed(Routes.CEK_BANSOS);
                                }),
                            _buildMenuItem(Remix.survey_line, 'Bantuan UMKM',
                                AppColors.purple, () {}),
                            _buildMenuItem(Remix.suitcase_3_line, 'Loker Desa',
                                AppColors.textSecondary, () {
                                  Get.toNamed(Routes.LOKER_DESA);
                                }),
                            _buildMenuItem(Remix.hand_coin_line, 'Donasi',
                                AppColors.success, () {
                                  Get.toNamed(Routes.DONASI);
                                }),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: AppResponsive.h(2),
                      )
                    ],
                  ),
                 _buildProductSection(context),
                  SizedBox(height: AppResponsive.h(2)),
                  _buildNewsSection(context)
                ]),
          ),
        ),
      )),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  Widget _buildMenuItem(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            padding: EdgeInsets.all(AppResponsive.w(4)),
            child: Icon(
              icon,
              color: AppColors.white,
              size: AppResponsive.sp(18),
            ),
          ),
          SizedBox(height: AppResponsive.h(1)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppResponsive.w(1)),
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
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow.withOpacity(0.2),
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  product['image'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: Text(
                      product['name'],
                      style: AppText.h5thin(color: AppColors.white),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
              "Produk Desa",
              style: AppText.h5(color: AppColors.dark),
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(Routes.PRODUK_LIST_SEMUA);
              },
              child: Row(
                children: [
                  Text(
                    'Lihat Semua',
                    style: AppText.button(color: AppColors.dark),
                  ),
                  SizedBox(width: AppResponsive.w(1)),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: AppColors.dark,
                  )
                ],
              )
            )
          ],
        ),
      ),
      SizedBox(height: AppResponsive.h(2)),
      CarouselSlider(
        carouselController: controller.carouselController,
        options: CarouselOptions(
          height: AppResponsive.h(35),
          viewportFraction: 1,
          enableInfiniteScroll: true,
          autoPlay: true,
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
      Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:controller.products.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () =>controller.carouselController.animateToPage(entry.key),
            child: Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:controller.currentIndex.value == entry.key 
                  ? AppColors.primary 
                  : AppColors.primary.withOpacity(0.3),
              ),
            ),
          );
        }).toList(),
      )),
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
              TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.BERITA_LIST);
                  },
                  child: Row(
                    children: [
                      Text(
                        'Lihat Semua',
                        style: AppText.button(color: AppColors.dark),
                      ),
                      SizedBox(width: AppResponsive.w(1)),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: AppColors.dark,
                      )
                    ],
                  ))
            ],
          ),
        ),
        SizedBox(height: AppResponsive.h(2)),
        CarouselSlider(
          options: CarouselOptions(
            height: AppResponsive.h(30),
            autoPlay: true,
            viewportFraction: 1,
            autoPlayCurve: Curves.fastOutSlowIn,
            autoPlayAnimationDuration: const Duration(milliseconds: 1000),
            pauseAutoPlayOnTouch: true,
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
   BuildContext context, String title, String imagePath, String date) {
 return Container(
   margin: const EdgeInsets.symmetric(horizontal: 2),
   decoration: BoxDecoration(
     color: AppColors.white,
     borderRadius: BorderRadius.circular(12),
     boxShadow: [
       BoxShadow(
         color: AppColors.shadow.withOpacity(0.3),
         blurRadius: 6,
         offset: const Offset(0, 3),
       ),
     ],
   ),
   child: Column(
     crossAxisAlignment: CrossAxisAlignment.stretch,
     children: [
       Expanded(
         child: ClipRRect(
           borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
           child: Stack(
             fit: StackFit.expand,
             children: [
               Image.asset(
                 imagePath,
                 fit: BoxFit.cover,
                 width: double.infinity,
               ),
               Positioned(
                 bottom: 0,
                 left: 0,
                 right: 0,
                 child: Container(
                   padding: EdgeInsets.all(12),
                   decoration: BoxDecoration(
                     color: Colors.black.withOpacity(0.3),
                   ),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         title,
                         style: AppText.h6(color: AppColors.white),
                         maxLines: 2,
                         overflow: TextOverflow.ellipsis,
                       ),
                       SizedBox(height: AppResponsive.h(0.5)),
                       Text(
                         date,
                         style: AppText.caption(
                             color: AppColors.white),
                       ),
                     ],
                   ),
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
}
