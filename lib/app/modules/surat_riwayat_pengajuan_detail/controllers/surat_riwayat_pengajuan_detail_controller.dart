import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SuratRiwayatPengajuanDetailController extends GetxController {
  final dateFormat = DateFormat('dd MMMM yyyy');

  final RxString id = ''.obs;
  final RxMap<String, dynamic> data = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> trackingStatus =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      id.value = Get.arguments['id']?.toString() ?? '';
      data.assignAll(Get.arguments['data'] ?? {});
    }

    initTrackingData();
  }

  // 🔒 AMAN PARSE DATE
  DateTime? parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  void initTrackingData() {
    final DateTime? tanggalPengajuan = parseDate(data['created_at']);

    print(data['status']);

    switch (data['status']?.toString()) {
      case 'selesai':
        trackingStatus.assignAll([
          {
            'title': 'Pengajuan terkirim',
            'date': tanggalPengajuan,
            'description': 'Pengajuan surat telah diterima oleh sistem',
            'isDone': true,
          },
          {
            'title': 'Verifikasi Admin',
            'date': DateTime.now().subtract(const Duration(days: 3)),
            'description': 'Data sedang diverifikasi oleh admin',
            'isDone': true,
          },
          {
            'title': 'Tanda Tangan Kepala Desa',
            'date': DateTime.now().subtract(const Duration(days: 2)),
            'description': 'Surat sedang dalam proses pembuatan',
            'isDone': true,
          },
          {
            'title': 'Selesai',
            'date': DateTime.now().subtract(const Duration(days: 1)),
            'description': 'Surat telah selesai dan siap diambil',
            'isDone': true,
          },
        ]);
        break;

      case 'verifikasi':
        trackingStatus.assignAll([
          {
            'title': 'Pengajuan terkirim',
            'date': tanggalPengajuan,
            'description': 'Pengajuan surat telah diterima oleh sistem',
            'isDone': true,
          },
          {
            'title': 'Verifikasi Admin',
            'date': DateTime.now().subtract(const Duration(days: 1)),
            'description': 'Data sedang diverifikasi oleh admin',
            'isProses' : true,
            'isDone': false,
          },
          {
            'title': 'Tanda Tangan Kepala Desa',
            'date': DateTime.now(),
            'description': 'Surat sedang dalam proses pembuatan',
            'isDone': false,
          },
          {
            'title': 'Selesai',
            'date': null,
            'description': 'Surat telah selesai dan siap diambil',
            'isDone': false,
          },
        ]);
        break;
      case 'diproses':
        trackingStatus.assignAll([
          {
            'title': 'Pengajuan terkirim',
            'date': tanggalPengajuan,
            'description': 'Pengajuan surat telah diterima oleh sistem',
            'isDone': true,
          },
          {
            'title': 'Verifikasi Admin',
            'date': DateTime.now().subtract(const Duration(days: 1)),
            'description': 'Data sedang diverifikasi oleh admin',
            'isDone': false,
          },
          {
            'title': 'Tanda Tangan Kepala Desa',
            'date': DateTime.now(),
            'description': 'Surat sedang dalam proses pembuatan',
            'isProses': true,
            'isDone': false,
          },
          {
            'title': 'Selesai',
            'date': null,
            'description': 'Surat telah selesai dan siap diambil',
            'isDone': false,
          },
        ]);
        break;

      case 'ditolak':
        trackingStatus.assignAll([
          {
            'title': 'Pengajuan terkirim',
            'date': tanggalPengajuan,
            'description': 'Pengajuan surat telah diterima oleh sistem',
            'isDone': true,
          },
          {
            'title': 'Verifikasi Admin',
            'date': DateTime.now().subtract(const Duration(days: 1)),
            'description': 'Data sedang diverifikasi oleh admin',
            'isDone': true,
          },
          {
            'title': 'Pengajuan Ditolak',
            'date': DateTime.now(),
            'description': data['keterangan']?.toString() ?? '-',
            'isRejected': true,
            'isDone': true,
          },
        ]);
        break;

      default:
        trackingStatus.assignAll([
          {
            'title': 'Pengajuan terkirim',
            'date': tanggalPengajuan,
            'description': 'Pengajuan surat telah diterima oleh sistem',
            'isDone': false,
          },
          {
            'title': 'Verifikasi Admin',
            'date': null,
            'description': 'Data sedang diverifikasi oleh admin',
            'isDone': false,
          },
          {
            'title': 'Tanda Tangan Kepala Desa',
            'date': null,
            'description': 'Surat sedang dalam proses pembuatan',
            'isDone': false,
          },
          {
            'title': 'Selesai',
            'date': null,
            'description': 'Surat telah selesai dan siap diambil',
            'isDone': false,
          },
        ]);
    }
  }
}
