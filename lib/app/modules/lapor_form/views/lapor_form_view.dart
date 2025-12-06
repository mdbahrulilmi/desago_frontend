import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_text.dart';
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
              ElevatedButton(
                onPressed: () => controller.kirimLaporan(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Kirim Laporan',
                  style: AppText.button(color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
