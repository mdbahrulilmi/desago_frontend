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
  final RxList<Map<String, dynamic>> products = [
    {
      'name': 'Gula Jawa',
      'description': 'Pak Ahmad',
      'price': 40.000,
      'quantity': 1,
      'image': 'assets/img/produk_1.jpg',
    },
    {
      'name': 'Kopi Robusta',
      'description': 'Pak Suryono',
      'price': 43.000,
      'quantity': 2,
      'image': 'assets/img/produk_2.jpg',
    },
    {
      'name': 'Tembakau gayo',
      'description': 'Kaji Suryanto',
      'price': 39.000,
      'quantity': 1,
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
