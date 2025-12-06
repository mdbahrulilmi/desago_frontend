
import 'package:desago/app/models/DonasiModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DonasiDetailController extends GetxController {
  // Observable variables
  final isLoading = true.obs;
  final donasi = Rxn<Donasi>();
  
  // Text controller untuk nominal custom
  final nominalController = TextEditingController();
  
  // Observable untuk nominal
  final nominalDonasi = ''.obs;
  final nominalOptions = [
    '10.000', '25.000', '50.000', '100.000', '250.000', '500.000', '1.000.000'
  ];
  final selectedNominal = ''.obs;
  
  // Informasi bank (dummy untuk demo)
  final bankInfo = {
    'bankBCA': {
      'name': 'Bank BCA',
      'accountNumber': '1234567890',
      'accountName': 'Yayasan Desago'
    },
    'bankBRI': {
      'name': 'Bank BRI',
      'accountNumber': '0987654321',
      'accountName': 'Yayasan Desago'
    },
    'bankMandiri': {
      'name': 'Bank Mandiri',
      'accountNumber': '2468013579',
      'accountName': 'Yayasan Desago'
    },
  };
  
  // Informasi kontak untuk pertanyaan
  final String contactPhone = '+6281234567890';
  
  @override
  void onInit() {
    super.onInit();
    _loadDonasi();
    
    // Mendengarkan perubahan pada text controller
    nominalController.addListener(() {
      nominalDonasi.value = nominalController.text;
    });
  }
  
  @override
  void onClose() {
    nominalController.dispose();
    super.onClose();
  }
  
  void _loadDonasi() {
    try {
      // Langsung dapatkan data donasi dari arguments
      final donasiData = Get.arguments?['donasi'];
      
      if (donasiData == null) {
        // Handle case when no data is provided
        isLoading.value = false;
        return;
      }
      
      // Ambil data donasi langsung dari arguments
      donasi.value = donasiData;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memuat data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  // Method untuk memilih nominal donasi
  void setNominal(String nominal) {
    selectedNominal.value = nominal;
    nominalDonasi.value = nominal;
    nominalController.text = nominal;
  }
  
  // Method untuk custom nominal
  void setCustomNominal(String value) {
    nominalDonasi.value = value;
    selectedNominal.value = '';
  }
  
  // Method untuk melakukan donasi
  void donasiSekarang() {
    if (nominalDonasi.value.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Silakan pilih atau masukkan nominal donasi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    
    // Implementasi pembayaran bisa ditambahkan di sini
    // Dalam kasus ini, kita hanya memberikan snackbar konfirmasi
    Get.snackbar(
      'Donasi Berhasil',
      'Terima kasih telah berdonasi sebesar Rp ${nominalDonasi.value}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }
  
  // Method untuk menghubungi pengelola donasi
  void hubungiPengelola() async {
    try {
      // Menggunakan WhatsApp untuk kontak
      final whatsappUrl = 'https://wa.me/$contactPhone?text=Halo, saya tertarik dengan program donasi "${donasi.value?.judul}". Boleh saya mendapatkan informasi lebih lanjut?';
      
      final url = Uri.parse(whatsappUrl);
      
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        // Fallback ke telepon jika WhatsApp tidak terinstall
        final telUrl = Uri.parse('tel:$contactPhone');
        if (await canLaunchUrl(telUrl)) {
          await launchUrl(telUrl);
        } else {
          Get.snackbar(
            'Gagal Terhubung',
            'Tidak dapat menghubungi pengelola donasi',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  // Method untuk mengcopy nomor rekening
  void copyRekeningToClipboard(String bankKey) {
    final bank = bankInfo[bankKey];
    if (bank != null) {
      Clipboard.setData(ClipboardData(text: bank['accountNumber']!));
      Get.snackbar(
        'Rekening Disalin',
        'Nomor rekening ${bank['name']} telah disalin ke clipboard',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }
  
  // Helper method untuk menghitung progress donasi
  double calculateProgress() {
    try {
      if (donasi.value == null) return 0.0;
      
      // Menghapus "Rp " dan mengganti titik dan koma
      String cleanTerkumpul = donasi.value!.terkumpul.replaceAll('Rp ', '').replaceAll('.', '').trim();
      String cleanTarget = donasi.value!.targetDonasi.replaceAll('Rp ', '').replaceAll('.', '').trim();
      
      double terkumpulValue = double.parse(cleanTerkumpul);
      double targetValue = double.parse(cleanTarget);
      
      if (targetValue == 0) return 0.0;
      return terkumpulValue / targetValue;
    } catch (e) {
      return 0.0;
    }
  }
  
  // Helper method untuk format persentase
  String getProgressPercentage() {
    return '${(calculateProgress() * 100).toStringAsFixed(1)}%';
  }
}