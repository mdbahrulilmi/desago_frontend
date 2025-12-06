import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:remixicon/remixicon.dart';

import '../controllers/cek_bansos_controller.dart';

class CekBansosView extends GetView<CekBansosController> {
  const CekBansosView({super.key});
  
  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Cek Bansos',
          style: AppText.h5(color: AppColors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul utama
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'PENCARIAN DATA PM (PENERIMA MANFAAT) BANSOS',
                    style: AppText.bodyMedium(color: AppColors.white, ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              
              SizedBox(height: 24),
              
              // Wilayah PM
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'WILAYAH PM (Penerima Manfaat)',
                        style: AppText.bodyMedium(color: AppColors.dark, ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Dropdown Provinsi
                    Text(
                      'Provinsi',
                      style: AppText.bodyMedium(color: AppColors.dark),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedProvinsi.value.isEmpty ? null : controller.selectedProvinsi.value,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          border: InputBorder.none,
                          hintText: 'Pilih Provinsi',
                          hintStyle: AppText.bodyMedium(color: AppColors.grey),
                        ),
                        icon: Icon(Icons.keyboard_arrow_down, color: AppColors.dark),
                        items: controller.provinsiList.map((provinsi) {
                          return DropdownMenuItem<String>(
                            value: provinsi,
                            child: Text(provinsi, style: AppText.bodyMedium(color: AppColors.dark)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) controller.setProvinsi(value);
                        },
                      )),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Dropdown Kabupaten/Kota
                    Text(
                      'Kabupaten/Kota',
                      style: AppText.bodyMedium(color: AppColors.dark),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedKabupaten.value.isEmpty ? null : controller.selectedKabupaten.value,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          border: InputBorder.none,
                          hintText: 'Pilih Kabupaten/Kota',
                          hintStyle: AppText.bodyMedium(color: AppColors.grey),
                        ),
                        icon: Icon(Icons.keyboard_arrow_down, color: AppColors.dark),
                        items: controller.kabupatenList.map((kabupaten) {
                          return DropdownMenuItem<String>(
                            value: kabupaten,
                            child: Text(kabupaten, style: AppText.bodyMedium(color: AppColors.dark)),
                          );
                        }).toList(),
                        onChanged: controller.selectedProvinsi.value.isEmpty 
                          ? null 
                          : (value) {
                              if (value != null) controller.setKabupaten(value);
                            },
                      )),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Dropdown Kecamatan
                    Text(
                      'Kecamatan',
                      style: AppText.bodyMedium(color: AppColors.dark),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedKecamatan.value.isEmpty ? null : controller.selectedKecamatan.value,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          border: InputBorder.none,
                          hintText: 'Pilih Kecamatan',
                          hintStyle: AppText.bodyMedium(color: AppColors.grey),
                        ),
                        icon: Icon(Icons.keyboard_arrow_down, color: AppColors.dark),
                        items: controller.kecamatanList.map((kecamatan) {
                          return DropdownMenuItem<String>(
                            value: kecamatan,
                            child: Text(kecamatan, style: AppText.bodyMedium(color: AppColors.dark)),
                          );
                        }).toList(),
                        onChanged: controller.selectedKabupaten.value.isEmpty 
                          ? null 
                          : (value) {
                              if (value != null) controller.setKecamatan(value);
                            },
                      )),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Dropdown Kelurahan/Desa
                    Text(
                      'Kelurahan/Desa',
                      style: AppText.bodyMedium(color: AppColors.dark),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedDesa.value.isEmpty ? null : controller.selectedDesa.value,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          border: InputBorder.none,
                          hintText: 'Pilih Kelurahan/Desa',
                          hintStyle: AppText.bodyMedium(color: AppColors.grey),
                        ),
                        icon: Icon(Icons.keyboard_arrow_down, color: AppColors.dark),
                        items: controller.desaList.map((desa) {
                          return DropdownMenuItem<String>(
                            value: desa,
                            child: Text(desa, style: AppText.bodyMedium(color: AppColors.dark)),
                          );
                        }).toList(),
                        onChanged: controller.selectedKecamatan.value.isEmpty 
                          ? null 
                          : (value) {
                              if (value != null) controller.setDesa(value);
                            },
                      )),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24),
              
              // Input Nama PM
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nama PM',
                      style: AppText.bodyMedium(color: AppColors.dark),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: controller.namaPMController,
                        style: AppText.bodyMedium(color: AppColors.dark),
                        textCapitalization: TextCapitalization.characters, // Otomatis huruf besar
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: InputBorder.none,
                          hintText: 'Masukkan Nama Penerima Manfaat',
                          hintStyle: AppText.bodyMedium(color: AppColors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(Remix.close_line, color: AppColors.grey),
                            onPressed: () {
                              controller.namaPMController.clear();
                            },
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Tombol Cari
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => controller.cariPM(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: Icon(Remix.search_line, color: AppColors.white,),
                        label: Text(
                          'CARI',
                          style: AppText.button(color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}