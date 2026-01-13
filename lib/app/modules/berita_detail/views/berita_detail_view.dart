import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';

import '../controllers/berita_detail_controller.dart';

class BeritaDetailView extends GetView<BeritaDetailController> {
  const BeritaDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final berita = controller.berita.value;

        if (berita.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            // SliverAppBar dengan gambar latar
            SliverAppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
                onPressed: () => Get.back(),
              ),
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Gambar Utama
                    Image.asset(
                      berita['image'],
                      fit: BoxFit.cover,
                    ),

                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: const SizedBox.expand(),
                    ),

                    // Badge Kategori
                    Positioned(
                      top: 240,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          berita['category'],
                          style: AppText.small(color: Colors.white),
                        ),
                      ),
                    ),

                    // Tombol Aksi
                    Positioned(
                      top: 35,
                      right: 16,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: IconButton(
                              icon: const Icon(Remix.share_line,
                                  color: Colors.white),
                              onPressed: controller.shareBerita,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ],
                ),                
              ),
              actions: const [],
            ),

            // Konten Berita
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        berita['title'],
                        style: AppText.h5(color: AppColors.text),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                          child: Icon(
                            Remix.user_3_line,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          berita['author'],
                          style: AppText.bodyMedium(color: AppColors.text),
                        ),
                        SizedBox(width: 20.0),
                        Icon(Remix.calendar_2_fill),
                        SizedBox(width: 8.0),
                        Text(
                          berita['date'],
                          style:
                              AppText.bodyMedium(color: AppColors.text),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Konten Utama
                    Text(
                      berita['content'],
                      style: AppText.bodyMedium(color: AppColors.text),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
