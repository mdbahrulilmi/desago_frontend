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

  static const _cacheKey = 'cache_berita_desa';
  static const _cacheTimeKey = 'cache_berita_desa_time';
  static const Duration _cacheTTL = Duration(hours: 1);

  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      filterBerita(searchController.text);
    });

    _loadFromCache();
    fetchBerita();
  }

  // ================= CACHE =================

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
              .map((e) => BeritaModel.fromJson(e))
              .toList();

          beritas.assignAll(data);
          filteredBeritas.assignAll(data);

          debugPrint('🟡 Berita loaded from cache (${data.length})');
          isLoading.value = false;
        }
      }
    }
  }

  Future<void> _saveToCache(List<BeritaModel> data) async {
    final jsonData = jsonEncode(data.map((e) => e.toJson()).toList());
    await box.write(_cacheKey, jsonData);
    await box.write(_cacheTimeKey, DateTime.now().toIso8601String());
  }

  // ================= API =================

  Future<void> fetchBerita() async {
    try {
      isLoading.value = beritas.isEmpty;

      final res = await DioService.instance.get(ApiConstant.beritaDesa);

      final List listData = res.data is List
          ? res.data
          : (res.data['data'] ?? []);

      final data = listData
          .map<BeritaModel>((json) => BeritaModel.fromJson(json))
          .toList();

      beritas.assignAll(data);
      filteredBeritas.assignAll(data);

      await _saveToCache(data);

      debugPrint('🟢 Berita loaded from API (${data.length})');
    } catch (e) {
      debugPrint('🔴 Error fetchBerita: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ================= FILTER =================

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

  // ================= NAV =================

  void bacaBeritaLengkap(BeritaModel berita) {
    Get.toNamed(
      Routes.BERITA_DETAIL,
      arguments: berita,
    );
  }

  // ================= REFRESH =================

  Future<void> refreshBerita() async {
    clearCache();
    await fetchBerita();
  }

  // ================= MANUAL INVALIDATE =================

  void clearCache() {
    box.remove(_cacheKey);
    box.remove(_cacheTimeKey);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
