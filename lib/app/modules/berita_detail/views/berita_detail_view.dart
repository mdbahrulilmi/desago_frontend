import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/helpers/time_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
    final berita = controller.berita;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
              onPressed: () => Get.back(),
            ),
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    "${berita.gambar}",
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
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        berita.kategori,
                        style: AppText.small(color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: IconButton(
                        icon: const Icon(Remix.share_line,
                            color: Colors.white),
                        onPressed: controller.shareBerita,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    berita.judul,
                    style: AppText.h5(color: AppColors.text),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            AppColors.primary.withOpacity(0.2),
                        child: Icon(
                          Remix.user_3_line,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        berita.author,
                        style: AppText.bodyMedium(
                            color: AppColors.text),
                      ),
                      const SizedBox(width: 16),
                      Icon(Remix.calendar_2_fill, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        TimeHelper.formatTanggalDate(berita.timestamp),
                        style: AppText.bodyMedium(
                            color: AppColors.text),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Html(
                    data: berita.content,
                    style: {
                      "body": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        fontSize: FontSize(14),
                        textAlign: TextAlign.justify,
                        color: AppColors.text,
                      ),
                    },
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
