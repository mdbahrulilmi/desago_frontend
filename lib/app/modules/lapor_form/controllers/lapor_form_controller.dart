import 'dart:io';
import 'package:desago/app/components/alert.dart';
import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/modules/lapor/controllers/lapor_controller.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:dio/dio.dart' as dio;


class LaporFormController extends GetxController {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  final LaporController laporController = Get.find<LaporController>();
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;


  var isLoading = true.obs;

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

    final res = await DioService.instance.get(ApiConstant.laporKategori);

    final listData = res.data is List ? res.data : (res.data['data'] ?? []);

    categories.assignAll(
      listData.map<Map<String, dynamic>>((e) => {
        'id': e['no'],
        'name': e['name'],
      }).toList(),
    );

    print('ini kategori: $categories');
  } catch (e) {
    debugPrint(e.toString());
  } finally {
    isLoading.value = false;
  }
}


Future<void> createLapor({
  required String subdomain,
  required String ditujukan,
  required String title,
  required int category,
  required String description,
  File? image,
  }) async {
    if (!validateForm()) return;

    try {
      final formData = dio.FormData.fromMap({
        'subdomain': subdomain,
        'ditujukan': ditujukan,
        'title': title,
        'category': category,
        'description': description,
        if (image != null)
          'image': await dio.MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
      });

      await DioService.instance.post(
        ApiConstant.laporCreate,
        data: formData,
      );

      AppDialog.success(
        title: 'Berhasil',
        message: 'Laporan Berhasil Dikirim',
        buttonText: 'OK',
        onConfirm: () {
          Get.back(); 
          Get.offNamed(Routes.LAPOR_RIWAYAT);
        },
      );
    } catch (e) {
      // Jika gagal, tampilkan error
      AppDialog.error(
        title: 'Gagal',
        message: 'Terjadi kesalahan saat mengirim laporan.',
      );
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
