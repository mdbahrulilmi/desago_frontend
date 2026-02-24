  import 'package:desago/app/constant/api_constant.dart';
  import 'package:desago/app/models/LaporModel.dart';
  import 'package:desago/app/modules/lapor_detail/controllers/lapor_detail_controller.dart';
  import 'package:desago/app/modules/lapor_detail/views/lapor_detail_view.dart';
  import 'package:desago/app/services/dio_services.dart';
  import 'package:desago/app/services/storage_services.dart';
  import 'package:dio/dio.dart';
  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:intl/intl.dart';

  class LaporRiwayatController extends GetxController {
    final dateFormat = DateFormat('dd MMMM yyyy, HH:mm');
    final RxList<LaporModel> laporanList = <LaporModel>[].obs;
    final RxList<LaporModel> filteredLaporanList = <LaporModel>[].obs;
    final RxBool isLoading = true.obs;
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

        final token = await StorageService.getToken();

        final res = await DioService.instance.get(
          ApiConstant.lapor,
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );

        final listData = res.data is List ? res.data : (res.data['data'] ?? []);

        laporanList.assignAll(
          listData.map<LaporModel>((e) => LaporModel.fromJson(e as Map<String, dynamic>)).toList(),
        );

        filterLaporan();
      } catch (e, stackTrace) {
      } finally {
        isLoading.value = false;
      }
    }

    void filterLaporan() {
      final searchQuery = searchController.text.toLowerCase();
      final selected = selectedStatus.value.toLowerCase();

      filteredLaporanList.value = laporanList.where((laporan) {
        final title = laporan.judul.toLowerCase();
        final desc = laporan.deskripsi.toLowerCase();
        final kategori = laporan.kategoriId.toString();
        final id = laporan.id.toString();
        final status = laporan.status.toLowerCase();

        final matchesSearch =
            title.contains(searchQuery) ||
            desc.contains(searchQuery) ||
            kategori.contains(searchQuery) ||
            id.contains(searchQuery);

        final matchesStatus =
            selected == 'semua' || status == selected;

        return matchesSearch && matchesStatus;
      }).toList();
    }

    void setStatusFilter(String status) {
      selectedStatus.value = status;
      filterLaporan();
    }

    void viewDetail(LaporModel laporan) {
      Get.to(
        () => LaporDetailView(),
        binding: BindingsBuilder(() {
          Get.lazyPut<LaporDetailController>(() => LaporDetailController());
        }),
        arguments: {'data': laporan},
      );
    }


    void buatLaporanBaru() {
      Get.toNamed('/lapor/buat');
    }

    Future<void> refreshData() async {
      fetchLaporanList();
    }

    Color getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'menunggu':
          return Colors.orange;
        case 'diproses':
          return Colors.blue;
        case 'ditolak':
          return Colors.red;
        case 'selesai':
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
