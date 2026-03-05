import 'dart:convert';
import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/services/storage_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SuratRiwayatPengajuanDetailController extends GetxController {
  final DateFormat dateFormat =
      DateFormat('dd MMMM yyyy HH:mm:ss', 'id_ID');
  final DateFormat perngajuanFormat =
      DateFormat('dd MMMM yyyy', 'id_ID');

  // ID surat
  final RxString id = ''.obs;

  // Data surat
  final RxMap<String, dynamic> data = <String, dynamic>{}.obs;

  // Status tracking
  final RxList<Map<String, dynamic>> trackingStatus =
      <Map<String, dynamic>>[].obs;

  // Loading
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      id.value = Get.arguments['id']?.toString() ?? '';
      data.assignAll(Get.arguments['data'] ?? {});
    }

    // Jika ID ada tapi data kosong, fetch dari API
    if (data.isEmpty && id.value.isNotEmpty) {
      fetchDetail(id.value);
    } else {
      initTrackingData();
    }
  }

  /// Fetch detail surat dari API
  Future<void> fetchDetail(String id) async {
    try {
      isLoading.value = true;

      final token = await StorageService.getToken();

      final res = await DioService.instance.get(
        '${ApiConstant.suratDetail}/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      print("STATUS CODE: ${res.statusCode}");
      print("RAW RESPONSE: ${res.data}");

      if (res.statusCode == 200 && res.data != null) {
        final dataJson = res.data['data'];
        if (dataJson != null && dataJson is Map<String, dynamic>) {
          data.assignAll(dataJson);
          initTrackingData();
          print("✅ FETCH SUCCESS");
        } else {
          print("❌ DATA FIELD NULL / BUKAN MAP");
          data.clear();
        }
      } else {
        print("❌ STATUS NOT 200");
      }
    } on DioException catch (dioError) {
      print("❌ DIO ERROR");
      print("MESSAGE: ${dioError.message}");
      print("STATUS: ${dioError.response?.statusCode}");
      print("DATA: ${dioError.response?.data}");
    } catch (e, stackTrace) {
      print("❌ UNKNOWN ERROR: $e");
      print(stackTrace);
    } finally {
      isLoading.value = false;
    }
  }

  /// Format tanggal
  String formatDate(dynamic value) {
    if (value == null) return '-';
    try {
      DateTime parsed;

      if (value is DateTime) {
        parsed = value;
      } else if (value is String && value.isNotEmpty) {
        if (value.startsWith('0000-00-00')) return '-';
        parsed = DateTime.parse(value);
      } else {
        return '-';
      }

      parsed = parsed.toLocal();
      return dateFormat.format(parsed);
    } catch (e) {
      debugPrint('Gagal parse date: $value');
      return '-';
    }
  }

  /// Inisialisasi tracking status
  void initTrackingData() {
    final String tanggalPengajuan = formatDate(data['created_at']);
    final String tanggalVerification = formatDate(data['verification_at']);
    final String tanggalSign = formatDate(data['sign_at']);
    final String tanggalSelesai = formatDate(data['completed_at']);
    final String tanggalDitolak = formatDate(data['rejected_at']);

    switch (data['status']?.toString()) {
      case 'selesai':
        trackingStatus.assignAll([
          _item('Pengajuan terkirim', tanggalPengajuan,
              'Pengajuan surat telah diterima oleh sistem',
              isDone: true),
          _item('Verifikasi Admin', tanggalVerification,
              'Data sedang diverifikasi oleh admin',
              isDone: true),
          _item('Tanda Tangan Kepala Desa', tanggalSign,
              'Surat sedang dalam proses pembuatan',
              isDone: true),
          _item('Selesai', tanggalSelesai,
              'Surat telah selesai dan siap diambil',
              isDone: true),
        ]);
        break;

      case 'verifikasi':
        trackingStatus.assignAll([
          _item('Pengajuan terkirim', tanggalPengajuan,
              'Pengajuan surat telah diterima oleh sistem',
              isDone: true),
          _item('Verifikasi Admin', tanggalVerification,
              'Data sedang diverifikasi oleh admin',
              isProses: true),
          _item('Tanda Tangan Kepala Desa', '-',
              'Surat sedang dalam proses pembuatan'),
          _item('Selesai', '-', 'Surat telah selesai dan siap diambil'),
        ]);
        break;

      case 'diproses':
        trackingStatus.assignAll([
          _item('Pengajuan terkirim', tanggalPengajuan,
              'Pengajuan surat telah diterima oleh sistem',
              isDone: true),
          _item('Verifikasi Admin', tanggalVerification,
              'Data sedang diverifikasi oleh admin',
              isDone: true),
          _item('Tanda Tangan Kepala Desa', tanggalSign,
              'Surat sedang dalam proses pembuatan',
              isProses: true),
          _item('Selesai', '-', 'Surat telah selesai dan siap diambil'),
        ]);
        break;

      case 'ditolak':
        trackingStatus.assignAll([
          _item('Pengajuan terkirim', tanggalPengajuan,
              'Pengajuan surat telah diterima oleh sistem',
              isDone: true),
          _item('Verifikasi Admin', tanggalVerification,
              'Data sedang diverifikasi oleh admin',
              isDone: true),
          _item('Pengajuan Ditolak', tanggalDitolak,
              data['rejected_reason']?.toString() ?? '-',
              isRejected: true,
              isDone: true),
        ]);
        break;

      default:
        trackingStatus.assignAll([
          _item('Pengajuan terkirim', tanggalPengajuan,
              'Pengajuan surat telah diterima oleh sistem'),
          _item('Verifikasi Admin', '-',
              'Data sedang diverifikasi oleh admin'),
          _item('Tanda Tangan Kepala Desa', '-',
              'Surat sedang dalam proses pembuatan'),
          _item('Selesai', '-', 'Surat telah selesai dan siap diambil'),
        ]);
    }
  }

  Map<String, dynamic> _item(
    String title,
    String date,
    String description, {
    bool isDone = false,
    bool isProses = false,
    bool isRejected = false,
  }) {
    return {
      'title': title,
      'date': date,
      'description': description,
      'isDone': isDone,
      'isProses': isProses,
      'isRejected': isRejected,
    };
  }

  Map<String, dynamic> get dataForm {
    final raw = data['data_form'];
    if (raw == null) return {};
    if (raw is Map<String, dynamic>) return raw;
    if (raw is String) {
      try {
        return Map<String, dynamic>.from(jsonDecode(raw));
      } catch (_) {
        return {};
      }
    }
    return {};
  }
}