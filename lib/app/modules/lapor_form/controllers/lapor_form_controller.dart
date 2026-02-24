import 'dart:io';
import 'package:desago/app/components/alert.dart';
import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/LaporKategoriModel.dart';
import 'package:desago/app/modules/lapor/controllers/lapor_controller.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/services/storage_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:dio/dio.dart' as dio;


class LaporFormController extends GetxController {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final LaporController laporController = Get.find<LaporController>();
  RxList<LaporKategoriModel> categories = <LaporKategoriModel>[].obs;
  var isLoading = true.obs;
  var isSubmitting = false.obs;
  final List<String> tujuanList = [
    'Pemerintah Desa',
    'Kepala Desa',
    'Perangkat Desa',
    'RT/RW',
    'Lainnya'
  ];
  final RxString selectedTujuan = RxString('');
  final RxInt selectedCategoryId = 0.obs;
  final RxString selectedCategoryName = ''.obs;

  @override
  void onInit() {
    fetchCategory();
    super.onInit();
  }

  @override
  void onClose() {
    judulController.dispose();
    deskripsiController.dispose();
    super.onClose();
  }

  Future<void> fetchCategory() async {
  try {
    isLoading.value = true;

    final token = await StorageService.getToken();

    final res = await DioService.instance.get(
      ApiConstant.laporKategori,
      options: dio.Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );


    final listData = res.data is List ? res.data : (res.data['data'] ?? []);

    categories.assignAll(
      listData.map<LaporKategoriModel>((e) => LaporKategoriModel.fromJson(e)).toList(),
    );
  } catch (e) {
  } finally {
    isLoading.value = false;
  }
}


Future<void> createLapor({
  required int kategoriId,
  required String judul,
  required String ditujukan,
  required String deskripsi,
  File? gambar,
}) async {
  if (!validateForm()) return;
  if (isSubmitting.value) return;
  final desaId = ApiConstant.desaId;
  final userId = await StorageService.getUser()?.id;
  try {
    isSubmitting.value = true;
    final formData = dio.FormData.fromMap({
      'desa_id': desaId,
      'kategori_id': kategoriId,
      'user_id': userId,
      'judul': judul,
      'ditujukan': ditujukan,
      'deskripsi': deskripsi,
      if (gambar != null)
        'gambar': await dio.MultipartFile.fromFile(
          gambar.path,
          filename: gambar.path.split('/').last,
        ),
    });

    final token = await StorageService.getToken();

    final response = await DioService.instance.post(
      ApiConstant.laporCreate,
      data: formData,
      options: dio.Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    Get.offNamed(
      Routes.LAPOR_RIWAYAT,
      arguments: {'refresh': true},
    );
  } on dio.DioException catch (e) {
    AppDialog.error(
      title: 'Gagal',
      message: 'Terjadi kesalahan saat mengirim laporan.\n${e.response?.data ?? e.message}',
    );
  } catch (e, st) {
    AppDialog.error(
      title: 'Gagal',
      message: 'Terjadi kesalahan saat mengirim laporan.\n$e',
    );
  } finally {
    isSubmitting.value = false;
  }
}



  bool validateForm() {
    if (judulController.text.trim().isEmpty) {
      _showValidationError('Judul laporan tidak boleh kosong');
      return false;
    }

    if (deskripsiController.text.trim().isEmpty) {
      _showValidationError('Deskripsi laporan tidak boleh kosong');
      return false;
    }

    if (laporController.imageFile.value == null) {
      _showValidationError('Silakan ambil foto terlebih dahulu');
      return false;
    }

    return true;
  }

  void _showValidationError(String message) {
    Get.snackbar(
      'Validasi',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.danger,
      colorText: Colors.white,
    );
  }
}
