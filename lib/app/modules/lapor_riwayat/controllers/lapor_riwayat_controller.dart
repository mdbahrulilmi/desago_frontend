import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/modules/lapor_detail/controllers/lapor_detail_controller.dart';
import 'package:desago/app/modules/lapor_detail/views/lapor_detail_view.dart';
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
  final RxList<String> statusOptions = ['Semua', 'Menunggu', 'Diproses', 'Selesai', 'Ditolak'].obs;
  
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
  final searchQuery = searchController.text.toLowerCase();
  final selected = selectedStatus.value.toLowerCase();

  filteredLaporanList.value = laporanList.where((laporan) {
    final title = laporan['title']?.toString().toLowerCase() ?? '';
    final desc = laporan['description']?.toString().toLowerCase() ?? '';
    final kategori = laporan['kategori']?['name']?.toString().toLowerCase() ?? '';
    final no = laporan['no']?.toString().toLowerCase() ?? '';
    final status = laporan['status']?.toString().toLowerCase() ?? '';

    // 🔍 search text
    final matchesSearch =
        title.contains(searchQuery) ||
        desc.contains(searchQuery) ||
        kategori.contains(searchQuery) ||
        no.contains(searchQuery);

    // 🎯 filter status
    final matchesStatus =
        selected == 'semua' || status == selected;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  
  void setStatusFilter(String status) {
    selectedStatus.value = status;
    filterLaporan();
  }
  
  void viewDetail(Map<String, dynamic> laporan) {
    Get.to(() => LaporDetailView(), arguments: {'data': laporan});
    Get.put(LaporDetailController());
  }
  
  void buatLaporanBaru() {
    Get.toNamed('/lapor/buat');
  }
  
  void refreshData() {
    fetchLaporanList();
  }
  
  Color getStatusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.orange;
      case 'Diproses':
        return Colors.blue;
      case 'Ditolak':
        return Colors.red;
      case 'Selesai':
        return Colors.green;
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