import 'package:desago/app/models/LokerDesa.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LokerDesaDetailController extends GetxController {
  final isLoading = true.obs;
  final lokerDesa = Rxn<LokerDesa>();
  final String contactPhone = '+6281234567890';
  
  @override
  void onInit() {
    super.onInit();
    _loadLokerDesa();
  }
  
  void _loadLokerDesa() {
    try {
      final lokerData = Get.arguments?['loker'];
      
      if (lokerData == null) {
        isLoading.value = false;
        return;
      }
      lokerDesa.value = lokerData;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memuat data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  void hubungiPenyedia() async {
    try {
      final whatsappUrl = 'https://wa.me/$contactPhone?text=Halo, saya tertarik dengan lowongan "${lokerDesa.value?.judul}" di ${lokerDesa.value?.instansi}. Boleh saya mendapatkan informasi lebih lanjut?';
      
      final url = Uri.parse(whatsappUrl);
      
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        final telUrl = Uri.parse('tel:$contactPhone');
        if (await canLaunchUrl(telUrl)) {
          await launchUrl(telUrl);
        } else {
          Get.snackbar(
            'Gagal Terhubung',
            'Tidak dapat menghubungi penyedia lowongan',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}