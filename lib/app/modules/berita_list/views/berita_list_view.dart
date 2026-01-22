import 'package:auto_size_text/auto_size_text.dart';
import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:remixicon/remixicon.dart';

import '../controllers/berita_list_controller.dart';

class BeritaListView extends GetView<BeritaListController> {
  const BeritaListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Berita Desa',
          style: AppText.h5(color: AppColors.secondary),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
         leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColors.secondary),
                onPressed: () => Get.back(),
              ),
      ),
      body: Column(
        children: [
          // Pencarian Berita
          _buildSearchBar(),

          Expanded(
            child: Obx(() {
              if (controller.filteredBeritas.isEmpty) {
                return _buildEmptyState();
              }

              return _buildBeritaList();
            }),
          ),
        ],
      ),
    );
  }

  // Widget Pencarian Berita
  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.w(4),
        vertical: AppResponsive.h(2),
      ),
      child: TextField(
        controller: controller.searchController,
        // onChanged: (value) => controller.filterBerita(value),
        decoration: InputDecoration(
          hintText: 'Cari Berita',
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
    );
  }

  // Daftar Berita
  Widget _buildBeritaList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.filteredBeritas.length,
      itemBuilder: (context, index) {
        final berita = controller.filteredBeritas[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 14.0),
          child: _buildBeritaCard(berita),
        );
      },
    );
  }

 // Kartu Berita
Widget _buildBeritaCard(Map<String, dynamic> berita) {
  String? gambar = berita['image'];
  return GestureDetector(
    onTap: () => controller.bacaBeritaLengkap(berita),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gambar Berita
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
              height: AppResponsive.h(16),
              child: (gambar != null && gambar.isNotEmpty)
                ? Image.network(
                    "${ApiConstant.pictureUrl}$gambar",
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/images/default.png", // fallback image
                    fit: BoxFit.cover,
                  ),
            ),
          ),
        ),

        // Konten Berita
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 2.0,
              horizontal: 14.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Kategori
                Text(
                  berita['category'] ?? '-',
                  style: AppText.smallBold(
                    color: AppColors.primary,
                  ),
                ),

                SizedBox(height: AppResponsive.h(0.8)),

                // Judul
                AutoSizeText(
                  berita['title']?.toString() ?? '-',
                  style: AppText.pSmallBold(color: AppColors.dark),
                  maxLines: 2,
                  minFontSize: 9,
                  maxFontSize: 14,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: AppResponsive.h(0.6)),

                // Excerpt
                Text(
                  berita['excerpt'] ?? '',
                  style:
                      AppText.bodySmall(color: AppColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: AppResponsive.h(0.8)),

                Row(
                  children: [
                    Icon(
                      Remix.calendar_line,
                      size: 14,
                      color: AppColors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      berita['date'] ?? '-',
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

  // State Kosong saat Tidak Ada Berita
  Widget _buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Gunakan Lottie animation dari aset lokal
        Lottie.asset(
          'assets/lottie/empty.json',
          width: 250,
          height: 250,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
        Text(
          'Tidak Ada Berita',
          style: AppText.h5(color: AppColors.dark),
        ),
        const SizedBox(height: 8),
        Text(
          'Saat ini tidak ada berita yang tersedia',
          style: AppText.bodyMedium(color: AppColors.textSecondary),
        ),
      ],
    ),
  );
}

  // Bottom Sheet Filter
  void _showFilterBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Berita',
              style: AppText.h5(color: AppColors.dark),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: controller.categories.map((category) {
                return Obx(() {
                  final isSelected = controller.selectedCategory.value == category;
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      controller.setSelectedCategory(category);
                    },
                    backgroundColor: AppColors.grey.withOpacity(0.1),
                    selectedColor: AppColors.primary.withOpacity(0.2),
                  );
                });
              }).toList(),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
    );
  }

  // Warna Kategori
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Pemerintahan':
        return AppColors.primary;
      case 'Pembangunan':
        return AppColors.success;
      case 'Budaya':
        return AppColors.warning;
      case 'Sosial':
        return AppColors.info;
      default:
        return AppColors.tertiary;
    }
  }
}