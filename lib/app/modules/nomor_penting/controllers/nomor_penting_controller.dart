import 'dart:convert';

import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/NomorPentingModel.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class NomorPentingController extends GetxController {
  final RxList<NomorPentingModel> nomorDarurat = <NomorPentingModel>[].obs;
  final RxList<NomorPentingModel> filteredNomor = <NomorPentingModel>[].obs;

  final TextEditingController searchController = TextEditingController();
  final RxString searchText = ''.obs;

  final RxBool isLoading = true.obs;
  final GetStorage _box = GetStorage();
  final String _cacheKey = 'nomor_penting_cache';

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hasCache = _loadFromCache();

        if (!hasCache) {
          fetchNomorDarurat();
        } else {
          isLoading.value = false;
        }
    });
  }

  Future<void> refreshNomorPenting() async {
    await fetchNomorDarurat();
  }


  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  bool _loadFromCache() {
    final cachedData = _box.read(_cacheKey);

    if (cachedData == null) return false;

    try {
      final List decoded = jsonDecode(cachedData);
      final data =
          decoded.map((e) => NomorPentingModel.fromJson(e)).toList();

      nomorDarurat.assignAll(data);
      filteredNomor.assignAll(data);

      return true;
    } catch (e) {
      return false;
    }
  }


  
  void _saveToCache(List<NomorPentingModel> data) {
    final jsonData =
        jsonEncode(data.map((e) => e.toJson()).toList());
    _box.write(_cacheKey, jsonData);
  }

  Future<void> fetchNomorDarurat() async {
  try {
    isLoading.value = true;

    final res = await DioService.instance.get(ApiConstant.nomorDarurat);

    final List listData =
        res.data is List ? res.data : res.data['data'] ?? [];

    final data =
        listData.map((e) => NomorPentingModel.fromJson(e)).toList();

    nomorDarurat.assignAll(data);
    filteredNomor.assignAll(data);

    _saveToCache(data);

  } catch (e) {

  } finally {
    isLoading.value = false;
  }
}


  void filterNomorDarurat(String keyword) {
    searchText.value = keyword;

    if (keyword.isEmpty) {
      filteredNomor.assignAll(nomorDarurat);
      return;
    }

    final key = keyword.toLowerCase();

    filteredNomor.assignAll(
      nomorDarurat.where((item) {
        return item.nama.toLowerCase().contains(key) ||
            item.noTelepon.contains(key);
      }).toList(),
    );
  }

  Future<void> callNumber(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar(
        'Kesalahan',
        'Tidak dapat melakukan panggilan ke nomor $phoneNumber',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> openWhatsApp(String phoneNumber) async {
    String formattedNumber = phoneNumber;

    if (!formattedNumber.startsWith('+')) {
      if (formattedNumber.startsWith('0')) {
        formattedNumber = '+62${formattedNumber.substring(1)}';
      } else if (formattedNumber.startsWith('62')) {
        formattedNumber = '+$formattedNumber';
      } else {
        formattedNumber = '+62$formattedNumber';
      }
    }

    final Uri url = Uri.parse('https://wa.me/$formattedNumber');

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      Get.snackbar(
        'Kesalahan',
        'Tidak dapat membuka WhatsApp untuk nomor $phoneNumber',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void copyToClipboard(String text) {
    try {
      Clipboard.setData(ClipboardData(text: text));
      Get.snackbar(
        'Berhasil',
        'Nomor $text berhasil disalin',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success.withOpacity(0.8),
        colorText: AppColors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Kesalahan',
        'Gagal menyalin nomor',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger.withOpacity(0.8),
        colorText: AppColors.white,
      );
    }
  }
}
