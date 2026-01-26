import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/services/dio_services.dart';
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
  try {
    isLoading.value = true;

    final res = await DioService.instance.get(ApiConstant.lapor);

    final listData = res.data is List ? res.data : (res.data['data'] ?? []);

    laporanList.assignAll(
      listData.map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList(),
    );
    filterLaporan();
  } catch (e, stackTrace) {
    debugPrint('Error fetchLaporanList: $e');
    debugPrint(stackTrace.toString());
  } finally {
    isLoading.value = false;
  }
}

  
  void filterLaporan() {
    String searchQuery = searchController.text.toLowerCase();
    
    filteredLaporanList.value = laporanList.where((laporan) {
      // Filter berdasarkan teks
      bool matchesSearch = laporan['title'].toString().toLowerCase().contains(searchQuery) ||
                          laporan['description'].toString().toLowerCase().contains(searchQuery) ||
                          laporan['lapor_category']['name'].toString().toLowerCase().contains(searchQuery) ||
                          laporan['no'].toString().toLowerCase().contains(searchQuery);
      
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
    Get.toNamed('/lapor/detail', arguments: {'data': laporan});
  }
  
  void buatLaporanBaru() {
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