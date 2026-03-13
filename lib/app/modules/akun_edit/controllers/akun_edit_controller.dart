import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:desago/app/components/alert.dart';
import 'package:desago/app/components/bottom_sheet.dart';
import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/helpers/permission_helper.dart';
import 'package:desago/app/models/UserModel.dart';
import 'package:desago/app/modules/akun/controllers/akun_controller.dart';
import 'package:desago/app/services/Dio_services.dart';
import 'package:desago/app/services/storage_services.dart';
import 'package:desago/app/utils/app_colors.dart';

class AkunEditController extends GetxController {

  /// CONTROLLERS
  final akunController = Get.find<AkunController>();

  /// STATE
  final user = Rxn<UserModel>();
  final avatar = Rx<File?>(null);
  final isLoading = false.obs;

  late TextEditingController emailController;
  late TextEditingController phoneController;

  final ImagePicker _picker = ImagePicker();

  /// INIT
  @override
  void onInit() {
    super.onInit();

    user.value = akunController.user.value;

    emailController = TextEditingController(
      text: user.value?.email ?? '',
    );

    phoneController = TextEditingController(
      text: user.value?.phone ?? '',
    );
  }

  /// ===============================
  /// AVATAR PICKER
  /// ===============================

  Future<void> pickAvatar() async {
    if (!await PermissionHelper.checkAndRequestGalleryPermissions()) return;

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile == null) return;

      final File? croppedFile = await _cropImage(pickedFile.path);
      if (croppedFile == null) return;

      if (await croppedFile.length() > 2 * 1024 * 1024) {
        _showError('Ukuran file foto melebihi batas 2MB');
        return;
      }

      avatar.value = croppedFile;
    } catch (e) {
      _showError('Gagal memilih foto: $e');
    }
  }

  Future<void> captureAvatar() async {
  if (!await PermissionHelper.checkAndRequestCameraPermissions()) return;

  try {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (pickedFile == null) return;

    /// tampilkan loading
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final File? croppedFile = await _cropImage(pickedFile.path);

    Get.back(); // tutup loading

    if (croppedFile == null) return;

    if (await croppedFile.length() > 2 * 1024 * 1024) {
      _showError('Ukuran file foto melebihi batas 2MB');
      return;
    }

    avatar.value = croppedFile;

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

  /// ===============================
  /// UPDATE PROFILE
  /// ===============================

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;

      final token = StorageService.getToken()?.trim();

      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Token tidak ditemukan');
        return;
      }

      /// UPDATE DATA PROFILE
      final profileResponse = await DioService.instance.post(
        ApiConstant.editProfile,
        data: {
          'email': emailController.text.trim(),
          'no_telepon': phoneController.text.trim(),
        },
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (profileResponse.statusCode != 200 ||
          profileResponse.data['success'] != true) {
        Get.snackbar(
          'Gagal',
          profileResponse.data['message'] ?? 'Gagal update profil',
        );
        return;
      }

      /// UPDATE AVATAR JIKA ADA
      if (avatar.value != null) {
        await _uploadAvatar(token);
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

  /// ===============================
  /// UPLOAD AVATAR
  /// ===============================

  Future<void> _uploadAvatar(String token) async {
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
      options: dio.Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
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
  }

  /// ===============================
  /// IMAGE CROPPER
  /// ===============================

  Future<File?> _cropImage(String path) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 80,
      uiSettings: [

        AndroidUiSettings(
          toolbarTitle: 'Sesuaikan Foto',
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: AppColors.secondary,
          activeControlsWidgetColor: Colors.black,
          cropStyle: CropStyle.circle,
          lockAspectRatio: true,
          hideBottomControls: true,
          showCropGrid: false,
          initAspectRatio: CropAspectRatioPreset.square,
        ),

        IOSUiSettings(
          title: 'Sesuaikan Foto',
          cropStyle: CropStyle.circle,
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
          rotateButtonsHidden: true,
          rotateClockwiseButtonHidden: true,
        ),
      ],
    );

    if (cropped == null) return null;

    return File(cropped.path);
  }

  void _showError(String message) {
    AppDialog.error(
      title: 'Error',
      message: message,
      buttonText: 'Tutup',
    );
  }
}