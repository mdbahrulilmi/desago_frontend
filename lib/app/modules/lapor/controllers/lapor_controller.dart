import 'dart:io';
import 'package:desago/app/routes/app_pages.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<void> captureLaporImage() async {
  bool hasPermission = await _checkAndRequestCameraPermissions();
  if (!hasPermission) return;

  try {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100, // 🔥 jangan kompres dari kamera dulu
    );

    if (pickedFile == null) return;

    final originalFile = File(pickedFile.path);
    File file = originalFile;

    int sizeKB = file.lengthSync() ~/ 1024;
    final dir = await getTemporaryDirectory();

    print("ORIGINAL: $sizeKB KB");

    // =========================
    // 🔹 SOFT MODE
    // =========================
    if (sizeKB > 200) {
      final targetPath =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}_soft.jpg';

      final result = await FlutterImageCompress.compressAndGetFile(
        originalFile.path, // 🔥 selalu dari original
        targetPath,
        quality: 65,
        format: CompressFormat.jpeg,
      );

      if (result != null) {
        file = File(result.path);
        sizeKB = file.lengthSync() ~/ 1024;
        print("SOFT: $sizeKB KB");
      }
    }

    // =========================
    // 🔥 BRUTAL MODE
    // =========================
    if (sizeKB > 150) {
      int width = 800;

      while (width >= 250) {
        final targetPath =
            '${dir.path}/${DateTime.now().millisecondsSinceEpoch}_brutal_$width.jpg';

        final result = await FlutterImageCompress.compressAndGetFile(
          originalFile.path,
          targetPath,
          quality: 50,
          minWidth: width,
          format: CompressFormat.jpeg,
        );

        if (result == null) break;

        file = File(result.path);
        sizeKB = file.lengthSync() ~/ 1024;

        print("BRUTAL width $width → $sizeKB KB");

        if (sizeKB <= 100) break;

        width -= 100;
      }
    }

    print("FINAL: $sizeKB KB");

    imageFile.value = file;
    Get.toNamed(Routes.LAPOR_FORM);

  } catch (e) {
    _showError('Gagal mengambil foto: ${e.toString()}');
  }
}
  
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.danger,
      colorText: Colors.white,
    );
  }
  
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