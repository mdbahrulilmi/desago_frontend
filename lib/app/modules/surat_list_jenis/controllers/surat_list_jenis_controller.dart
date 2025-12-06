import 'package:desago/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class SuratListJenisController extends GetxController {
  // State variables
  final isLoading = true.obs;
  final kategoriId = ''.obs;
  final kategoriTitle = ''.obs;
  final jenisSuratList = [].obs;

  @override
  void onInit() {
    super.onInit();
    // Dapatkan parameter dari rute
    if (Get.arguments != null) {
      kategoriId.value = Get.arguments['kategoriId'] ?? '';
      kategoriTitle.value = Get.arguments['kategoriTitle'] ?? 'Daftar Surat';
    }
    fetchJenisSurat();
  }

  // Ambil data jenis surat berdasarkan kategori
  void fetchJenisSurat() {
    isLoading.value = true;

    // Simulasi network delay
    Future.delayed(Duration(milliseconds: 800), () {
      // Switch case untuk menentukan data berdasarkan kategori
      switch (kategoriId.value) {
        case 'keterangan':
          jenisSuratList.value = _getSuratKeteranganList();
          break;
        case 'pengantar':
          jenisSuratList.value = _getSuratPengantarList();
          break;
        case 'rekomendasi':
          jenisSuratList.value = _getSuratRekomendasiList();
          break;
        case 'lainnya':
          jenisSuratList.value = _getSuratLainnyaList();
          break;
        default:
          jenisSuratList.value = [];
      }

      isLoading.value = false;
    });
  }

  // Navigasi ke detail surat
  void navigateToDetail(Map<String, dynamic> surat) {
  Get.toNamed('/surat-form', arguments: {
    'kategoriId': kategoriId.value,
    'kategoriTitle': kategoriTitle.value,
    'suratId': surat['id'],
    'suratTitle': surat['title'],
    'suratData': surat
  });
}

  // Mendapatkan icon berdasarkan kategori
  IconData getKategoriIcon() {
    switch (kategoriId.value) {
      case 'keterangan':
        return Icons.info_outline;
      case 'pengantar':
        return Remix.file_paper_2_line;
      case 'rekomendasi':
        return Remix.file_edit_line;
      case 'lainnya':
        return Remix.file_list_3_line;
      default:
        return Icons.description_outlined;
    }
  }

  // Mendapatkan warna icon berdasarkan kategori
  Color getIconColor() {
    switch (kategoriId.value) {
      case 'keterangan':
        return AppColors.purple;
      case 'pengantar':
        return AppColors.lightBlue;
      case 'rekomendasi':
        return AppColors.success;
      case 'lainnya':
        return AppColors.orange;
      default:
        return AppColors.primary;
    }
  }

  // Update fungsi _getSuratKeteranganList() dalam SuratListJenisController

