import 'dart:io';
import 'package:desago/app/modules/tautkan_akun/controllers/tautkan_akun_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import '../controllers/tautkan_akun_form_controller.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';

class TautkanAkunFormView extends StatelessWidget {
  const TautkanAkunFormView({super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);

    final controller = Get.find<TautkanAkunController>();
    final formController = Get.put(TautkanAkunFormController());

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Tautkan Akun',
          style: AppText.h5(color: AppColors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: AppResponsive.padding(horizontal: 6, vertical: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Form Data KTP", style: AppText.h5(color: AppColors.dark)),
            SizedBox(height: AppResponsive.h(2)),

            _buildField("Nama Lengkap", formController.namaController),
            _buildField("NIK", formController.nikController, keyboardType: TextInputType.number),
            _buildField("Tempat Lahir", formController.tempatLahirController),
            _buildField("Tanggal Lahir", formController.tanggalLahirController),
            _buildField("Jenis Kelamin", formController.jenisKelaminController),
            _buildField("Golongan Darah", formController.golonganDarahController),
            _buildField("Agama", formController.agamaController),
            _buildField("Status Perkawinan", formController.statusPerkawinanController),
            _buildField("Pekerjaan", formController.pekerjaanController),
            _buildField("Kewarganegaraan", formController.kewarganegaraanController),
            _buildField("Alamat", formController.alamatController, maxLines: 3),
            Text("Upload Foto KTP"),
            SizedBox(height: AppResponsive.h(1)),
            Obx(() => GestureDetector(
              onTap: () => formController.pickImage(true),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(8),
                color: AppColors.grey,
                strokeWidth: 1.5,
                dashPattern: [6, 3],
                child: Container(
                  width: double.infinity,
                  height: AppResponsive.h(20),
                  color: AppColors.muted,
                  child: formController.ktpImage.value == null
                      ? Icon(Icons.file_upload_outlined)
                      : Center(
                          child: Image.file(
                            formController.ktpImage.value!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
            )),
            SizedBox(height: AppResponsive.h(4)),

            Text("Form Data KK", style: AppText.h5(color: AppColors.dark)),
            SizedBox(height: AppResponsive.h(2)),

            _buildField("No KK", formController.nokkController, keyboardType: TextInputType.number),
            Obx(() => GestureDetector(
              onTap: () => formController.pickImage(false),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(8),
                color: AppColors.grey,
                strokeWidth: 1.5,
                dashPattern: [6, 3],
                child: Container(
                  width: double.infinity,
                  height: AppResponsive.h(20),
                  color: AppColors.muted,
                  child: formController.kkImage.value == null
                      ? Icon(Icons.file_upload_outlined)
                      : Center(
                          child: Image.file(
                            formController.kkImage.value!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
            )),

            SizedBox(height: AppResponsive.h(2)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => formController.submit(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("Simpan", style: AppText.bodyMediumBold(color: AppColors.secondary)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: AppText.bodyMedium(color: AppColors.dark),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
