import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:desago/app/utils/app_colors.dart';

class PermissionHelper {
  static Future<bool> checkAndRequestCameraPermissions() async {
    final cameraStatus = await Permission.camera.request();
    if (cameraStatus != PermissionStatus.granted) {
      _showPermissionDeniedDialog('Kamera', 'mengambil foto');
      return false;
    }
    return true;
  }

  // Metode untuk memeriksa dan meminta izin galeri saja
  static Future<bool> checkAndRequestGalleryPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.isGranted) {
        return true;
      } else if (await Permission.photos.request().isGranted) {
        return true;
      }

      if (Platform.isAndroid && Platform.version.compareTo('33') < 0) {
        if (await Permission.storage.isGranted) {
          return true;
        } else {
          final status = await Permission.storage.request();
          if (status.isGranted) {
            return true;
          }
        }
      }
    }
    _showPermissionDeniedDialog('Galeri', 'akses foto dan video');
    return false;
  }

  static void _showPermissionDeniedDialog(
      String permissionName, String action) {
    Get.dialog(
      AlertDialog(
        title: Text('Izin $permissionName Diperlukan'),
        content:
            Text('Aplikasi membutuhkan izin $permissionName untuk $action. '
                'Mohon aktifkan izin di pengaturan perangkat Anda.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Tutup', style: TextStyle(color: AppColors.primary)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: Text('Buka Pengaturan',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
