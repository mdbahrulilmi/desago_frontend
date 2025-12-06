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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.dark),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Semua Produk Desa',
          style: AppText.h5(color: AppColors.dark),
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
                hintText: 'Cari produk...',
                hintStyle: AppText.bodyMedium(color: AppColors.textSecondary),
                prefixIcon: Icon(Remix.search_2_line, color: AppColors.textSecondary),
                fillColor: AppColors.grey.withOpacity(0.1),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Container(
            height: AppResponsive.h(5),
            margin: EdgeInsets.symmetric(vertical: AppResponsive.h(2)),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.categories.length,
              padding: EdgeInsets.symmetric(horizontal: AppResponsive.w(4)),
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return Obx(() {
                  final isSelected =
                      controller.selectedCategory.value == category;
                  return GestureDetector(
                    onTap: () => controller.setSelectedCategory(category),
                    child: Container(
                      margin: EdgeInsets.only(right: AppResponsive.w(3)),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.w(4),
                        vertical: AppResponsive.h(1),
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [AppColors.primary, AppColors.info],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color:
                            isSelected ? null : AppColors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: AppText.small(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          Expanded(
          child: Obx(() => GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: AppResponsive.w(4), vertical: AppResponsive.h(1)),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: AppResponsive.w(3),
              mainAxisSpacing: AppResponsive.h(2),
            ),
            itemCount: controller.filteredProducts.length,
            itemBuilder: (context, index) {
              final product = controller.filteredProducts[index];
              return _buildGridProductItem(product, index);
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
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                child: Image.asset(
                  product['image'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(AppResponsive.w(2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product['name'],
                    style: AppText.bodyMedium(color: AppColors.dark),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product['description'],
                    style: AppText.small(color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Rp${product['price']}',
                    style: AppText.bodyMedium(color: AppColors.primary,),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
