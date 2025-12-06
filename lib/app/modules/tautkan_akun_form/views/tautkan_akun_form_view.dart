import 'dart:io';
import 'package:desago/app/models/AkunDesarMode.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../controllers/tautkan_akun_form_controller.dart';

class TautkanAkunFormView extends GetView<TautkanAkunFormController> {
  const TautkanAkunFormView({super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        title: Text(
          'Tautkan Akun',
          style: AppText.h5(color: AppColors.light),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.light,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppResponsive.padding(horizontal: 6, top: 2),
            child: Column(
              children: [
                // Header Section
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/img/logo.png',
                        width: AppResponsive.w(65),
                        height: AppResponsive.h(15),
                        fit: BoxFit.contain,
                      ),
                      Text(
                        'Silahkan isi formulir dibawah ini untuk mentautkan akun anda dengan desa yang anda pilih',
                        style: AppText.bodyLarge(color: AppColors.dark),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppResponsive.h(3)),

                // Form container dengan dekorasi box
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: AppResponsive.padding(all: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownSearch<AkunDesaModel>(
                        items: (filter, infiniteScrollProps) {
                          if (filter == null || filter.isEmpty) {
                            return controller.desaList;
                          }
                          return controller.desaList
                              .where((desa) =>
                                  desa.namaDesa
                                      .toLowerCase()
                                      .contains(filter.toLowerCase()) ||
                                  desa.provinsi
                                      .toLowerCase()
                                      .contains(filter.toLowerCase()) ||
                                  desa.kabupaten
                                      .toLowerCase()
                                      .contains(filter.toLowerCase()) ||
                                  desa.kecamatan
                                      .toLowerCase()
                                      .contains(filter.toLowerCase()))
                              .toList();
                        },
                        selectedItem: controller.selectedDesa.value,
                        onChanged: (AkunDesaModel? desa) {
                          if (desa != null) {
                            controller.selectedDesa.value = desa;
                            controller.namaDesaDipilih.text = desa.namaDesa;
                          }
                        },
                        compareFn: (AkunDesaModel item1, AkunDesaModel item2) {
                          return item1.id == item2.id;
                        },
                        itemAsString: (AkunDesaModel desa) =>
                            "${desa.namaDesa} - ${desa.kecamatan}, ${desa.kabupaten}",
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                            labelText: 'Pilih Desa',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              labelText: "Cari Desa",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                          fit: FlexFit.loose,
                          constraints: BoxConstraints(),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Tampilkan detail desa yang dipilih
                      Obx(() {
                        final selectedDesa = controller.selectedDesa.value;
                        if (selectedDesa == null) return SizedBox();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama Desa: ${selectedDesa.namaDesa}',
                              style: AppText.bodyMedium(color: AppColors.dark),
                              textAlign: TextAlign.justify,
                            ),
                            Text(
                              'Provinsi: ${selectedDesa.provinsi}',
                              style: AppText.bodyMedium(color: AppColors.dark),
                              textAlign: TextAlign.justify,
                            ),
                            Text(
                              'Kabupaten: ${selectedDesa.kabupaten}',
                              style: AppText.bodyMedium(color: AppColors.dark),
                              textAlign: TextAlign.justify,
                            ),
                            Text(
                              'Kecamatan: ${selectedDesa.kecamatan}',
                              style: AppText.bodyMedium(color: AppColors.dark),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        );
                      }),
                      SizedBox(height: AppResponsive.h(2)),
                      Text(
                        'Data Pribadi',
                        style: AppText.h6(color: AppColors.dark),
                      ),
                      SizedBox(height: AppResponsive.h(2)),

                      // Form NIK
                      TextFormField(
                        controller: controller.nikController,
                        style: AppText.bodyMedium(color: AppColors.dark),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'NIK',
                          hintStyle: AppText.bodyMedium(
                              color: AppColors.textSecondary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.grey),
                          ),
                          prefixIcon: Icon(Remix.passport_line,
                              color: AppColors.textSecondary),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                        ),
                        cursorColor: AppColors.grey,
                      ),
                      SizedBox(height: AppResponsive.h(3)),

                      // Form No KK
                      TextFormField(
                        controller: controller.kkController,
                        style: AppText.bodyMedium(color: AppColors.dark),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'No KK (Kartu Keluarga)',
                          hintStyle: AppText.bodyMedium(
                              color: AppColors.textSecondary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.grey),
                          ),
                          prefixIcon: Icon(Remix.id_card_line,
                              color: AppColors.textSecondary),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                        ),
                        cursorColor: AppColors.grey,
                      ),
                      SizedBox(height: AppResponsive.h(3)),

                      // Upload KTP
                      Text(
                        'Upload Foto KTP',
                        style: AppText.bodyMedium(color: AppColors.dark),
                      ),
                      SizedBox(height: AppResponsive.h(1)),

                      // Upload KTP Field
                      Obx(() => GestureDetector(
                            onTap: () => controller.showImageSourceDialog(true),
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(8),
                              color: controller.ktpImage.value != null
                                  ? AppColors.success
                                  : AppColors.grey,
                              strokeWidth: 1.5,
                              dashPattern: [6, 3],
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.muted,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: AppResponsive.padding(
                                    vertical: 3, horizontal: 3),
                                child: controller.ktpImage.value != null
                                    ? _buildImagePreview(
                                        controller.ktpImage.value!,
                                        controller.ktpFileName.value,
                                        () => controller.clearKtpImage(),
                                      )
                                    : _buildUploadBox(
                                        icon: Icons.file_upload_outlined,
                                        title: 'Pilih file KTP',
                                        subtitle:
                                            'Format: JPG, PNG | Maks: 2MB',
                                      ),
                              ),
                            ),
                          )),
                      SizedBox(height: AppResponsive.h(3)),

                      // Upload KK
                      Text(
                        'Upload Foto KK',
                        style: AppText.bodyMedium(color: AppColors.dark),
                      ),
                      SizedBox(height: AppResponsive.h(1)),

                      // Upload KK Field
                      Obx(() => GestureDetector(
                            onTap: () =>
                                controller.showImageSourceDialog(false),
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(8),
                              color: controller.kkImage.value != null
                                  ? AppColors.success
                                  : AppColors.grey,
                              strokeWidth: 1.5,
                              dashPattern: [6, 3],
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.muted,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: AppResponsive.padding(
                                    vertical: 3, horizontal: 3),
                                child: controller.kkImage.value != null
                                    ? _buildImagePreview(
                                        controller.kkImage.value!,
                                        controller.kkFileName.value,
                                        () => controller.clearKkImage(),
                                      )
                                    : _buildUploadBox(
                                        icon: Icons.file_upload_outlined,
                                        title: 'Pilih file KK',
                                        subtitle:
                                            'Format: JPG, PNG | Maks: 2MB',
                                      ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),

                SizedBox(height: AppResponsive.h(3)),

                // Tombol Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.submitDummyData(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: AppResponsive.padding(vertical: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Simpan',
                      style: AppText.button(color: AppColors.white),
                    ),
                  ),
                ),

                SizedBox(height: AppResponsive.h(4)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk preview gambar setelah dipilih
  Widget _buildImagePreview(
      File image, String fileName, VoidCallback onDelete) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.file(
                image,
                width: double.infinity,
                height: AppResponsive.h(20),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              margin: AppResponsive.margin(all: 1),
              child: IconButton(
                icon: Icon(Icons.close, color: AppColors.danger),
                onPressed: onDelete,
                iconSize: 20,
                padding: EdgeInsets.all(4),
                constraints: BoxConstraints(),
              ),
            ),
          ],
        ),
        SizedBox(height: AppResponsive.h(1)),
        Text(
          fileName,
          style: AppText.bodySmall(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // Widget untuk area upload
  Widget _buildUploadBox({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 40,
          color: AppColors.grey,
        ),
        SizedBox(height: AppResponsive.h(1)),
        Text(
          title,
          style: AppText.bodyMedium(color: AppColors.dark),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppResponsive.h(0.5)),
        Text(
          subtitle,
          style: AppText.bodySmall(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppResponsive.h(2)),
        Container(
          padding: AppResponsive.padding(horizontal: 3, vertical: 0.8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.grey),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.attach_file, size: 16, color: AppColors.primary),
              SizedBox(width: 4),
              Text(
                'Pilih File',
                style: AppText.bodySmall(color: AppColors.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
