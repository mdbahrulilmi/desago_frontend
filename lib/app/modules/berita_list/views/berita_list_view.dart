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
          style: AppText.h5(color: AppColors.dark),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Remix.filter_line, color: AppColors.dark),
            onPressed: _showFilterBottomSheet,
          ),
        ],
         leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColors.dark),
                onPressed: () => Get.back(),
              ),
      ),
      body: Column(
        children: [
          // Pencarian Berita
          _buildSearchBar(),

          // Kategori Filter
          _buildCategoryFilter(),
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
        onChanged: (value) => controller.filterBerita(value),
        decoration: InputDecoration(
          hintText: 'Cari Berita',
          hintStyle: AppText.bodyMedium(color: AppColors.textSecondary),
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
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

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: controller.categories.map((category) {
          return Obx(() {
            final isSelected = controller.selectedCategory.value == category;
            return GestureDetector(
              onTap: () => controller.setSelectedCategory(category),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.muted,
                  ),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: isSelected
                        ? AppText.smallBold(color: Colors.white)
                        : AppText.small(color: AppColors.textSecondary),
                  ),
                ),
              ),
            );
          });
        }).toList(),
      ),
    );
  }

  // Daftar Berita
  Widget _buildBeritaList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.filteredBeritas.length,
      itemBuilder: (context, index) {
        final berita = controller.filteredBeritas[index];
        return _buildBeritaCard(berita);
      },
    );
  }

 // Kartu Berita
Widget _buildBeritaCard(Map<String, dynamic> berita) {
  return GestureDetector(
    onTap: () => controller.bacaBeritaLengkap(berita),
    child: Card(
      color: AppColors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              children: [
                Image.asset(
                  berita['image'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      children: [
                        Icon(
                          Remix.user_3_line, 
                          size: 14, 
                          color: Colors.white
                        ),
                        const SizedBox(width: 5),
                        Text(
                          berita['author'],
                          style: AppText.small(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Badge Tanggal di kanan atas
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.danger.withOpacity(0.8),
                          AppColors.warning.withOpacity(0.8)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      children: [
                        Icon(
                          Remix.calendar_line, 
                          size: 14, 
                          color: Colors.white
                        ),
                        const SizedBox(width: 5),
                        Text(
                          berita['date'],
                          style: AppText.small(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Konten Berita
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kategori
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(berita['category']).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    berita['category'],
                    style: AppText.small(
                      color: _getCategoryColor(berita['category']),
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // Judul
                Text(
                  berita['title'],
                  style: AppText.h6(color: AppColors.dark),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  berita['excerpt'],
                  style: AppText.bodyMedium(color: AppColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
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