// Data - Surat Keterangan
  List<Map<String, dynamic>> _getSuratKeteranganList() {
    return [
      {
        'id': 'k1',
        'title': 'Surat Keterangan Format Bebas',
        'description': 'Surat keterangan dengan format bebas sesuai kebutuhan',
        'persyaratan': [
          'Fotokopi KTP',
          'Surat Pengantar RT/RW',
          'Dokumen pendukung sesuai kebutuhan',
        ],
        'estimasi': '3 hari kerja'
      },
      {
        'id': 'k2',
        'title': 'Surat Keterangan Asal-Usul',
        'description': 'Surat yang menerangkan asal-usul seseorang',
        'persyaratan': [
          'Fotokopi KTP',
          'Fotokopi Kartu Keluarga',
          'Surat Pengantar RT/RW',
        ],
        'estimasi': '3 hari kerja'
      },
      {
        'id': 'k3',
        'title': 'Surat Keterangan SKCK',
        'description': 'Surat keterangan untuk keperluan pembuatan SKCK',
        'persyaratan': [
          'Fotokopi KTP',
          'Fotokopi Kartu Keluarga',
          'Pas Foto 4x6 (2 lembar)',
          'Surat Pengantar RT/RW',
        ],
        'estimasi': '2 hari kerja'
      },
      {
        'id': 'k4',
        'title': 'Surat Keterangan Domisili',
        'description': 'Surat yang menerangkan tempat tinggal seseorang',
        'persyaratan': [
          'Fotokopi KTP',
          'Fotokopi Kartu Keluarga',
          'Surat Pengantar RT/RW',
        ],
        'estimasi': '3 hari kerja'
      },
      {
        'id': 'k5',
        'title': 'Surat Keterangan Penghasilan',
        'description': 'Surat yang menerangkan penghasilan seseorang',
        'persyaratan': [
          'Fotokopi KTP',
          'Surat Pengantar RT/RW',
          'Slip Gaji/Bukti Penghasilan (jika ada)',
          'Surat Pernyataan Penghasilan',
        ],
        'estimasi': '3 hari kerja'
      },
      {
        'id': 'k6',
        'title': 'Surat Keterangan Usaha',
        'description':
            'Surat yang menerangkan bahwa seseorang memiliki usaha tertentu',
        'persyaratan': [
          'Fotokopi KTP',
          'Fotokopi NPWP (jika ada)',
          'Surat Pengantar RT/RW',
          'Foto Lokasi Usaha',
        ],
        'estimasi': '4 hari kerja'
      },
      {
        'id': 'k7',
        'title': 'Surat Keterangan Susunan Keluarga',
        'description': 'Surat yang menerangkan susunan/komposisi keluarga',
        'persyaratan': [
          'Fotokopi KTP Kepala Keluarga',
          'Fotokopi Kartu Keluarga',
          'Surat Pengantar RT/RW',
        ],
        'estimasi': '2 hari kerja'
      },
      {
        'id': 'k8',
        'title': 'Surat Keterangan Orang Yang Sama',
        'description':
            'Surat yang menerangkan bahwa dua identitas berbeda adalah orang yang sama',
        'persyaratan': [
          'Fotokopi KTP',
          'Fotokopi dokumen yang berbeda nama/identitas',
          'Surat Pengantar RT/RW',
        ],
        'estimasi': '3 hari kerja'
      },
      {
        'id': 'k9',
        'title': 'Surat Keterangan Belum Menikah',
        'description': 'Surat yang menerangkan status belum menikah seseorang',
        'persyaratan': [
          'Fotokopi KTP',
          'Fotokopi Kartu Keluarga',
          'Surat Pengantar RT/RW',
        ],
        'estimasi': '3 hari kerja'
      },
      {
        'id': 'k10',
        'title': 'Surat Keterangan Tidak Mampu',
        'description':
            'Surat yang menerangkan kondisi ekonomi keluarga untuk keperluan bantuan/keringanan',
        'persyaratan': [
          'Fotokopi KTP',
          'Fotokopi Kartu Keluarga',
          'Surat Pengantar RT/RW',
          'Surat Pernyataan Tidak Mampu',
        ],
        'estimasi': '3 hari kerja'
      },
      {
        'id': 'k11',
        'title': 'Surat Keterangan Domisili Perusahaan',
        'description':
            'Surat yang menerangkan lokasi/tempat usaha sebuah perusahaan',
        'persyaratan': [
          'Fotokopi KTP Pemilik/Penanggung Jawab',
          'Fotokopi NPWP Perusahaan',
          'Surat Pengantar RT/RW',
          'Fotokopi Akta Pendirian (jika ada)',
          'Bukti Kepemilikan/Sewa Tempat Usaha',
        ],
        'estimasi': '5 hari kerja'
      },
      {
        'id': 'k12',
        'title': 'Surat Keterangan Kependudukan',
        'description': 'Surat yang menerangkan status kependudukan seseorang',
        'persyaratan': [
          'Fotokopi KTP',
          'Fotokopi Kartu Keluarga',
          'Surat Pengantar RT/RW',
        ],
        'estimasi': '3 hari kerja'
      },
      {
        'id': 'k13',
        'title': 'Surat Keterangan Belum Memiliki Rumah',
        'description':
            'Surat yang menerangkan bahwa seseorang belum memiliki rumah',
        'persyaratan': [
          'Fotokopi KTP',
          'Fotokopi Kartu Keluarga',
          'Surat Pengantar RT/RW',
          'Surat Pernyataan Belum Memiliki Rumah',
        ],
        'estimasi': '3 hari kerja'
      },
      {
        'id': 'k14',
        'title': 'Surat Keterangan Kelahiran',
        'description': 'Surat keterangan untuk pencatatan kelahiran anak',
        'persyaratan': [
          'Surat Keterangan Lahir dari Bidan/Rumah Sakit',
          'Fotokopi KTP Orang Tua',
          'Fotokopi Kartu Keluarga',
          'Fotokopi Buku Nikah/Akta Perkawinan',
        ],
        'estimasi': '3 hari kerja'
      },
      {
        'id': 'k15',
        'title': 'Surat Keterangan Ahli Waris',
        'description':
            'Surat yang menerangkan ahli waris dari seseorang yang telah meninggal',
        'persyaratan': [
          'Fotokopi KTP Ahli Waris',
          'Fotokopi Kartu Keluarga',
          'Fotokopi Surat Kematian',
          'Fotokopi Akta Kelahiran Ahli Waris',
          'Surat Pengantar RT/RW',
        ],
        'estimasi': '5 hari kerja'
      },
      {
        'id': 'k16',
        'title': 'Surat Keterangan Kematian',
        'description': 'Surat keterangan untuk pencatatan kematian',
        'persyaratan': [
          'Surat Keterangan Kematian dari Rumah Sakit/Dokter',
          'Fotokopi KTP Almarhum/Almarhumah',
          'Fotokopi Kartu Keluarga',
          'Fotokopi KTP Pelapor',
        ],
        'estimasi': '2 hari kerja'
      },
    ];
  }

