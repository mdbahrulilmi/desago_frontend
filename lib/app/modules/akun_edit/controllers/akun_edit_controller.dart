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
  final avatar = Rx<File?>(null); // file lokal sementara
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

      avatar.value = file; // update lokal, langsung tampil di UI
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

    Map<String, dynamic> data = {
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
    };

    dio.FormData formData;
    if (avatar.value != null) {
      final file = avatar.value!;
      final fileName = file.path.split('/').last;
      formData = dio.FormData.fromMap({
        ...data,
        'avatar': await dio.MultipartFile.fromFile(file.path, filename: fileName),
      });
    } else {
      formData = dio.FormData.fromMap(data);
    }

    final response = await DioService.instance.post(
      ApiConstant.updateAvatar,
      data: formData,
      options: dio.Options(headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }),
    );

    if (response.statusCode == 200 && response.data['status'] == true) {
      final updatedUser = UserModel.fromJson(response.data['data']);
      await StorageService.saveUser(updatedUser);
      akunController.user.value = updatedUser;
      akunController.user.refresh();

      avatar.value = null; // reset
      emailController.text = updatedUser.email ?? '';
      phoneController.text = updatedUser.phone ?? '';

      Get.back();
      Get.snackbar('Berhasil', 'Profil berhasil diperbarui', backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar('Gagal', response.data['message'] ?? 'Terjadi kesalahan', backgroundColor: Colors.red, colorText: Colors.white);
    }
  } catch (e) {
    Get.snackbar('Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
  } finally {
    isLoading.value = false;
  }
}


  void _showError(String message) {
    AppDialog.error(title: 'Error', message: message, buttonText: 'Tutup');
  }
}
