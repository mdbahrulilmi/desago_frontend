import 'dart:convert';

import 'package:desago/app/components/alert.dart';
import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/BiodataModel.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/services/storage_services.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AkunBiodataController extends GetxController {
  final Rxn<BiodataModel> user = Rxn<BiodataModel>();
  final RxBool isLoading = false.obs;

  final box = GetStorage();
  final String _cacheKey = "cached_biodata";

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    final hasCache = _loadFromCache();
    if (!hasCache) {
      fetchUserData();
    } else {
      isLoading.value = false;
    }
  }

  bool _loadFromCache() {
    final cached = box.read(_cacheKey);
    if (cached == null) return false;

    try {
      user.value = BiodataModel.fromJson(
        cached is String ? jsonDecode(cached) : cached,
      );
      debugPrint('🟡 PROFIL DESA: loaded from cache');
      return true;
    } catch (e) {
      debugPrint('🔴 Cache error: $e');
      return false;
    }
  }

  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;

      final token = StorageService.getToken();
      if (token == null) return;

      final response = await DioService.instance.get(
        ApiConstant.biodata,
        options: dio.Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.data != null) {
        user.value = BiodataModel.fromJson(response.data);
        box.write(_cacheKey, response.data);
        debugPrint('🟢 PROFIL DESA: saved to cache');
      }

    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> requestVerification() async {
    try {
      isLoading.value = true;

      final token = StorageService.getToken();

      await DioService.instance.post(
        ApiConstant.biodata,
        options: dio.Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      await AppDialog.success(
        title: 'Berhasil',
        message:
            'Permintaan verifikasi telah dikirim. Admin desa akan memverifikasi dalam 1x24 jam.',
        buttonText: 'OK',
      );

      await fetchUserData();

    } catch (e) {
      AppDialog.error(
        title: 'Gagal',
        message: 'Gagal mengirim permintaan verifikasi',
        buttonText: 'Tutup',
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  String get nik => user.value?.nik ?? "-";
  String get nama => user.value?.namaLengkap ?? "-";
  String get tempatLahir => user.value?.tempatLahir ?? "-";
  String get tanggalLahir => user.value?.tanggalLahir ?? "-";
  String get alamat => user.value?.alamat ?? "-";
  String get agama => user.value?.agama ?? "-";
  String get pekerjaan => user.value?.pekerjaan ?? "-";
  String get statusPerkawinan => user.value?.statusPerkawinan ?? "-";
  String get kewarganegaraan => user.value?.kewarganegaraan ?? "-";
  String get golonganDarah => user.value?.golonganDarah ?? "-";
  String get berlakuHingga => user.value?.berlakuHingga ?? "-";
  String get avatar => user.value?.avatar ?? "-";
  String get jenisKelamin => user.value?.jenisKelamin ?? "-";

  bool get isVerified => user.value?.verification == "verified";
}
