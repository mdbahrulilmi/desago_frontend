import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '../controllers/produk_detail_controller.dart';

class ProdukDetailView extends GetView<ProdukDetailController> {
  const ProdukDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
        title: Text(
          controller.product['name'] ?? 'Product Name',
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    Obx(() => Container(
                          height: AppResponsive.h(40),
                          width: double.infinity,
                          child: Image.asset(
                            controller.product['image'] ??
                                'assets/img/placeholder.jpg',
                            fit: BoxFit.cover,
                          ),
                        )),

                    // Product Thumbnails
                    Container(
                      height: AppResponsive.h(10),
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          4,
                          (index) => Container(
                            margin: EdgeInsets.only(left: 16),
                            width: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: index == 0
                                      ? AppColors.primary
                                      : Colors.grey.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Obx(() => ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    controller.product['image'] ??
                                        'assets/img/placeholder.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),

                    // Product Info
                    _buildProductInfo(),

                    // About Item Content
                    _buildAboutItem(),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Price
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Harga',
                          style: AppText.pSmallBold(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Rp 45.000',
                          style: AppText.h5(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Buy Now Button
                  Container(
                    width: 130,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.buyNow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Remix.whatsapp_line, color: AppColors.white),
                          SizedBox(width: AppResponsive.w(3)),
                          Text(
                            'Pesan',
                            style: AppText.button(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store Name
          Row(
            children: [
              Icon(Remix.user_2_line, size: 16, color: AppColors.textSecondary),
              SizedBox(width: 4),
              Text(
                'tokobaju.id',
                style: AppText.small(color: AppColors.textSecondary),
              ),
            ],
          ),
          SizedBox(height: 8),
          Obx(() => Text(
                controller.product['name'] ?? 'Product Name',
                style: AppText.h5(color: AppColors.dark),
              )),
        ],
      ),
    );
  }

  Widget _buildAboutItem() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSpecificationItem('Condition', 'New'),
          _buildSpecificationItem('Material', 'Cotton'),
          _buildSpecificationItem('Weight', '200g'),
          _buildSpecificationItem('Size', 'M, L, XL'),
          SizedBox(height: 16),
          Text(
            'Description',
            style: AppText.bodyMedium(
              color: AppColors.dark,
            ),
          ),
          SizedBox(height: 8),
          Obx(() => Text(
                controller.product['description'] ?? 'No description available',
                style: AppText.bodyMedium(color: AppColors.textSecondary),
              )),
          SizedBox(height: 8),
          Text(
            'This product is made of high-quality cotton material that is comfortable to wear. Available in several colors and sizes. Perfect for casual wear or daily activities.',
            style: AppText.bodyMedium(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificationItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppText.bodyMedium(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            ': ',
            style: AppText.bodyMedium(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppText.bodyMedium(
              color: AppColors.dark,
            ),
          ),
        ],
      ),
    );
  }
}
