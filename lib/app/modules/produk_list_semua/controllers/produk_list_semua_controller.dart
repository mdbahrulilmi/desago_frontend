import 'dart:convert';

import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/ProdukModel.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProdukListSemuaController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final box = GetStorage();

  final RxList<ProdukModel> products = <ProdukModel>[].obs;
  final RxList<ProdukModel> filteredProducts = <ProdukModel>[].obs;

  final RxString selectedCategory = 'Semua'.obs;
  final RxBool isLoading = true.obs;

  static const _cacheKey = 'cache_produk_desa';
  static const _cacheTimeKey = 'cache_produk_desa_time';
  static const Duration _cacheTTL = Duration(hours: 12);

  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      filterProducts(searchController.text);
    });

    _loadFromCache();
    fetchProduct();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
  
  void _loadFromCache() {
    final cachedTime = box.read(_cacheTimeKey);

    if (cachedTime != null) {
      final cacheDate = DateTime.parse(cachedTime);
      final isExpired =
          DateTime.now().difference(cacheDate) > _cacheTTL;

      if (!isExpired) {
        final cachedData = box.read(_cacheKey);
        if (cachedData != null) {
          final List listData = jsonDecode(cachedData);

          final data = listData
              .map((e) => ProdukModel.fromJson(e))
              .toList();

          products.assignAll(data);
          filteredProducts.assignAll(data);

          debugPrint('🟡 Produk loaded from cache (${data.length})');
          isLoading.value = false;
        }
      }
    }
  }

  Future<void> _saveToCache(List<ProdukModel> data) async {
    final jsonData = jsonEncode(data.map((e) => e.toJson()).toList());
    await box.write(_cacheKey, jsonData);
    await box.write(_cacheTimeKey, DateTime.now().toIso8601String());
  }

  Future<void> fetchProduct() async {
    try {
      isLoading.value = products.isEmpty;

      final res = await DioService.instance.get(ApiConstant.produkDesa);
      final List listData =
          res.data is List ? res.data : res.data['data'] ?? [];

      final data = listData
          .map((e) => ProdukModel.fromJson(e))
          .toList();

      products.assignAll(data);
      filteredProducts.assignAll(data);

      await _saveToCache(data);

      debugPrint('🟢 Produk loaded from API (${products.length})');
    } catch (e) {
      debugPrint('🔴 Error fetchProduct: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
      return;
    }

    final q = query.toLowerCase();

    filteredProducts.assignAll(
      products.where((product) {
        final judul = (product.judul ?? '').toLowerCase();
        final deskripsi = (product.deskripsi ?? '').toLowerCase();
        return judul.contains(q) || deskripsi.contains(q);
      }).toList(),
    );
  }

  Future<void> refreshUMKM() async {
    await fetchProduct();
  }
  void clearCache() {
    box.remove(_cacheKey);
    box.remove(_cacheTimeKey);
  }
}
