import 'dart:io';
import 'package:desago/app/components/alert.dart';
import 'package:desago/app/modules/lapor/controllers/lapor_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:desago/app/utils/app_colors.dart';

class LaporFormController extends GetxController {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  final LaporController laporController = Get.find<LaporController>();

  final List<String> tujuanList = [
    'Pemerintah Desa',
    'Kepala Desa',
    'Perangkat Desa',
    'RT/RW',
    'Lainnya'
  ];

  final RxString selectedTujuan = RxString('');

  @override
  void onClose() {
    judulController.dispose();
    deskripsiController.dispose();
    super.onClose();
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

  void kirimLaporan() {
    if (validateForm()) {
      AppDialog.success(
        title: 'Berhasil',
        message: 'Laporan Berhasil Dikirim',
        buttonText: 'OK',
        onConfirm: () {
          Get.back();
        },
      );

      laporController.onClose();
    }
  }
}
