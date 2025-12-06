import 'package:desago/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuratListKategoriController extends GetxController {
  final isLoading = false.obs;
  final count = 0.obs;
  final currentCardIndex = 0.obs;
  
  // Daftar pengajuan surat yang sedang diproses
  final pengajuanSuratList = [].obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchPengajuanSurat();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Fetch pengajuan surat data
  void fetchPengajuanSurat() {
  isLoading.value = true;
  
  // Simulate network delay
  Future.delayed(Duration(seconds: 1), () {
    pengajuanSuratList.value = [
      {
        'id': 1,
        'title': 'Surat Keterangan Domisili (Non Warga)',
        'status': 'Diproses',
        'description': 'Pengajuan surat ini sedang diproses oleh pihak Kelurahan. Silahkan ditunggu ya 👍',
        'date': '10 Okt 2021 12:08'
      },
      {
        'id': 2,
        'title': 'Surat Pengantar KTP',
        'status': 'Selesai',
        'description': 'Surat pengantar sudah selesai. Silahkan ambil di kantor Kelurahan.',
        'date': '05 Okt 2021 09:15'
      },
      {
        'id': 3,
        'title': 'Surat Keterangan Usaha',
        'status': 'Diterima',
        'description': 'Pengajuan anda sudah diterima dan sedang diproses.',
        'date': '08 Okt 2021 14:30'
      }
    ];
    isLoading.value = false;
  });
}
  
  void navigateToSuratKeterangan() {
  Get.toNamed('/surat-list-jenis', arguments: {
    'kategoriId': 'keterangan',
    'kategoriTitle': 'Surat Keterangan'
  });
}

void navigateToSuratPengantar() {
  Get.toNamed('/surat-list-jenis', arguments: {
    'kategoriId': 'pengantar',
    'kategoriTitle': 'Surat Pengantar'
  });
}

void navigateToSuratRekomendasi() {
  Get.toNamed('/surat-list-jenis', arguments: {
    'kategoriId': 'rekomendasi',
    'kategoriTitle': 'Surat Rekomendasi'
  });
}

void navigateToSuratLainnya() {
  Get.toNamed('/surat-list-jenis', arguments: {
    'kategoriId': 'lainnya',
    'kategoriTitle': 'Surat Lainnya'
  });
}

 
}