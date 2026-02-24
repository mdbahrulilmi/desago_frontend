import 'dart:io';
import 'package:desago/app/components/alert.dart';
import 'package:desago/app/components/bottom_sheet.dart';
import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/helpers/permission_helper.dart';
import 'package:desago/app/models/UserModel.dart';
import 'package:desago/app/modules/akun/controllers/akun_controller.dart';
import 'package:desago/app/services/Dio_services.dart';
import 'package:desago/app/services/storage_services.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AkunEditController extends GetxController {
  final akunController = Get.find<AkunController>();
  final user = Rxn<UserModel>();
  final avatar = Rx<File?>(null);
  late TextEditingController emailController;
  late TextEditingController phoneController;

  RxBool isLoading = false.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    user.value = akunController.user.value;
    emailController = TextEditingController(text: user.value?.email ?? '');
    phoneController = TextEditingController(text: user.value?.phone ?? '');
  }

  Future<void> pickAvatar() async {
    if (!await PermissionHelper.checkAndRequestGalleryPermissions()) return;
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (pickedFile == null) return;

      final File file = File(pickedFile.path);
      if (await file.length() > 2 * 1024 * 1024) {
        _showError('Ukuran file foto melebihi batas 2MB');
        return;
      }

      avatar.value = file;
    } catch (e) {
      _showError('Gagal memilih foto: $e');
    }
  }

  Future<void> captureAvatar() async {
    if (!await PermissionHelper.checkAndRequestCameraPermissions()) return;
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
      if (pickedFile == null) return;

      final File file = File(pickedFile.path);
      if (await file.length() > 2 * 1024 * 1024) {
        _showError('Ukuran file foto melebihi batas 2MB');
        return;
      }

      avatar.value = file;
    } catch (e) {
      _showError('Gagal mengambil foto: $e');
    }
  }

  void showAvatarOptions() {
    AppBottomSheet.avatarPicker(
      title: 'Ubah Foto Profil',
      message: 'Pilih sumber foto',
      onGallery: pickAvatar,
      onCamera: captureAvatar,
      galleryText: 'Galeri',
      cameraText: 'Kamera',
    );
  }

  Future<void> updateProfile() async {

  try {
    isLoading.value = true;
    final token = StorageService.getToken()?.trim();

    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Token tidak ditemukan');
      return;
    }

    final profileResponse = await DioService.instance.post(
      ApiConstant.editProfile,
      data: {
        'email': emailController.text.trim(),
        'no_telepon': phoneController.text.trim(),
      },
      options: dio.Options(headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }),
    );

    if (profileResponse.statusCode != 200 ||
        profileResponse.data['success'] != true) {
      Get.snackbar(
        'Gagal',
        profileResponse.data['message'] ?? 'Gagal update profil',
      );
      return;
    }

    if (avatar.value != null) {

      final file = avatar.value!;
      final fileName = file.path.split('/').last;

      final formData = dio.FormData.fromMap({
        'avatar': await dio.MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final avatarResponse = await DioService.instance.post(
        ApiConstant.updateAvatar,
        data: formData,
        options: dio.Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }),
      );

      if (avatarResponse.statusCode != 200 ||
          avatarResponse.data['status'] != true) {

        Get.snackbar(
          'Gagal',
          avatarResponse.data['message'] ?? 'Gagal update avatar',
        );
        return;
      }
      final updatedUser =
          UserModel.fromJson(avatarResponse.data['data']);

      await StorageService.saveUser(updatedUser);

      akunController.user.value = updatedUser;
      akunController.user.refresh();

    } else {

      final updatedUser =
          UserModel.fromJson(profileResponse.data['data']);

      await StorageService.saveUser(updatedUser);

      akunController.user.value = updatedUser;
      akunController.user.refresh();
    }

    avatar.value = null;
    Get.back();

    Get.snackbar(
      'Berhasil',
      'Profil berhasil diperbarui',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

  } on dio.DioException catch (e) {

    Get.snackbar(
      'Error',
      e.response?.data['message'] ?? 'Terjadi kesalahan server',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } catch (e) {

    Get.snackbar(
      'Error',
      e.toString(),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false;
  }
}

  void _showError(String message) {
    AppDialog.error(title: 'Error', message: message, buttonText: 'Tutup');
  }
}
