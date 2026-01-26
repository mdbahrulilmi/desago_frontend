import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProdukListSemuaController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxList<Map<String, dynamic>> filteredProducts =
      <Map<String, dynamic>>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxString selectedCategory = 'Semua'.obs;
  final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    filteredProducts.value = products;
    fetchProduct();
    super.onInit();
  }

  Future<void> fetchProduct() async {
  try {
    isLoading.value = true;

    final res = await DioService.instance.get(ApiConstant.produkDesa);

    final List listData =
        res.data is List
            ? res.data
            : res.data['data'] ?? [];

    products.value =
        listData.map((e) => Map<String, dynamic>.from(e)).toList();

    filteredProducts.value = products;

    print('Produk loaded: ${products.length}');
  } catch (e) {
    products.clear();
    filteredProducts.clear();
    print("Error fetchProduct: $e");
  } finally {
    isLoading.value = false;
  }
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
