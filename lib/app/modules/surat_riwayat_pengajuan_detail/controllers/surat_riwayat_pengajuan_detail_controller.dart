import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SuratRiwayatPengajuanDetailController extends GetxController {
  final dateFormat = DateFormat('dd MMMM yyyy');
  
  // Gunakan RxString dan RxMap untuk membuat variabel reaktif
  final RxString id = ''.obs;
  final RxMap<String, dynamic> data = <String, dynamic>{}.obs;
  
  // Status tracking
  final RxList<Map<String, dynamic>> trackingStatus = <Map<String, dynamic>>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    
    // Dapatkan arguments dari navigasi
    if (Get.arguments != null) {
      if (Get.arguments['id'] != null) {
        id.value = Get.arguments['id'];
      }
      
      if (Get.arguments['data'] != null) {
        data.assignAll(Get.arguments['data']);
      }
    }
    
    // Inisialisasi data tracking (simulasi data)
    initTrackingData();
  }
  
  void initTrackingData() {
    // Contoh data tracking berdasarkan status
    switch(data['status']) {
      case 'Selesai':
        trackingStatus.value = [
          {
            'title': 'Pengajuan Diterima',
            'date': data['tanggal'],
            'description': 'Pengajuan surat telah diterima oleh sistem',
            'isDone': true
          },
          {
            'title': 'Verifikasi Data',
            'date': DateTime.now().subtract(Duration(days: 3)),
            'description': 'Data sedang diverifikasi oleh admin',
            'isDone': true
          },
          {
            'title': 'Pemrosesan Surat',
            'date': DateTime.now().subtract(Duration(days: 2)),
            'description': 'Surat sedang dalam proses pembuatan',
            'isDone': true
          },
          {
            'title': 'Surat Selesai',
            'date': DateTime.now().subtract(Duration(days: 1)),
            'description': 'Surat telah selesai dan siap diambil',
            'isDone': true
          }
        ];
        break;
        
      case 'Diproses':
        trackingStatus.value = [
          {
            'title': 'Pengajuan Diterima',
            'date': data['tanggal'],
            'description': 'Pengajuan surat telah diterima oleh sistem',
            'isDone': true
          },
          {
            'title': 'Verifikasi Data',
            'date': DateTime.now().subtract(Duration(days: 1)),
            'description': 'Data sedang diverifikasi oleh admin',
            'isDone': true
          },
          {
            'title': 'Pemrosesan Surat',
            'date': DateTime.now(),
            'description': 'Surat sedang dalam proses pembuatan',
            'isDone': false
          },
          {
            'title': 'Surat Selesai',
            'date': null,
            'description': 'Surat telah selesai dan siap diambil',
            'isDone': false
          }
        ];
        break;
        
      case 'Ditolak':
        trackingStatus.value = [
          {
            'title': 'Pengajuan Diterima',
            'date': data['tanggal'],
            'description': 'Pengajuan surat telah diterima oleh sistem',
            'isDone': true
          },
          {
            'title': 'Verifikasi Data',
            'date': DateTime.now().subtract(Duration(days: 1)),
            'description': 'Data sedang diverifikasi oleh admin',
            'isDone': true
          },
          {
            'title': 'Pengajuan Ditolak',
            'date': DateTime.now(),
            'description': data['keterangan'],
            'isDone': true,
            'isRejected': true
          }
        ];
        break;
        
      case 'Menunggu':
      default:
        trackingStatus.value = [
          {
            'title': 'Pengajuan Diterima',
            'date': data['tanggal'],
            'description': 'Pengajuan surat telah diterima oleh sistem',
            'isDone': true
          },
          {
            'title': 'Verifikasi Data',
            'date': null,
            'description': 'Data sedang diverifikasi oleh admin',
            'isDone': false
          },
          {
            'title': 'Pemrosesan Surat',
            'date': null,
            'description': 'Surat sedang dalam proses pembuatan',
            'isDone': false
          },
          {
            'title': 'Surat Selesai',
            'date': null,
            'description': 'Surat telah selesai dan siap diambil',
            'isDone': false
          }
        ];
        break;
    }
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