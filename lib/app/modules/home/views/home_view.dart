import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:desago/app/components/custom_bottom_navigation_controller.dart';
import 'package:desago/app/components/custom_bottom_navigation_widget.dart';
import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/BeritaModel.dart';
import 'package:desago/app/models/ProdukModel.dart';
import 'package:desago/app/modules/berita_list/controllers/berita_list_controller.dart';
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
                  Obx(() {
                    if (controller.isLoadingCarousel.value && controller.carousel.isEmpty) {
                      return SizedBox(
                        height: AppResponsive.h(20),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (controller.carousel.isEmpty) {
                      return SizedBox(
                        height: AppResponsive.h(20),
                        child: const Center(child: Text('Carousel kosong')),
                      );
                    }

                    return CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(seconds: 2),
                        viewportFraction: 1,
                      ),
                      items: controller.carousel.map((item) {
                        final imageUrl = '${item.gambar}';
                        print(imageUrl);

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.broken_image),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                  SizedBox(height: AppResponsive.h(2)),
                  Obx(() {
                      return controller.verification.value == "unverified"
                          ? InkWell(
                              onTap: () {
                                Get.toNamed(Routes.TAUTKAN_AKUN);
                              },
                              child: Container(
                                height: AppResponsive.h(12),
                                width: double.infinity,
                                padding:
                                    AppResponsive.padding(vertical: 1),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.info,
                                        AppColors.lightBlue,
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tautkan Akun Anda Dengan Desa',
                                          style: AppText.button(
                                              color: AppColors.white),
                                        ),
                                        Text(
                                          'Tautkan akun anda untuk mendapatkan pelayanan maksimal',
                                          style: AppText.small(
                                              color: AppColors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink();
                    }),

                
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
                                 Get.toNamed(Routes.SURAT_LIST);
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
                              final beritaController = Get.put(BeritaListController(), permanent: true);
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
          SizedBox(height: AppResponsive.h(0.5)),
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
  ProdukModel product,
) {
  return GestureDetector(
    onTap: () => Get.toNamed(Routes.PRODUK_DETAIL, arguments: product),
    child: Container(
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
              child: Image.network(
                product.gambar?.toString() ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
    
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Text(
               '${product.kategori?.nama}' ?? "Makanan",
              style: AppText.bodySmall(color: AppColors.grey),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: AutoSizeText(
            product.judul,
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
              child: GestureDetector(
                onTap: () {
                  controller.openWhatsApp(phone: product.notelpFix, product: product.judul);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Remix.whatsapp_line,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 2),
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
          ),
    
        ],
      ),
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
      Obx(() {
        if (controller.isLoadingProduk.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.products.isEmpty) {
          return const Center(child: Text('Produk kosong'));
        }

        return SizedBox(
        height: AppResponsive.h(35),
        child: CarouselSlider(
          carouselController: controller.carouselController,
          options: CarouselOptions(
            height: AppResponsive.h(35),
            viewportFraction: 0.50,
            enableInfiniteScroll: false,
            padEnds: false,
            onPageChanged: (index, reason) {
              controller.changeSlide(index);
            },
          ),
          items: controller.products.map((product) {
            return _buildProductCard(context, product);
          }).toList(),
        ),
      );
}),
      SizedBox(height: AppResponsive.h(2)),
    ],
  );
}

Widget _buildNewsSection(BuildContext context) {
  return Obx(() {
    if (controller.isLoadingBerita.value) {
      return SizedBox(
        height: AppResponsive.h(30),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (controller.beritas.isEmpty) {
      return SizedBox(
        height: AppResponsive.h(30),
        child: Center(child: Text('Belum ada berita')),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 9, right: 3),
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
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(seconds: 3),
            pauseAutoPlayOnTouch: true,
            padEnds: false,
            enlargeCenterPage: false,
          ),
          items: controller.beritas.map((berita) {
            return _buildNewsCard(context, berita);

          }).toList(),
        ),
      ],
    );
  });
}

  

 Widget _buildNewsCard(
  BuildContext context,
  BeritaModel berita,
) {
  return GestureDetector(
    onTap: () => controller.bacaBeritaLengkap(berita),
    child: Container(
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
              aspectRatio: 16 / 10,
              child: Image.network(
                berita.gambar,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  berita.judul,
                  style: AppText.h6(color: AppColors.dark),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  controller.formatTanggal(berita.timestamp),
                  style: AppText.caption(color: AppColors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


}
