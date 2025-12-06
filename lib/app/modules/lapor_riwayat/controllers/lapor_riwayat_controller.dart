import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LaporRiwayatController extends GetxController {
  final dateFormat = DateFormat('dd MMMM yyyy, HH:mm');
  
  // Data riwayat laporan
  final RxList<Map<String, dynamic>> laporanList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredLaporanList = <Map<String, dynamic>>[].obs;
  
  // Loading state
  final RxBool isLoading = true.obs;
  
  // Filter
  final TextEditingController searchController = TextEditingController();
  final RxString selectedStatus = 'Semua'.obs;
  final RxList<String> statusOptions = ['Semua', 'Diproses', 'Ditolak', 'Selesai', 'Menunggu'].obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchLaporanList();
  }
  
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
  
  Future<void> fetchLaporanList() async {
    isLoading.value = true;
    
    try {
      // Simulasi delay loading data
      await Future.delayed(Duration(seconds: 1));
      
      // Data contoh untuk laporan
      laporanList.value = [
        {
          'id': 'LPR001',
          'judul': 'Jalan Rusak di RT 03',
          'tanggal': DateTime.now().subtract(Duration(days: 10)),
          'kategori': 'Infrastruktur',
          'deskripsi': 'Terdapat jalan berlubang yang cukup dalam di area RT 03 yang membahayakan pengendara motor.',
          'status': 'Selesai',
          'foto': 'assets/img/noimage.png',
          'keterangan': 'Perbaikan jalan sudah dilakukan pada tanggal 15 Juli 2024',
          'tanggapan': 'Terima kasih atas laporannya. Perbaikan telah dilakukan.'
        },
        {
          'id': 'LPR002',
          'judul': 'Lampu Jalan Mati di Jalan Mawar',
          'tanggal': DateTime.now().subtract(Duration(days: 5)),
          'kategori': 'Fasilitas Umum',
          'deskripsi': 'Lampu jalan di sepanjang Jalan Mawar mati sejak 3 hari yang lalu.',
          'status': 'Diproses',
          'foto': 'assets/img/noimage.png',
          'keterangan': 'Sudah dijadwalkan perbaikan pada minggu ini',
          'tanggapan': 'Laporan Anda sedang kami tindaklanjuti. Tim teknis akan segera melakukan perbaikan.'
        },
        {
          'id': 'LPR003',
          'judul': 'Sampah Menumpuk di Pasar',
          'tanggal': DateTime.now().subtract(Duration(days: 2)),
          'kategori': 'Kebersihan',
          'deskripsi': 'Sampah di area pasar desa menumpuk dan tidak diangkut selama beberapa hari.',
          'status': 'Menunggu',
          'foto': 'assets/img/noimage.png',
          'keterangan': 'Menunggu jadwal pengangkutan sampah',
          'tanggapan': null
        },
        {
          'id': 'LPR004',
          'judul': 'Pohon Tumbang di Jalan Utama',
          'tanggal': DateTime.now().subtract(Duration(days: 15)),
          'kategori': 'Bencana',
          'deskripsi': 'Pohon besar tumbang dan menghalangi jalan utama desa setelah hujan deras semalam.',
          'status': 'Selesai',
          'foto': 'assets/img/noimage.png',
          'keterangan': 'Pohon telah dipindahkan oleh tim Dinas Lingkungan Hidup',
          'tanggapan': 'Pohon telah berhasil dipindahkan. Terima kasih atas laporannya.'
        },
        {
          'id': 'LPR005',
          'judul': 'Kegiatan Mencurigakan di Rumah Kosong',
          'tanggal': DateTime.now().subtract(Duration(days: 1)),
          'kategori': 'Keamanan',
          'deskripsi': 'Terdapat aktivitas mencurigakan di rumah kosong di RT 05.',
          'status': 'Ditolak',
          'foto': 'assets/img/noimage.png',
          'keterangan': 'Setelah diperiksa, rumah tersebut sedang dalam renovasi oleh pemiliknya',
          'tanggapan': 'Setelah dilakukan pengecekan, aktivitas tersebut adalah tim renovasi yang bekerja lembur.'
        },
      ];
      
      // Filter data awal
      filterLaporan();
      
    } catch (e) {
      print('Error fetching data: $e');
      
      // Tampilkan error message
      Get.snackbar(
        'Error',
        'Gagal memuat data laporan. Silakan coba lagi.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      
    } finally {
      isLoading.value = false;
    }
  }
  
  void filterLaporan() {
    String searchQuery = searchController.text.toLowerCase();
    
    filteredLaporanList.value = laporanList.where((laporan) {
      // Filter berdasarkan teks
      bool matchesSearch = laporan['judul'].toString().toLowerCase().contains(searchQuery) ||
                          laporan['deskripsi'].toString().toLowerCase().contains(searchQuery) ||
                          laporan['kategori'].toString().toLowerCase().contains(searchQuery) ||
                          laporan['id'].toString().toLowerCase().contains(searchQuery);
      
      // Filter berdasarkan status
      bool matchesStatus = selectedStatus.value == 'Semua' || 
                          laporan['status'] == selectedStatus.value;
      
      return matchesSearch && matchesStatus;
    }).toList();
  }
  
  void setStatusFilter(String status) {
    selectedStatus.value = status;
    filterLaporan();
  }
  
  void viewDetail(Map<String, dynamic> laporan) {
    // Navigasi ke halaman detail dengan data laporan
    Get.toNamed('/lapor/detail', arguments: {'data': laporan});
  }
  
  void buatLaporanBaru() {
    // Navigasi ke halaman buat laporan baru
    Get.toNamed('/lapor/buat');
  }
  
  void refreshData() {
    fetchLaporanList();
  }
  
  Color getStatusColor(String status) {
    switch (status) {
      case 'Diproses':
        return Colors.blue;
      case 'Ditolak':
        return Colors.red;
      case 'Selesai':
        return Colors.green;
      case 'Menunggu':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  
  IconData getKategoriIcon(String kategori) {
    switch (kategori) {
      case 'Infrastruktur':
        return Icons.build_rounded;
      case 'Fasilitas Umum':
        return Icons.apartment;
      case 'Kebersihan':
        return Icons.cleaning_services;
      case 'Keamanan':
        return Icons.security;
      case 'Bencana':
        return Icons.warning_amber;
      default:
        return Icons.help_outline;
    }
  }
}