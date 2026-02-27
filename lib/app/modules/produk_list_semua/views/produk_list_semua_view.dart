import 'package:auto_size_text/auto_size_text.dart';
import 'package:desago/app/helpers/empty_helper.dart';
import 'package:desago/app/helpers/number_helper.dart';
import 'package:desago/app/helpers/time_helper.dart';
import 'package:desago/app/models/ProdukModel.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/produk_list_semua_controller.dart';

class ProdukListSemuaView extends GetView<ProdukListSemuaController> {
  const ProdukListSemuaView({super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.secondary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'UMKM',
          style: AppText.h5(color: AppColors.secondary),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.w(4),
              vertical: AppResponsive.h(2),
            ),
            child: TextField(
              controller: controller.searchController,
              onChanged: (value) => controller.filterProducts(value),
              decoration: InputDecoration(
                hintText: 'Cari umkm...',
                hintStyle:
                    AppText.bodyMedium(color: AppColors.textSecondary),
                prefixIcon:
                    Icon(Remix.search_line, color: AppColors.iconGrey),
                fillColor: AppColors.grey.withOpacity(0.1),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
         Expanded(
          child: Obx(() {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async => await controller.refreshUMKM(),
              child: ListView.builder(
                controller: controller.scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.w(4),
                  vertical: AppResponsive.h(1),
                ),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.filteredProducts.isEmpty
                    ? 1
                    : controller.filteredProducts.length +
                        (controller.isLoadMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (controller.isLoading.value &&
                      controller.filteredProducts.isEmpty) {
                  }
                  if (controller.filteredProducts.isEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Center(
                        child: EmptyStateWidget(
                          title: "Tidak ada UMKM",
                          message:
                              "Saat ini tidak ada UMKM yang tersedia",
                        ),
                      ),
                    );
                  }
                  if (index < controller.filteredProducts.length) {
                    final product = controller.filteredProducts[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: AppResponsive.h(1)),
                      child: _buildGridProductItem(product, index),
                    );
                  } else {
                  }
                },
              ),
            );
          }),
        )
        ],
      ),
    );
  }

  Widget _buildGridProductItem(ProdukModel product, int index) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(Routes.PRODUK_DETAIL, arguments: product),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: AppResponsive.w(35),
                height: AppResponsive.w(35),
                child: Image.network(
                  product.gambar?.toString() ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/no_image.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 14.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    product.judul?.toString() ?? '-',
                    style: AppText.pSmallBold(
                        color: AppColors.dark),
                    maxLines: 1,
                    minFontSize: 8,
                    maxFontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppResponsive.h(0.5)),
                  Text(
                    product.hargaMin ==
                            product.hargaMax
                        ? 'Rp ${NumberHelper.formatRupiah(product.hargaMin)}'
                        : 'Rp ${NumberHelper.formatRupiah(product.hargaMin)} - Rp ${NumberHelper.formatRupiah(product.hargaMax)}',
                    style: AppText.smallBold(
                        color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppResponsive.h(1)),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius:
                          BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${TimeHelper.formatTime(product.jamBuka)} - ${TimeHelper.formatTime(product.jamTutup)}",
                      style: AppText.bodySmall(
                          color:
                              AppColors.secondary),
                    ),
                  ),
                  SizedBox(height: AppResponsive.h(1)),
                  Text(
                    product.kategori?.nama
                            .toString() ??
                        '-',
                    style: AppText.smallBold(
                        color: AppColors.grey),
                  ),
                  SizedBox(height: AppResponsive.h(1)),
                  Row(
                    children: [
                      const Icon(
                          Icons.location_on_outlined,
                          size: 20),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          product.lokasi
                                  ?.toString() ??
                              '-',
                          style: AppText.bodySmall(
                              color:
                                  AppColors.grey),
                          overflow:
                              TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
