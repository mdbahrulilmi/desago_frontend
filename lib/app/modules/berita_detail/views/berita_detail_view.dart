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
              expandedHeight: 350.0,
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

                    // Gradient Overlay
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
                      top: 90,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withOpacity(0.8),
                              AppColors.purple.withOpacity(0.8)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          berita['category'],
                          style: AppText.small(color: Colors.white),
                        ),
                      ),
                    ),

                    // Tombol Aksi
                    Positioned(
                      top: 60,
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
                          CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: IconButton(
                              icon: const Icon(Remix.heart_line,
                                  color: Colors.white),
                              onPressed: controller.toggleFavorite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                title: Text(
                  berita['title'],
                  style: AppText.h6(color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                titlePadding:
                    const EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
                    // Informasi Penulis dan Waktu
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
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              berita['author'],
                              style: AppText.bodyMedium(color: AppColors.dark),
                            ),
                            Text(
                              berita['date'],
                              style:
                                  AppText.small(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(
                              Remix.eye_line,
                              color: AppColors.textSecondary,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${berita['views']} Views',
                              style:
                                  AppText.small(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Konten Utama
                    Text(
                      berita['content'],
                      style: AppText.bodyMedium(color: AppColors.dark),
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
