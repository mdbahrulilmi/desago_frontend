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
      print('User Data Details from Storage:');
      print('Name: ${userData.name}');
      print('Email: ${userData.email}');
      print('Avatar: ${userData.avatar}');
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

  void onLogin()async{
    final bool? confirmed = await AppDialog.ask(
      title: 'Konfirmasi Logout',
      message: 'Apakah Anda yakin ingin keluar dari akun?',
      confirmText: 'Ya, Keluar',
      cancelText: 'Batal',
    );
    if (confirmed != true) return;
    Get.offAllNamed(Routes.LOGIN);
  }

  // Fungsi untuk memilih foto KTP
  Future<void> pickAvatar() async {
    bool hasPermission =
        await PermissionHelper.checkAndRequestGalleryPermissions();
    if (!hasPermission) return;

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        final File file = File(pickedFile.path);
        final int fileSize = await file.length();

        if (fileSize > 2 * 1024 * 1024) {
          _showError('Ukuran file foto melebihi batas 2MB');
          return;
        }

        final String fileName = pickedFile.name.toLowerCase();
        if (!fileName.endsWith('.jpg') &&
            !fileName.endsWith('.jpeg') &&
            !fileName.endsWith('.png')) {
          _showError('Format file foto tidak didukung. Gunakan JPG atau PNG');
          return;
        }

        avatar.value = file;
        avatarFileName.value = pickedFile.name;

        final bool? confirm = await AppDialog.ask(
          title: 'Konfirmasi',
          message:
              'Apakah Anda ingin menggunakan foto ini sebagai foto profil?',
          confirmText: 'Ya, Gunakan',
          cancelText: 'Batal',
        );

        if (confirm == true) {
          await uploadAvatar();
        }
      }
    } catch (e) {
      AppDialog.error(
        title: 'Error',
        message: 'Gagal memilih foto: ${e.toString()}',
        buttonText: 'Tutup',
      );
    }
  }

  // Fungsi untuk memilih foto KTP dari kamera
  Future<void> captureAvatar() async {
    bool hasPermission =
        await PermissionHelper.checkAndRequestCameraPermissions();
    if (!hasPermission) return;

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        final File file = File(pickedFile.path);
        final int fileSize = await file.length();

        if (fileSize > 2 * 1024 * 1024) {
          AppDialog.error(
            title: 'Error',
            message: 'Ukuran file melebihi batas 2MB',
            buttonText: 'Tutup',
          );
          return;
        }

        avatar.value = file;
        avatarFileName.value = "avatar_photo.jpg";

        final bool? confirm = await AppDialog.ask(
          title: 'Konfirmasi',
          message:
              'Apakah Anda ingin menggunakan foto ini sebagai foto profil?',
          confirmText: 'Ya, Gunakan',
          cancelText: 'Batal',
        );

        if (confirm == true) {
          await uploadAvatar();
        }
      }
    } catch (e) {
      AppDialog.error(
        title: 'Error',
        message: 'Gagal mengambil foto: ${e.toString()}',
        buttonText: 'Tutup',
      );
    }
  }

Future<void> uploadAvatar() async {
  if (avatar.value == null) {
    AppDialog.error(
      title: 'Error',
      message: 'Tidak ada foto yang dipilih',
      buttonText: 'Tutup',
    );
    return;
  }

  try {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final file = avatar.value!;
    final fileName = file.path.split('/').last;

    if (fileName.isEmpty) {
      throw Exception('Filename kosong');
    }

    final formData = dio.FormData.fromMap({
      'avatar': await dio.MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    final token = StorageService.getToken()?.trim();
    print("ini response $formData");

    final response = await DioService.instance.post(
      ApiConstant.updateAvatar,
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );


    Get.back();

    if (response.statusCode == 200 && response.data['status'] == true) {
      final updatedUser = UserModel.fromJson(response.data['data']);
      await StorageService.saveUser(updatedUser);
      user.value = updatedUser;

      AppDialog.success(
        title: 'Berhasil',
        message: 'Foto profil berhasil diperbarui',
        buttonText: 'OK',
      );

      avatar.value = null;
    } else {
      AppDialog.error(
        title: 'Gagal',
        message: response.data['message'] ?? 'Upload gagal',
        buttonText: 'Tutup',
      );
    }
  } catch (e) {
    if (Get.isDialogOpen == true) Get.back();

    print('Upload Error: $e');
    AppDialog.error(
      title: 'Error',
      message: e.toString(),
      buttonText: 'Tutup',
    );
  }
}

  void showAvatarOptions() {
    AppBottomSheet.avatarPicker(
      title: 'Ubah Foto Profil',
      message: 'Pilih sumber foto profil Anda',
      onGallery: () {
        pickAvatar();
      },
      onCamera: () {
        captureAvatar();
      },
      galleryText: 'Galeri',
      cameraText: 'Kamera',
    );
  }

  void _showError(String message) {
    AppDialog.error(
      title: 'Error',
      message: message,
      buttonText: 'Tutup',
    );
  }
}
