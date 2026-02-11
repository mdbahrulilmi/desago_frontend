import 'dart:convert';

import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/services/storage_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_cli/common/utils/json_serialize/json_ast/tokenize.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class SuratRiwayatPengajuanController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  // ===== FILTER =====
  final selectedStatus = 'Semua'.obs;
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);

  // ===== DATA =====
  final isLoading = false.obs;
  final originalData = <Map<String, dynamic>>[].obs;
  final filteredData = <Map<String, dynamic>>[].obs;

  // ===== STATUS OPTIONS (sesuai backend) =====
  final List<String> statusOptions = [
    'Semua',
    'menunggu',
    'diproses',
    'ditolak',
    'selesai',
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

  // ================= FETCH DATA =================
  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final user = await StorageService.getUser();
      final token = await StorageService.getToken();

      final response = await DioService.instance.post(
          ApiConstant.suratRiwayat,
          data: {
            'id': user?.id,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ),
        );


      dynamic raw = response.data;
      List listData = [];

      if (raw is List) {
        listData = raw;
      } else if (raw is Map && raw['data'] != null) {
        if (raw['data'] is List) {
          listData = raw['data'];
        } else if (raw['data'] is String) {
          listData = jsonDecode(raw['data']);
        }
      }

      originalData.assignAll(
        listData.map((e) => Map<String, dynamic>.from(e)).toList(),
      );

      filterData();
    } catch (e) {
      debugPrint('❌ fetchData error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ================= FILTER DATA =================
  void filterData() {
    final query = searchController.text.toLowerCase();

    filteredData.value = originalData.where((item) {
      // 🔍 SEARCH
      final matchesSearch =
          item['id'].toString().contains(query) ||
          item['status'].toString().toLowerCase().contains(query) ||
          item['data_form'].toString().toLowerCase().contains(query);

      // 📌 STATUS
      final matchesStatus =
          selectedStatus.value == 'Semua' ||
          item['status'] == selectedStatus.value;

      // 📅 DATE (created_at)
      bool matchesDate = true;

      if (item['created_at'] != null) {
        final createdAt =
            DateTime.parse(item['created_at'].toString());

        if (startDate.value != null) {
          matchesDate =
              createdAt.isAfter(startDate.value!) ||
              createdAt.isAtSameMomentAs(startDate.value!);
        }

        if (endDate.value != null && matchesDate) {
          matchesDate = createdAt.isBefore(
            endDate.value!.add(const Duration(days: 1)),
          );
        }
      }

      return matchesSearch && matchesStatus && matchesDate;
    }).toList();
  }

  // ================= FILTER ACTION =================
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
    );

    if (picked != null) {
      startDate.value = picked;

      if (endDate.value != null &&
          endDate.value!.isBefore(picked)) {
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
      case 'diproses':
        return Colors.blue;
      case 'verifikasi':
        return Colors.purple;
      case 'ditolak':
        return Colors.red;
      case 'selesai':
        return Colors.green;
      case 'menunggu':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
