import 'package:auto_size_text/auto_size_text.dart';
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
                hintStyle: AppText.bodyMedium(color: AppColors.textSecondary),
                prefixIcon: Icon(Remix.search_line, color: AppColors.iconGrey),
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
            child: Obx(() => ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.w(4),
                vertical: AppResponsive.h(1),
              ),
              itemCount: controller.filteredProducts.length,
              itemBuilder: (context, index) {
                final product = controller.filteredProducts[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: AppResponsive.h(1)),
                  child: _buildGridProductItem(product, index),
                );
              },
            )),
          )

        ],
      ),
    );
  }

  Widget _buildGridProductItem(Map<String, dynamic> product, int index) {
  return GestureDetector(
    onTap: () => Get.toNamed(Routes.PRODUK_DETAIL, arguments: product),
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
    height: AppResponsive.w(35), // sama dengan width
    child: Image.network(
      product['image']?.toString() ?? '',
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
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  product['title']?.toString() ?? '-',
                  style: AppText.pSmallBold(color: AppColors.dark),
                  maxLines: 1,
                  minFontSize: 8,
                  maxFontSize: 14,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppResponsive.h(0.5)),
                Text(
                  'Mulai dari Rp ${product['harga_mulai']?.toString() ?? '0'}',
                  style: AppText.smallBold(color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppResponsive.h(1)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Text(
                    '07:00 - 16:00',
                    style: AppText.bodySmall(color: AppColors.secondary),
                  ),
                ),
                SizedBox(height: AppResponsive.h(1)),
                Text(
                  '${product['kategori']['name']}',
                  style: AppText.smallBold(color: AppColors.grey),
                ),
                SizedBox(height: AppResponsive.h(1)),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 20),
                    Text(
                      '${product['location'] ?? 'Pringsurat'}',
                      style: AppText.bodySmall(color: AppColors.grey),
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
