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
            child: Obx(() => CustomScrollView(
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
                        background: Stack(
                          fit: StackFit.expand,
                          children:[
                            
                          Image.asset(
                            controller.product['image'] ??
                                'assets/img/placeholder.jpg',
                            fit: BoxFit.cover,
                          ),
                          ] 
                        ),
                      ),
                    ),
      
                    /// Konten bawah AppBar
                    SliverToBoxAdapter(
                      child: _buildProductInfo(),
                    ),
                  ],
                )),
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
                Expanded(
                  child: Container(
                    width: 130,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.buyNow,
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
                            style: AppText.button(
                              color: Colors.white,
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
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.categoryBackground,
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: Text(
                    controller.product['category'] ?? 'Category',
                    style: AppText.bodyMedium(color: AppColors.category),
                    )),
          SizedBox(height: 8),
          Obx(() => Text(
                controller.product['name'] ?? 'Product Name',
                style: AppText.h5(color: AppColors.dark),
              )),
              SizedBox(height: 8),
              Obx(() => Text(
                "Mulai ${controller.product['price_range'] ?? 'No price range available'}",
                style: AppText.bodyMedium(color: AppColors.textSecondary),
                
              )),
          SizedBox(height: 8),
          Obx(() => Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: Text(
                    '${controller.product['open_time']}',
                    style: AppText.bodyMedium(color: AppColors.secondary),
                  ),
                ),),
          SizedBox(height: 8),
          Text(
            'Description',
            style: AppText.h6(
              color: AppColors.dark,
            ),
          ),
          SizedBox(height: 8),
          Obx(() => Text(
                controller.product['description'] ?? 'No description available',
                style: AppText.bodyMedium(color: AppColors.textSecondary),
                textAlign: TextAlign.justify,
              )),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 20),
              Text(
                'Maps',
                style: AppText.h6(
                  color: AppColors.dark,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Obx(() => GestureDetector(
                  onTap: () async {
                    final url = controller.product['maps_url'];
                    if (url != null && await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(
                        Uri.parse(url),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: Text(
                    controller.product['maps_url'] ?? 'No Maps available',
                    style: AppText.bodyMedium(
                      color: Colors.blue,
                    ),
                  ),
                ))

        ],
      ),
    );
  }
}