import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/akun_pengaturan_controller.dart';

class AkunPengaturanView extends GetView<AkunPengaturanController> {
  const AkunPengaturanView({super.key});
 @override
  Widget build(BuildContext context) {
    // Inisialisasi AppResponsive
    AppResponsive().init(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundScaffold,
      appBar: AppBar(
        title: Text('Edit Profil', style: AppText.h5(color: AppColors.dark)),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.dark),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() => controller.isLoading.value
            ? Container(
                padding: AppResponsive.padding(right: 4),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              )
            : IconButton(
                icon: Icon(Icons.check, color: AppColors.primary),
                onPressed: controller.simpanPerubahan,
              ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppResponsive.padding(horizontal: 4, vertical: 2),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileImage(),
                SizedBox(height: AppResponsive.h(3)),
                _buildInputFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Column(
        children: [
          Obx(() => GestureDetector(
            onTap: controller.showImageSourceDialog,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: AppResponsive.w(15),
                  backgroundColor: AppColors.muted,
                  backgroundImage: controller.profileImage.value != null
                    ? FileImage(controller.profileImage.value!)
                    : null,
                  child: controller.profileImage.value == null
                    ? Text(
                        'JS',
                        style: AppText.h2(color: AppColors.primary),
                      )
                    : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: AppResponsive.padding(all: 1),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                    child: Icon(Icons.camera_alt, color: AppColors.white, size: 20),
                  ),
                ),
              ],
            ),
          )),
          SizedBox(height: AppResponsive.h(1)),
          Text(
            'Ubah Foto Profil',
            style: AppText.bodyMedium(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField(
          label: 'Nama Lengkap',
          hint: 'Masukkan nama lengkap',
          controller: controller.namaController,
          icon: Icons.person,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Nama tidak boleh kosong';
            }
            return null;
          },
        ),
        SizedBox(height: AppResponsive.h(2)),
        
        _buildInputField(
          label: 'Email',
          hint: 'Masukkan alamat email',
          controller: controller.emailController,
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email tidak boleh kosong';
            }
            if (!GetUtils.isEmail(value)) {
              return 'Format email tidak valid';
            }
            return null;
          },
        ),
        SizedBox(height: AppResponsive.h(2)),
        
        _buildInputField(
          label: 'No. Telepon',
          hint: 'Masukkan nomor telepon',
          controller: controller.teleponController,
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'No. Telepon tidak boleh kosong';
            }
            if (!GetUtils.isPhoneNumber(value)) {
              return 'Format no. telepon tidak valid';
            }
            return null;
          },
        ),
        SizedBox(height: AppResponsive.h(2)),
        
        _buildInputField(
          label: 'Alamat',
          hint: 'Masukkan alamat lengkap',
          controller: controller.alamatController,
          icon: Icons.location_on,
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Alamat tidak boleh kosong';
            }
            return null;
          },
        ),
        SizedBox(height: AppResponsive.h(4)),
        
        Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => controller.simpanPerubahan(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: AppResponsive.padding(vertical: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Obx(() => controller.isLoading.value 
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : Text('SIMPAN PERUBAHAN', style: AppText.button(color: AppColors.white)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppText.bodyLarge(color: AppColors.dark),
        ),
        SizedBox(height: AppResponsive.h(0.5)),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppText.bodyMedium(color: AppColors.textSecondary.withOpacity(0.7)),
            prefixIcon: Icon(icon, color: AppColors.primary),
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
        ),
      ],
    );
  }
}
