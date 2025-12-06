import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/akun_ubah_password_controller.dart';

class AkunUbahPasswordView extends GetView<AkunUbahPasswordController> {
  const AkunUbahPasswordView({super.key});
  
  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundScaffold,
      appBar: AppBar(
        title: Text('Ubah Password', style: AppText.h5(color: AppColors.dark)),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.dark),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: AppResponsive.padding(horizontal: 4, vertical: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan ilustrasi
                _buildHeader(),
                SizedBox(height: AppResponsive.h(4)),
                
                // Form Password Lama
                _buildPasswordField(
                  label: 'Password Lama',
                  hint: 'Masukkan password lama Anda',
                  controller: controller.oldPasswordController,
                  isVisible: controller.isOldPasswordVisible,
                  toggleVisibility: controller.toggleOldPasswordVisibility,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password lama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppResponsive.h(3)),
                
                // Form Password Baru
                _buildPasswordField(
                  label: 'Password Baru',
                  hint: 'Masukkan password baru',
                  controller: controller.newPasswordController,
                  isVisible: controller.isNewPasswordVisible,
                  toggleVisibility: controller.toggleNewPasswordVisibility,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password baru tidak boleh kosong';
                    }
                    if (value.length < 8) {
                      return 'Password minimal 8 karakter';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppResponsive.h(1)),
                
                // Info password baru
                Padding(
                  padding: AppResponsive.padding(horizontal: 1),
                  child: Text(
                    'Password harus minimal 8 karakter dengan kombinasi huruf dan angka',
                    style: AppText.small(color: AppColors.textSecondary),
                  ),
                ),
                SizedBox(height: AppResponsive.h(3)),
                
                // Form Konfirmasi Password Baru
                _buildPasswordField(
                  label: 'Konfirmasi Password Baru',
                  hint: 'Masukkan ulang password baru',
                  controller: controller.confirmPasswordController,
                  isVisible: controller.isConfirmPasswordVisible,
                  toggleVisibility: controller.toggleConfirmPasswordVisibility,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi password tidak boleh kosong';
                    }
                    if (value != controller.newPasswordController.text) {
                      return 'Konfirmasi password tidak sama dengan password baru';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppResponsive.h(5)),
                
                // Tombol Simpan
                Container(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value 
                      ? null 
                      : controller.changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: AppResponsive.padding(vertical: 1.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                    ),
                    child: controller.isLoading.value
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : Text(
                          'UBAH PASSWORD',
                          style: AppText.button(color: AppColors.white),
                        ),
                  )),
                ),
                
                SizedBox(height: AppResponsive.h(2)),
                
                // Tombol Batal
                Container(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: AppResponsive.padding(vertical: 1.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: AppColors.textSecondary)
                      ),
                    ),
                    child: Text(
                      'BATAL',
                      style: AppText.button(color: AppColors.textSecondary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ilustrasi (asumsi menggunakan lottie atau gambar)
        Center(
          child: Container(
            height: AppResponsive.h(20),
            width: AppResponsive.w(60),
            child: Icon(
              Remix.lock_password_line,
              size: AppResponsive.w(25),
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(height: AppResponsive.h(2)),
        
        // Judul dan deskripsi
        Text(
          'Ubah Password',
          style: AppText.h4(color: AppColors.dark),
        ),
        SizedBox(height: AppResponsive.h(1)),
        Text(
          'Buat password baru yang kuat dan berbeda dari password sebelumnya untuk meningkatkan keamanan akun Anda.',
          style: AppText.bodyMedium(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required RxBool isVisible,
    required Function toggleVisibility,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppText.bodyLarge(color: AppColors.dark),
        ),
        SizedBox(height: AppResponsive.h(1)),
        Obx(() => TextFormField(
          controller: controller,
          obscureText: !isVisible.value,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppText.bodyMedium(color: AppColors.textSecondary.withOpacity(0.7)),
            prefixIcon: Icon(Remix.lock_line, color: AppColors.primary),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible.value ? Remix.eye_line : Remix.eye_off_line,
                color: AppColors.textSecondary,
              ),
              onPressed: () => toggleVisibility(),
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: AppResponsive.padding(vertical: 1.5, horizontal: 2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.muted),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.muted),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.danger),
            ),
          ),
        )),
      ],
    );
  }
}