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
  final ScrollController scrollController = ScrollController();
  final RxBool isLoadMore = false.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;
  static const int _limit = 10;
  static const _cacheKey = 'cache_produk_desa';
  static const _cacheTimeKey = 'cache_produk_desa_time';
  static const Duration _cacheTTL = Duration(hours: 12);

  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      filterProducts(searchController.text);
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoadMore.value &&
          hasMore.value) {
        loadMoreProduct();
      }
    });

    _loadFromCache();
    fetchProduct();
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
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
      currentPage.value = 1;
      hasMore.value = true;

      final res = await DioService.instance.get(
        "${ApiConstant.produkDesa}?page=1&limit=$_limit",
      );

      final List listData =
          res.data is List ? res.data : res.data['data'] ?? [];

      final data = listData
          .map((e) => ProdukModel.fromJson(e))
          .toList();

      products.assignAll(data);
      filteredProducts.assignAll(data);

      if (data.length < _limit) {
        hasMore.value = false;
      }

      await _saveToCache(data);
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreProduct() async {
    try {
      isLoadMore.value = true;
      currentPage.value++;

      final res = await DioService.instance.get(
        "${ApiConstant.produkDesa}?page=${currentPage.value}&limit=$_limit",
      );

      final List listData =
          res.data is List ? res.data : res.data['data'] ?? [];

      final data = listData
          .map((e) => ProdukModel.fromJson(e))
          .toList();

      if (data.isEmpty) {
        hasMore.value = false;
      } else {
        products.addAll(data);
        filteredProducts.addAll(data);

        if (data.length < _limit) {
          hasMore.value = false;
        }
      }
    } catch (e) {
    } finally {
      isLoadMore.value = false;
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
