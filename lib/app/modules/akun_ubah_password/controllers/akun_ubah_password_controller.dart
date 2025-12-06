import 'package:desago/app/components/alert.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AkunUbahPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  final RxBool isLoading = false.obs;
  final RxBool isOldPasswordVisible = false.obs;
  final RxBool isNewPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  
  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
  
  void toggleOldPasswordVisibility() {
    isOldPasswordVisible.value = !isOldPasswordVisible.value;
  }
  
  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }
  
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
  
  Future<void> changePassword() async {
    if (!formKey.currentState!.validate()) return;
    
    // Validasi password baru dan konfirmasi harus sama
    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Password baru dan konfirmasi password tidak sama',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
      );
      return;
    }
    
    try {
      isLoading.value = true;
      
      // Simulasi proses API
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulasi sukses
      await AppDialog.success(
        title: 'Berhasil',
        message: 'Password Anda berhasil diubah',
        buttonText: 'OK',
        onConfirm: () {
          clearForm();
          Get.back();
        }
      );
    } catch (e) {
      AppDialog.error(
        title: 'Gagal',
        message: 'Gagal mengubah password: ${e.toString()}',
        buttonText: 'Tutup',
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  void clearForm() {
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }
}