import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/constant/api_constant.dart';

class SuratListController extends GetxController {
  final isLoading = true.obs;
  final jenisSuratList = <Map<String, dynamic>>[].obs;
  final TextEditingController searchController = TextEditingController();
  final searchKeyword = ''.obs;

  List<Map<String, dynamic>> get filteredSuratList {
    if (searchKeyword.value.isEmpty) {
      return jenisSuratList;
    }

    final keyword = searchKeyword.value.toLowerCase();

    return jenisSuratList.where((item) {
      final nama = (item['nama'] ?? '').toString().toLowerCase();
      final deskripsi = (item['deskripsi'] ?? '').toString().toLowerCase();

      return nama.contains(keyword) || deskripsi.contains(keyword);
    }).toList();
  }

  void updateSearch(String value) {
    searchKeyword.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    fetchJenisSurat();
  }

  Future<void> fetchJenisSurat() async {
    try {
      isLoading.value = true;

      final response =
          await DioService.instance.get(ApiConstant.jenisSurat);

      dynamic raw = response.data;
      List listData = [];

      if (raw is List) {
        listData = raw;
      } else if (raw is Map) {
        if (raw['data'] is List) {
          listData = raw['data'];
        } else if (raw['data'] is String) {
          listData = jsonDecode(raw['data']);
        }
      }

      jenisSuratList.assignAll(
        listData.map((e) => Map<String, dynamic>.from(e)).toList(),
      );
    } catch (e) {
      // sebaiknya tambahkan log error
      print("Error fetch jenis surat: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToDetail(Map<String, dynamic> surat) {
    Get.toNamed(
      '/surat-form',
      arguments: {
        'suratId': surat['id'].toString(),
        'suratTitle': surat['nama'].toString(),
        'suratData': surat,
      },
    );
  }

  void resetState() {
    searchKeyword.value = '';
    searchController.clear();
  }

  @override
  void onClose() {
    searchController.clear();
    searchKeyword.value = '';
    super.onClose();
  }
}