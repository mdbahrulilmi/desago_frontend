import 'dart:convert';
import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/BeritaModel.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BeritaListController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final box = GetStorage();

  final RxList<String> categories = [
    'Semua',
    'Pemerintahan',
    'Pembangunan',
    'Budaya',
    'Sosial',
  ].obs;

  final RxString selectedCategory = 'Semua'.obs;

  final RxList<BeritaModel> beritas = <BeritaModel>[].obs;
  final RxList<BeritaModel> filteredBeritas = <BeritaModel>[].obs;

  final isLoading = true.obs;

  final ScrollController scrollController = ScrollController();
  final RxBool isLoadMore = false.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;
  static const int _limit = 10;

  static const _cacheKey = 'cache_berita_desa';
  static const _cacheTimeKey = 'cache_berita_desa_time';
  static const Duration _cacheTTL = Duration(hours: 1);

  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      filterBerita(searchController.text);
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoadMore.value &&
          hasMore.value) {
        loadMoreBerita();
      }
    });

    _loadFromCache();
    fetchBerita();
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> fetchBerita() async {
    try {
      isLoading.value = beritas.isEmpty;
      currentPage.value = 1;
      hasMore.value = true;

      final res = await DioService.instance.get(
        "${ApiConstant.beritaDesa}?page=1&limit=$_limit",
      );

      final List listData = res.data is List
          ? res.data
          : (res.data['data'] ?? []);

      final data = listData
          .map<BeritaModel>((json) => BeritaModel.fromJson(json))
          .toList();

      beritas.assignAll(data);
      filteredBeritas.assignAll(data);

      if (data.length < _limit) {
        hasMore.value = false;
      }

      await _saveToCache(data);
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreBerita() async {
    try {
      isLoadMore.value = true;
      currentPage.value++;

      final res = await DioService.instance.get(
        "${ApiConstant.beritaDesa}?page=${currentPage.value}&limit=$_limit",
      );

      final List listData = res.data is List
          ? res.data
          : (res.data['data'] ?? []);

      final data = listData
          .map<BeritaModel>((json) => BeritaModel.fromJson(json))
          .toList();

      if (data.isEmpty) {
        hasMore.value = false;
      } else {
        beritas.addAll(data);
        filterBerita(searchController.text);

        if (data.length < _limit) {
          hasMore.value = false;
        }
      }
    } catch (e) {
    } finally {
      isLoadMore.value = false;
    }
  }

  void filterBerita(String keyword) {
    filteredBeritas.assignAll(
      beritas.where((berita) {
        final matchesCategory =
            selectedCategory.value == 'Semua' ||
            berita.kategori == selectedCategory.value;

        final matchesKeyword =
            keyword.isEmpty ||
            berita.judul.toLowerCase().contains(keyword.toLowerCase());

        return matchesCategory && matchesKeyword;
      }).toList(),
    );
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
    filterBerita(searchController.text);
  }

  void bacaBeritaLengkap(BeritaModel berita) {
    Get.toNamed(Routes.BERITA_DETAIL, arguments: berita);
  }

  Future<void> refreshBerita() async {
    clearCache();
    await fetchBerita();
  }

  void clearCache() {
    box.remove(_cacheKey);
    box.remove(_cacheTimeKey);
  }

  void _loadFromCache() {}

  Future<void> _saveToCache(List<BeritaModel> data) async {
    final jsonData = jsonEncode(data.map((e) => e.toJson()).toList());
    await box.write(_cacheKey, jsonData);
    await box.write(_cacheTimeKey, DateTime.now().toIso8601String());
  }
}
