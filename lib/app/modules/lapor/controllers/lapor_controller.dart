import 'dart:io';
import 'package:desago/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';

class LaporController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final Rx<File?> imageFile = Rx<File?>(null);

  @override
  void onClose() {
    imageFile.value = null;
    super.onClose();
  }

  Future<bool> _checkAndRequestCameraPermissions() async {
    var status = await Permission.camera.status;
    
    if (status.isDenied) {
      status = await Permission.camera.request();
    }
    
    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      return false;
    }
    
    return status.isGranted;
  }

  // Metode untuk mengambil foto laporan
  Future<void> captureLaporImage() async {
    // Periksa izin kamera
    bool hasPermission = await _checkAndRequestCameraPermissions();
    if (!hasPermission) return;

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        final File file = File(pickedFile.path);
        final int fileSize = await file.length();
        
        // Validasi ukuran file
        if (fileSize > 2 * 1024 * 1024) {
          _showError('Ukuran file melebihi batas 2MB');
          return;
        }

        // Simpan file
        imageFile.value = file;

        // Navigasi ke form laporan
        Get.toNamed(Routes.LAPOR_FORM);
      }
    } catch (e) {
      _showError('Gagal mengambil foto: ${e.toString()}');
    }
  }
  
  // Metode untuk menampilkan error
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.danger,
      colorText: Colors.white,
    );
  }
  
  // Metode untuk menampilkan dialog izin ditolak
  void _showPermissionDeniedDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Izin Kamera Diperlukan'),
        content: const Text(
          'Aplikasi membutuhkan izin kamera untuk mengambil foto laporan. '
          'Silakan berikan izin kamera di pengaturan aplikasi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: const Text('Buka Pengaturan'),
          ),
        ],
      ),
    );
  }
}