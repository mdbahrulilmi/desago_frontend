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
    // Tampilkan loading
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );

    // Siapkan FormData dari dio package
    final formData = dio.FormData.fromMap({
      'avatar': await dio.MultipartFile.fromFile(
        avatar.value!.path,
        filename: avatarFileName.value,
      ),
    });

    // Upload ke server
    final response = await DioService.instance.post(
      ApiConstant.updateAvatar,
      data: formData,
    );

    // Tutup dialog loading
    Get.back();

    // Log respons lengkap untuk debugging
    print('Server response: ${response.data}');

    if (response.statusCode == 200) {
      // Update user data dengan data terbaru dari server
      if (response.data['status'] == true && response.data['data'] != null) {
        try {
          // Log data user dari server untuk debugging
          print('User data from server: ${response.data['data']}');
          
          // Parse user data
          final UserModel updatedUser = UserModel.fromJson(response.data['data']);
          
          // Log user data yang sudah di-parse
          print('Parsed user data: ${updatedUser.toJson()}');
          
          // Simpan ke storage
          await StorageService.saveUser(updatedUser);
          
          // Update state
          user.value = updatedUser;
          update();
          
          // Verifikasi data tersimpan dengan benar
          final storedUser = StorageService.getUser();
          print('User data after storage: ${storedUser?.toJson()}');
        } catch (parseError) {
          print('Error parsing user data: $parseError');
          AppDialog.error(
            title: 'Error',
            message: 'Terjadi kesalahan saat memproses data: $parseError',
            buttonText: 'Tutup',
          );
          return;
        }
      }

      // Tampilkan pesan sukses
      AppDialog.success(
        title: 'Berhasil',
        message: 'Foto profil berhasil diperbarui',
        buttonText: 'OK',
      );
      avatar.value = null;
      avatarFileName.value = '';
    } else {
      AppDialog.error(
        title: 'Gagal',
        message: response.data['message'] ?? 'Terjadi kesalahan saat mengunggah foto',
        buttonText: 'Tutup',
      );
    }
  } catch (e) {
    print('Upload Error: $e');
    
    if (Get.isDialogOpen == true) {
      Get.back();
    }

    AppDialog.error(
      title: 'Error',
      message: 'Terjadi kesalahan: ${e.toString()}',
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
