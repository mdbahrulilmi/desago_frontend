import 'dart:io';

import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AkunPengaturanController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxString imagePath = ''.obs;
  final RxBool isLoading = false.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // Load data pengguna (simulasi)
    namaController.text = 'Joko Susilo';
    emailController.text = 'jokosusilo@example.com';
    teleponController.text = '081234567890';
    alamatController.text = 'Jl. Raya Pringsurat No. 10, Temanggung, Jawa Tengah';
  }

  @override
  void onClose() {
    namaController.dispose();
    emailController.dispose();
    teleponController.dispose();
    alamatController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    
    if (image != null) {
      profileImage.value = File(image.path);
      imagePath.value = image.path;
    }
  }

  Future<void> captureImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    
    if (image != null) {
      profileImage.value = File(image.path);
      imagePath.value = image.path;
    }
  }

  void showImageSourceDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Pilih Sumber Gambar', style: AppText.h5(color: AppColors.dark)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.primary),
              title: Text('Galeri', style: AppText.bodyLarge(color: AppColors.dark)),
              onTap: () {
                Get.back();
                pickImage();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.primary),
              title: Text('Kamera', style: AppText.bodyLarge(color: AppColors.dark)),
              onTap: () {
                Get.back();
                captureImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> simpanPerubahan() async {
    if (!formKey.currentState!.validate()) return;
    
    try {
      isLoading.value = true;
      
      // Simulasi proses penyimpanan
      await Future.delayed(const Duration(seconds: 2));
      
      Get.snackbar(
        'Sukses',
        'Data akun berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: AppColors.white,
      );
      
      // Kembali ke halaman sebelumnya
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan perubahan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
