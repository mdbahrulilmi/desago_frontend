import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SuratRiwayatPengajuanController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final dateFormat = DateFormat('dd/MM/yyyy');
  
  // Filter variables
  var selectedStatus = 'Semua'.obs;
  var startDate = Rx<DateTime?>(null);
  var endDate = Rx<DateTime?>(null);
  
  // Data
  var isLoading = false.obs;
  var originalData = <Map<String, dynamic>>[].obs;
  var filteredData = <Map<String, dynamic>>[].obs;
  
  // Status options
  final List<String> statusOptions = [
    'Semua',
    'Diproses',
    'Ditolak',
    'Selesai',
    'Menunggu'
  ];

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    
    try {
      // Mock data - replace with actual API call
      await Future.delayed(Duration(seconds: 1));
      
      originalData.value = [
        {
          'id': '001',
          'jenis': 'Surat Keterangan Domisili',
          'tanggal': DateTime.now().subtract(Duration(days: 5)),
          'status': 'Diproses',
          'keterangan': 'Dokumen sedang diproses'
        },
        {
          'id': '002',
          'jenis': 'Surat Pengantar',
          'tanggal': DateTime.now().subtract(Duration(days: 10)),
          'status': 'Selesai',
          'keterangan': 'Dokumen telah selesai'
        },
        {
          'id': '003',
          'jenis': 'Surat Keterangan Usaha',
          'tanggal': DateTime.now().subtract(Duration(days: 15)),
          'status': 'Ditolak',
          'keterangan': 'Dokumen tidak lengkap'
        },
        {
          'id': '004',
          'jenis': 'Surat Keterangan Tidak Mampu',
          'tanggal': DateTime.now().subtract(Duration(days: 2)),
          'status': 'Menunggu',
          'keterangan': 'Menunggu persetujuan'
        },
        {
          'id': '005',
          'jenis': 'Surat Keterangan Domisili',
          'tanggal': DateTime.now().subtract(Duration(days: 20)),
          'status': 'Selesai',
          'keterangan': 'Dokumen telah selesai'
        },
      ];
      
      // Initialize filtered data
      filterData();
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterData() {
    String searchQuery = searchController.text.toLowerCase();
    
    filteredData.value = originalData.where((item) {
      // Apply text search filter
      bool matchesSearch = item['jenis'].toString().toLowerCase().contains(searchQuery) ||
                         item['keterangan'].toString().toLowerCase().contains(searchQuery) ||
                         item['id'].toString().toLowerCase().contains(searchQuery);
      
      // Apply status filter
      bool matchesStatus = selectedStatus.value == 'Semua' || 
                          item['status'] == selectedStatus.value;
      
      // Apply date range filter
      bool matchesDateRange = true;
      if (startDate.value != null) {
        DateTime itemDate = item['tanggal'];
        matchesDateRange = itemDate.isAfter(startDate.value!) || 
                           itemDate.isAtSameMomentAs(startDate.value!);
      }
      if (endDate.value != null && matchesDateRange) {
        DateTime itemDate = item['tanggal'];
        // Add one day to end date to include the end date in results
        DateTime adjustedEndDate = endDate.value!.add(Duration(days: 1));
        matchesDateRange = itemDate.isBefore(adjustedEndDate);
      }
      
      return matchesSearch && matchesStatus && matchesDateRange;
    }).toList();
  }

  void setStatusFilter(String status) {
    selectedStatus.value = status;
    filterData();
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFFE70000),
            colorScheme: ColorScheme.light(primary: Color(0xFFE70000)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      startDate.value = picked;
      // If end date is before start date, reset end date
      if (endDate.value != null && endDate.value!.isBefore(picked)) {
        endDate.value = null;
      }
      filterData();
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? DateTime.now(),
      firstDate: startDate.value ?? DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFFE70000),
            colorScheme: ColorScheme.light(primary: Color(0xFFE70000)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      endDate.value = picked;
      filterData();
    }
  }
  
  void resetFilters() {
    searchController.clear();
    selectedStatus.value = 'Semua';
    startDate.value = null;
    endDate.value = null;
    filterData();
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
}