// Data - Surat Pengantar
  List<Map<String, dynamic>> _getSuratPengantarList() {
    return [
      {
        'id': 'p1',
        'title': 'Surat Pengantar Kuasa',
        'description':
            'Surat pengantar untuk memberikan kuasa kepada orang lain',
        'persyaratan': [
          'Fotokopi KTP Pemberi Kuasa',
          'Fotokopi KTP Penerima Kuasa',
          'Surat Pengantar RT/RW',
          'Materai 10.000',
        ],
        'estimasi': '2 hari kerja'
      },
      {
        'id': 'p2',
        'title': 'Surat Pengantar Pengakuan Bersama (Pernikahan)',
        'description': 'Surat pengantar untuk keperluan pengakuan pernikahan',
        'persyaratan': [
          'Fotokopi KTP Suami dan Istri',
          'Fotokopi Kartu Keluarga',
          'Surat Pengantar RT/RW',
          'Foto Bersama Ukuran 4x6 (2 lembar)',
          'Surat Pernyataan Bersama',
        ],
        'estimasi': '3 hari kerja'
      },
      {
        'id': 'p3',
        'title': 'Surat Pengantar Pindah Domisili',
        'description': 'Surat pengantar untuk keperluan pindah tempat tinggal',
        'persyaratan': [
          'Fotokopi KTP',
          'Fotokopi Kartu Keluarga',
          'Surat Pengantar RT/RW',
          'Formulir Permohonan Pindah',
          'Alamat Tujuan Pindah Lengkap',
        ],
        'estimasi': '3 hari kerja'
      },
      {
        'id': 'p4',
        'title': 'Surat Pengantar Izin Orangtua (Pernikahan)',
        'description':
            'Surat pengantar izin orangtua untuk keperluan pernikahan',
        'persyaratan': [
          'Fotokopi KTP Orang Tua',
          'Fotokopi KTP Calon Pengantin',
          'Fotokopi Kartu Keluarga',
          'Surat Pengantar RT/RW',
          'Surat Pernyataan Izin Orang Tua',
        ],
        'estimasi': '2 hari kerja'
      },
      {
        'id': 'p5',
        'title': 'Surat Pengantar Izin Keramaian',
        'description':
            'Surat pengantar untuk mengadakan acara/kegiatan yang melibatkan banyak orang',
        'persyaratan': [
          'Fotokopi KTP Penanggung Jawab',
          'Surat Pengantar RT/RW',
          'Jadwal dan Uraian Kegiatan',
          'Denah Lokasi Kegiatan',
          'Daftar Panitia Kegiatan',
        ],
        'estimasi': '4 hari kerja'
      },
      {
        'id': 'p6',
        'title': 'Surat Pengantar Pembuatan Pangkalan',
        'description':
            'Surat pengantar untuk izin pembuatan pangkalan (gas, dll)',
        'persyaratan': [
          'Fotokopi KTP Pemohon',
          'Fotokopi NPWP',
          'Surat Pengantar RT/RW',
          'Bukti Kepemilikan/Sewa Tempat',
          'Denah Lokasi Pangkalan',
          'Surat Pernyataan Tidak Keberatan dari Tetangga',
        ],
        'estimasi': '5 hari kerja'
      },
      {
        'id': 'p7',
        'title': 'Surat Pengantar Izin Perjalanan',
        'description': 'Surat pengantar untuk keperluan perjalanan/bepergian',
        'persyaratan': [
          'Fotokopi KTP',
          'Surat Pengantar RT/RW',
          'Informasi Tujuan Perjalanan',
          'Lama Waktu Perjalanan',
        ],
        'estimasi': '1 hari kerja'
      },
    ];
  }

  // Data - Surat Rekomendasi
  List<Map<String, dynamic>> _getSuratRekomendasiList() {
    return [
      {
        'id': 'r1',
        'title': 'Surat Rekomendasi Kegiatan',
        'description':
            'Surat rekomendasi untuk melaksanakan kegiatan di wilayah tertentu',
        'persyaratan': [
          'Proposal Kegiatan',
          'Fotokopi KTP Penanggung Jawab',
          'Jadwal Kegiatan',
          'Surat Pernyataan',
        ],
        'estimasi': '5 hari kerja'
      },
      // Tambahkan jenis surat rekomendasi lainnya di sini
    ];
  }

  // Data - Surat Lainnya
  List<Map<String, dynamic>> _getSuratLainnyaList() {
    return [
      {
        'id': 'l1',
        'title': 'Surat Keterangan Kelahiran',
        'description': 'Surat keterangan untuk pencatatan kelahiran anak',
        'persyaratan': [
          'Surat Keterangan Lahir dari Bidan/Rumah Sakit',
          'Fotokopi KTP Orang Tua',
          'Fotokopi Kartu Keluarga',
          'Fotokopi Buku Nikah/Akta Perkawinan',
        ],
        'estimasi': '3 hari kerja'
      },
      {
        'id': 'l2',
        'title': 'Surat Keterangan Kematian',
        'description': 'Surat keterangan untuk pencatatan kematian',
        'persyaratan': [
          'Surat Keterangan Kematian dari Rumah Sakit/Dokter',
          'Fotokopi KTP Almarhum/Almarhumah',
          'Fotokopi Kartu Keluarga',
          'Fotokopi KTP Pelapor',
        ],
        'estimasi': '2 hari kerja'
      },
      // Tambahkan jenis surat lainnya di sini
    ];
  }
}
