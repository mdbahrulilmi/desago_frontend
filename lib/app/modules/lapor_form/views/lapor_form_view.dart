import 'package:desago/app/constant/api_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/lapor_form_controller.dart';

class LaporFormView extends GetView<LaporFormController> {
  const LaporFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Form Laporan',
          style: AppText.h5(color: AppColors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(() {
                final image = controller.laporController.imageFile.value;
                return image != null
                    ? Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Foto Laporan',
                            style: AppText.bodyMedium(
                              color: AppColors.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : Container(
                        height: 200,
                        color: AppColors.grey.withOpacity(0.1),
                        child: Center(
                          child: Text(
                            'Tidak ada gambar',
                            style: AppText.bodyMedium(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
              }),
              const SizedBox(height: 24),
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedTujuan.value.isEmpty
                        ? null
                        : controller.selectedTujuan.value,
                    style: AppText.bodyMedium(color: AppColors.dark),
                    decoration: InputDecoration(
                      hintText: 'Ditujukan Ke',
                      hintStyle:
                          AppText.bodyMedium(color: AppColors.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.textSecondary),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.textSecondary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                    items: controller.tujuanList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: AppText.bodyMedium()),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      controller.selectedTujuan.value = newValue ?? '';
                    },
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down,
                        color: AppColors.textSecondary),
                  )),
              const SizedBox(height: 16),
              TextFormField(
                style: AppText.bodyMedium(color: AppColors.dark),
                controller: controller.judulController,
                decoration: InputDecoration(
                  hintText: 'Judul Laporan',
                  hintStyle: AppText.bodyMedium(color: AppColors.textSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.textSecondary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.textSecondary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                cursorColor: AppColors.dark,
              ),
              const SizedBox(height: 16),
              Obx(() => DropdownButtonFormField<int>(
                value: controller.selectedCategoryId.value != 0
                    ? controller.selectedCategoryId.value
                    : null,
                style: AppText.bodyMedium(color: AppColors.dark),
                decoration: InputDecoration(
                  hintText: 'Pilih Kategori',
                  hintStyle: AppText.bodyMedium(color: AppColors.textSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.textSecondary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.textSecondary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                items: controller.categories.map((e) {
                  return DropdownMenuItem<int>(
                    value: e['id'],
                    child: Text(e['name'], style: AppText.bodyMedium()),
                  );
                }).toList(),
                onChanged: (int? val) {
                  if (val != null) {
                    controller.selectedCategoryId.value = val;
                    controller.selectedCategoryName.value =
                        controller.categories.firstWhere((e) => e['id'] == val)['name'];
                  }
                },
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
              )),
              const SizedBox(height: 16),
              TextFormField(
                style: AppText.bodyMedium(color: AppColors.dark),
                controller: controller.deskripsiController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Deskripsi Laporan',
                  hintStyle: AppText.bodyMedium(color: AppColors.textSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.textSecondary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.textSecondary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                cursorColor: AppColors.dark,
              ),
              const SizedBox(height: 24),
              
             Obx(() => ElevatedButton(
                 onPressed: controller.isSubmitting.value
                  ? null
                  : ()=> controller.createLapor(
                  subdomain: ApiConstant.desa, 
                  title: controller.judulController.text,
                  category: controller.selectedCategoryId.value, 
                  ditujukan: controller.selectedTujuan.value,
                  description: controller.deskripsiController.text,
                  image: controller.laporController.imageFile.value,
                  ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isSubmitting.value
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                  'Kirim Laporan',
                  style: AppText.button(color: AppColors.white),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
