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
      backgroundColor: AppColors.secondary,
      body:   Column(
  children: [
    _buildHeader(),
    Expanded(
      child: SingleChildScrollView(
        padding: AppResponsive.padding(horizontal: 4, vertical: 3),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  Obx(() {
                    final isOauth = controller.isOauth.value;

                    return isOauth
                        ?const SizedBox()
                        : _buildPasswordField(
                            label: "Kata sandi saat ini",
                            controller: controller.oldPasswordController,
                            isVisible: controller.isOldPasswordVisible,
                            toggleVisibility: controller.toggleOldPasswordVisibility,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password lama tidak boleh kosong';
                              }
                              return null;
                            },
                          );
                  }),

                  SizedBox(height: AppResponsive.h(3)),
                  _buildPasswordField(
                    label: "Kata sandi baru",
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
                  
                  Padding(
                    padding: AppResponsive.padding(horizontal: 4),
                    child: Text(
                      'Password harus minimal 8 karakter dengan kombinasi huruf dan angka',
                      style: AppText.small(color: AppColors.textSecondary),
                    ),
                  ),
                  SizedBox(height: AppResponsive.h(3)),
                  
                  _buildPasswordField(
                    label: "Konfirmasi kata sandi",
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
                  Container(
                    margin: AppResponsive.padding(horizontal: 8),
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
                  Container(
                    margin: AppResponsive.padding(horizontal: 8),
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
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
        children: [
          SizedBox(
            height: 210,
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      automaticallyImplyLeading: false,
                      expandedHeight: 160.5,
                      floating: false,
                      pinned: true,
                      leading: Padding(
                            padding: EdgeInsets.all(AppResponsive.w(2)),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                                onPressed: () => Get.back(),
                              ),
                            ),
                          ),
                      title: Text("Ubah Kata Sandi",
                      style: AppText.h5(color: AppColors.white)),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset('assets/background/akun_saya.png',
                            fit: BoxFit.contain),
                          ],
                        )),
                    ),
                  ],
                ),]))
                ]);
}

 Widget _buildPasswordField({
  required String label,
  required TextEditingController controller,
  required RxBool isVisible,
  required Function toggleVisibility,
  required String? Function(String?) validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Obx(() => Padding(
        padding: AppResponsive.padding(horizontal: 3),
        child: TextFormField(
              controller: controller,
              obscureText: !isVisible.value,
              validator: validator,
              style: AppText.bodyMedium(color: AppColors.text),
              decoration: InputDecoration(
                    label: Text("$label"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.muted),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.muted),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  cursorColor: AppColors.dark,
                ),
      )),
    ],
  );
}
}