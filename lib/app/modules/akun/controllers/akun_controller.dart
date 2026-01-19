import 'dart:io';

import 'package:desago/app/components/alert.dart';
import 'package:desago/app/components/bottom_sheet.dart';
import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/helpers/permission_helper.dart';
import 'package:desago/app/models/UserModel.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/services/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

class AkunController extends GetxController {
  final user = Rxn<UserModel>();
  final avatar = Rx<File?>(null);

  final isNotificationActive = true.obs;
  final avatarFileName = ''.obs;

  final ImagePicker _picker = ImagePicker();

  void toggleNotification(bool value) {
    isNotificationActive.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final userData = await StorageService.getUser();
      if (userData != null) {
        user.value = userData;
      } else {
        print('No user data found');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> logout() async {
    final bool? confirmed = await AppDialog.ask(
      title: 'Konfirmasi Logout',
      message: 'Apakah Anda yakin ingin keluar dari akun?',
      confirmText: 'Ya, Keluar',
      cancelText: 'Batal',
    );
    if (confirmed != true) return;

    try {
      final response = await DioService.instance.post(
        ApiConstant.logout,
      );

      if (response.statusCode == 200) {
        await StorageService.clearStorage();
        await AppDialog.success(
          title: 'Logout Berhasil',
          message: 'Anda berhasil keluar dari akun.',
          buttonText: 'OK',
          onConfirm: () {
            Get.offAllNamed(Routes.LOGIN);
          },
        );
      } else {
        AppDialog.error(
          title: 'Gagal Logout',
          message: 'Gagal logout, silakan coba lagi.',
          buttonText: 'Tutup',
        );
      }
    } catch (e) {
      AppDialog.error(
        title: 'Terjadi Kesalahan',
        message: 'Terjadi kesalahan saat logout',
        buttonText: 'Tutup',
      );
    }
  }
}
