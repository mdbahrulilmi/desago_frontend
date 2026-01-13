import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProdukListSemuaController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxList<Map<String, dynamic>> filteredProducts =
      <Map<String, dynamic>>[].obs;
  final RxList<String> categories =
      ['Semua', 'Makeup', 'Skincare', 'Perawatan', 'Lainnya'].obs;
  final RxString selectedCategory = 'Semua'.obs;
  // List produk dengan detail
  final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[
  {
    'category': 'Makanan Berat',
    'name': 'Bakso Mercon Kumis Pak Maman',
    'price_range': '10rb - 20rb',
    'open_time': '09.00 - 22.00',
    'description':
        'Bakso pedas dengan isian cabai melimpah yang menggugah selera. '
        'Tersedia berbagai pilihan bakso seperti bakso mercon super pedas, '
        'bakso urat, bakso telur, hingga bakso halus dengan kuah gurih hangat.',
    'maps_url': 'https://share.google/0gdrAMgRRst3kplgb',
    'location': 'Pringsurat',
    'image': 'assets/img/produk_1.jpg',
  },
  {
    'category': 'Makanan Berat',
    'name': 'Mie Ayam Pak Slamet',
    'price_range': '8rb - 18rb',
    'open_time': '08.00 - 21.00',
    'description':
        'Mie ayam dengan tekstur mie kenyal, topping ayam manis gurih, '
        'dan kuah kaldu yang kaya rasa. Cocok dinikmati untuk sarapan '
        'maupun makan siang.',
    'maps_url': 'https://share.google/mieAyamPakSlamet',
    'location': 'Pringsurat',
    'image': 'assets/img/produk_2.jpg',
  },
  {
    'category': 'Makanan Berat',
    'name': 'Bubur Ayam Cak Darto',
    'price_range': '7rb - 15rb',
    'open_time': '06.00 - 11.00',
    'description':
        'Bubur ayam lembut dengan topping ayam suwir, cakwe, '
        'dan taburan bawang goreng. Disajikan hangat, pas untuk '
        'menu sarapan pagi.',
    'maps_url': 'https://share.google/buburAyamCakDarto',
    'location': 'Pringsurat',
    'image': 'assets/img/produk_3.jpg',
  },
].obs;

  @override
  void onInit() {
    filteredProducts.value = products;
    super.onInit();
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.value = products;
    } else {
      filteredProducts.value = products.where((product) {
        return product['name'].toLowerCase().contains(query.toLowerCase()) ||
            product['description'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  void filterByCategory(String category) {
    if (category == 'Semua') {
      filteredProducts.value = products;
    } else {
      filteredProducts.value = products.where((product) {
        return product['category'] == category;
      }).toList();
    }
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
    filterByCategory(category);
  }
}
