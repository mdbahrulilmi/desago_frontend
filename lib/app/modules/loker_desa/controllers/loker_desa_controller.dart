import 'package:desago/app/models/LokerDesa.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LokerDesaController extends GetxController {
  // Search controller
  final cariLokerDesaController = TextEditingController();
  final cariLokerDesaText = ''.obs;

  // List of job vacancies
  final semuaLokerDesa = <LokerDesa>[
    LokerDesa(
      id: '1',
      judul: 'Staf Administrasi Desa',
      instansi: 'Pemerintah Desa Sejahtera',
      deskripsi: 'Mencari staf administrasi untuk membantu kegiatan perkantoran desa',
      batasPendaftaran: '30 Juni 2024',
      persyaratan: 'S1, Maks. Usia 35 tahun, Menguasai Komputer',
      gambar_loker: 'assets/img/loker_1.jpeg',
    ),
    LokerDesa(
      id: '2',
      judul: 'Pendamping Masyarakat',
      instansi: 'Kantor Kecamatan Mandiri',
      deskripsi: 'Dibutuhkan tenaga pendamping untuk program pemberdayaan masyarakat',
      batasPendaftaran: '15 Juli 2024',
      persyaratan: 'S1 Sosial, Pengalaman Kerja Minimal 2 Tahun',
      gambar_loker: 'assets/img/loker_2.jpg',
    ),
    LokerDesa(
      id: '3',
      judul: 'Operator Teknologi Informasi',
      instansi: 'Balai Desa Digital',
      deskripsi: 'Mencari operator TI untuk mendukung digitalisasi layanan desa',
      batasPendaftaran: '20 Juli 2024',
      persyaratan: 'D3/S1 Teknologi Informasi, Terampil Mengoperasikan Komputer',
      gambar_loker: 'assets/img/loker_3.jpg',
    ),
    LokerDesa(
      id: '4',
      judul: 'Petugas Kesehatan Desa',
      instansi: 'Puskesmas Desa Makmur',
      deskripsi: 'Dibutuhkan petugas kesehatan untuk program kesehatan masyarakat desa',
      batasPendaftaran: '25 Juli 2024',
      persyaratan: 'D3/S1 Kesehatan, Pengalaman Minimal 1 Tahun',
      gambar_loker: 'assets/img/loker_4.jpg',
    ),
  ].obs;

  // Filtered job vacancies
  final filteredLokerDesa = <LokerDesa>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initially, all jobs are displayed
    filteredLokerDesa.value = semuaLokerDesa;
  }

  void filterLokerDesa(String query) {
    cariLokerDesaText.value = query;
    
    if (query.isEmpty) {
      filteredLokerDesa.value = semuaLokerDesa;
    } else {
      filteredLokerDesa.value = semuaLokerDesa.where((loker) => 
        loker.judul.toLowerCase().contains(query.toLowerCase()) ||
        loker.instansi.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
  }

  @override
  void onClose() {
    cariLokerDesaController.dispose();
    super.onClose();
  }

  LokerDesa? getLokerDesaById(String id) {
    try {
      return semuaLokerDesa.firstWhere((loker) => loker.id == id);
    } catch (e) {
      return null;
    }
  }
}