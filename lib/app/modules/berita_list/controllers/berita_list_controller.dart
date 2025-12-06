import 'package:desago/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BeritaListController extends GetxController {
   final TextEditingController searchController = TextEditingController();
  
  final RxList<String> categories = [
    'Semua', 
    'Pemerintahan', 
    'Pembangunan', 
    'Budaya', 
    'Sosial'
  ].obs;
  
  final RxString selectedCategory = 'Semua'.obs;
  
  // List berita dengan detail lengkap
  final RxList<Map<String, dynamic>> beritas = [
    {
      'title': 'Pembangunan Jembatan Desa Tahap Akhir',
      'author': 'Admin Desa',
      'date': '15 Maret 2025',
      'category': 'Pembangunan',
      'excerpt': 'Pembangunan jembatan penghubung antar dusun telah memasuki tahap akhir...',
      'content': 'Pembangunan jembatan penghubung antar dusun telah memasuki tahap akhir. Proyek ini diharapkan dapat meningkatkan akses transportasi warga dan memperlancar kegiatan ekonomi masyarakat.',
      'image': 'assets/img/berita_1.jpg',
      'views': 256,
      'comments': 12
    },
    {
      'title': 'Pelestarian Budaya Lokal Melalui Festival Seni',
      'author': 'Kepala Desa',
      'date': '10 Maret 2025',
      'category': 'Budaya',
      'excerpt': 'Desa Sukamaju menggelar Festival Seni untuk melestarikan budaya tradisional...',
      'content': 'Dalam upaya melestarikan warisan budaya, Desa Sukamaju menggelar Festival Seni tahunan yang menampilkan berbagai kesenian tradisional dari berbagai kelompok masyarakat.',
      'image': 'assets/img/berita_2.jpeg',
      'views': 412,
      'comments': 25
    },
    {
      'title': 'Program Bantuan Sosial untuk Warga Kurang Mampu',
      'author': 'Tim Kesejahteraan',
      'date': '05 Maret 2025',
      'category': 'Sosial',
      'excerpt': 'Pemerintah desa meluncurkan program bantuan sosial untuk warga kurang mampu...',
      'content': 'Dalam rangka meningkatkan kesejahteraan masyarakat, pemerintah desa meluncurkan program bantuan sosial yang akan mendistribusikan bantuan langsung kepada warga yang membutuhkan.',
      'image': 'assets/img/berita_3.jpg',
      'views': 189,
      'comments': 8
    },
  ].obs;

  final RxList<Map<String, dynamic>> filteredBeritas = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    filteredBeritas.value = beritas;
    super.onInit();
  }

  void filterBerita(String query) {
    if (query.isEmpty) {
      filteredBeritas.value = beritas;
    } else {
      filteredBeritas.value = beritas.where((berita) {
        return berita['title'].toLowerCase().contains(query.toLowerCase()) ||
               berita['content'].toLowerCase().contains(query.toLowerCase()) ||
               berita['author'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  void filterByCategory(String category) {
    if (category == 'Semua') {
      filteredBeritas.value = beritas;
    } else {
      filteredBeritas.value = beritas.where((berita) {
        return berita['category'] == category;
      }).toList();
    }
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
    filterByCategory(category);
  }

  void bacaBeritaLengkap(Map<String, dynamic> berita) {
    Get.toNamed(Routes.BERITA_DETAIL, arguments: berita);
  }

  // Metode untuk menambah jumlah views
  void tambahViews(Map<String, dynamic> berita) {
    int index = beritas.indexWhere((b) => b['title'] == berita['title']);
    if (index != -1) {
      beritas[index]['views'] = (beritas[index]['views'] ?? 0) + 1;
    }
  }
}
