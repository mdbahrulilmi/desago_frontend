import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BeritaListController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  final RxList<String> categories = [
    'Semua',
    'Pemerintahan',
    'Pembangunan',
    'Budaya',
    'Sosial',
  ].obs;

  final RxString selectedCategory = 'Semua'.obs;

  final RxList<Map<String, dynamic>> beritas = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredBeritas = <Map<String, dynamic>>[].obs;

  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBerita();

    // Listener search
    searchController.addListener(() {
      filterBerita(searchController.text);
    });
  }

  Future<void> fetchBerita() async {
  try {
    isLoading.value = true;
    final res = await DioService.instance.get(ApiConstant.beritaDesa);

    List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(res.data).map((berita) {
      return {
        "image": berita['gambar'] ?? '',
        "title": berita['judul'] ?? '-',
        "excerpt": (berita['isi'] ?? '').replaceAll(RegExp(r'<[^>]*>'), '').substring(0, 100),
        "category": berita['kategori'] ?? 'Umum',
        "date": berita['tgl']?.split(' ')?.first ?? '-',
        "raw": berita,
      };
    }).toList();

    beritas.value = data;
    filteredBeritas.value = data;
  } catch (e) {
    beritas.value = [];
    filteredBeritas.value = [];
    print("Error fetchBerita: $e");
  } finally {
    isLoading.value = false;
  }
}


  void filterBerita(String keyword) {
    List<Map<String, dynamic>> temp = beritas.where((berita) {
      final matchesCategory = selectedCategory.value == 'Semua' ||
          berita['category'] == selectedCategory.value;
      final matchesKeyword = keyword.isEmpty ||
          berita['title']
              .toString()
              .toLowerCase()
              .contains(keyword.toLowerCase());
      return matchesCategory && matchesKeyword;
    }).toList();

    filteredBeritas.value = temp;
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
    filterBerita(searchController.text);
  }

  void bacaBeritaLengkap(Map<String, dynamic> berita) {
  Get.toNamed(Routes.BERITA_DETAIL, arguments: berita['raw']);
}

}
