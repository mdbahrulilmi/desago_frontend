
import 'package:desago/app/models/DonasiModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DonasiController extends GetxController {
  // Controller untuk pencarian
  final cariDonasiController = TextEditingController();
  final cariDonasiText = ''.obs;

  // List donasi
  final semuaDonasi = <Donasi>[
    Donasi(
      id: '1',
      judul: 'Bantu Renovasi Mushola Desa',
      organisasi: 'Yayasan Peduli Desa',
      deskripsi: 'Membantu renovasi mushola desa yang rusak akibat bencana alam untuk keperluan ibadah warga desa',
      tanggalBerakhir: '30 Juni 2025',
      targetDonasi: 'Rp 50.000.000',
      terkumpul: 'Rp 35.750.000',
      gambar_donasi: 'assets/img/donasi_1.jpg',
    ),
    Donasi(
      id: '2',
      judul: 'Bantuan Air Bersih untuk Desa Kekeringan',
      organisasi: 'Gerakan Peduli Air',
      deskripsi: 'Membantu menyediakan air bersih untuk desa yang mengalami kekeringan dan kesulitan akses air bersih',
      tanggalBerakhir: '15 Juli 2025',
      targetDonasi: 'Rp 75.000.000',
      terkumpul: 'Rp 42.500.000',
      gambar_donasi: 'assets/img/donasi_2.jpeg',
    ),
  ].obs;

  // List donasi yang difilter
  final filteredDonasi = <Donasi>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Awalnya, semua donasi ditampilkan
    filteredDonasi.value = semuaDonasi;
  }

  void filterDonasi(String query) {
    cariDonasiText.value = query;
    
    if (query.isEmpty) {
      filteredDonasi.value = semuaDonasi;
    } else {
      filteredDonasi.value = semuaDonasi.where((donasi) => 
        donasi.judul.toLowerCase().contains(query.toLowerCase()) ||
        donasi.organisasi.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
  }

  @override
  void onClose() {
    // Dispose controller ketika tidak dibutuhkan lagi
    cariDonasiController.dispose();
    super.onClose();
  }

  Donasi? getDonasiById(String id) {
    try {
      return semuaDonasi.firstWhere((donasi) => donasi.id == id);
    } catch (e) {
      return null;
    }
  }
}