import 'package:desago/app/helpers/time_helper.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '../controllers/produk_detail_controller.dart';

class ProdukDetailView extends GetView<ProdukDetailController> {
  const ProdukDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final produk = controller.product.value;

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight: AppResponsive.h(40),
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.black,
                    leading: Padding(
                      padding: EdgeInsets.all(AppResponsive.w(1.5)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Get.back(),
                        ),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: produk == null
                          ? const SizedBox()
                          : Image.network(
                              produk.gambar,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),

                  /// Konten bawah AppBar
                  SliverToBoxAdapter(
                    child: _buildProductInfo(),
                  ),
                ],
              );
            }),
          ),

          /// ===== Bottom Button =====
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final produk = controller.product.value;
                        if (produk == null) return;

                        controller.openWhatsApp(
                          phone: produk.notelpFix,
                          product: produk.judul
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.bottonGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Remix.whatsapp_line, color: AppColors.white),
                          SizedBox(width: AppResponsive.w(3)),
                          Text(
                            'Pesan Sekarang',
                            style: AppText.button(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= INFO =================

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        final produk = controller.product.value;
        if (produk == null) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.categoryBackground,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                produk.kategori!.nama,
                style: AppText.bodyMedium(color: AppColors.category),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              produk.judul,
              style: AppText.h5(color: AppColors.dark),
            ),
            const SizedBox(height: 8),
            Text(
              "Mulai Rp${produk.hargaMin}",
              style: AppText.bodyMedium(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "${TimeHelper.formatTime(produk.jamBuka)} - ${TimeHelper.formatTime(produk.jamTutup)}",
                style: AppText.bodyMedium(color: AppColors.secondary),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Description',
              style: AppText.h6(color: AppColors.dark),
            ),
            const SizedBox(height: 8),
            Text(
              produk.deskripsi,
              style: AppText.bodyMedium(color: AppColors.textSecondary),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 20),
                Text(
                  'Maps',
                  style: AppText.h6(color: AppColors.dark),
                ),
              ],
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final url = produk.lokasiGmaps;
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              child: Text(
                produk.lokasiGmaps,
                style: AppText.bodyMedium(color: Colors.blue),
              ),
            ),
          ],
        );
      }),
    );
  }
}