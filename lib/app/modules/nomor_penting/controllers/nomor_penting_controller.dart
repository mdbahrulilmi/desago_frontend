import 'package:desago/app/models/NomorPentingModel.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class NomorPentingController extends GetxController {
  final RxList<NomorPentingModel> nomorPentingList = <NomorPentingModel>[
    NomorPentingModel(nama: 'Ambulans', nomor: '118'),
    NomorPentingModel(nama: 'Polisi', nomor: '110'),
    NomorPentingModel(nama: 'Pemadam Kebakaran', nomor: '113'),
    NomorPentingModel(nama: 'Basarnas', nomor: '115'),
    NomorPentingModel(nama: 'PLN', nomor: '123'),
    NomorPentingModel(nama: 'Layanan Darurat Telkom', nomor: '147'),
    NomorPentingModel(nama: 'Call Center Jasa Marga', nomor: '14080'),
    NomorPentingModel(nama: 'BPJS Kesehatan', nomor: '1500400'),
    NomorPentingModel(nama: 'Posko Bencana BNPB', nomor: '081281973311'),
  ].obs;

  final RxList<NomorPentingModel> filteredNomorPentingList =
      <NomorPentingModel>[].obs;
  final TextEditingController searchController = TextEditingController();
  final RxString searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    filteredNomorPentingList.assignAll(nomorPentingList);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void filterNomorPenting(String query) {
    searchText.value = query;

    if (query.isEmpty) {
      filteredNomorPentingList.assignAll(nomorPentingList);
    } else {
      filteredNomorPentingList.assignAll(nomorPentingList.where((item) =>
          item.nama.toLowerCase().contains(query.toLowerCase()) ||
          item.nomor.toLowerCase().contains(query.toLowerCase())));
    }
  }

  // Fungsi untuk melakukan panggilan telepon
  Future<void> callNumber(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar(
        'Kesalahan',
        'Tidak dapat melakukan panggilan ke nomor $phoneNumber',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Fungsi untuk membuka WhatsApp
  Future<void> openWhatsApp(String phoneNumber) async {
    String formattedNumber = phoneNumber;
    if (!formattedNumber.startsWith('+')) {
      if (formattedNumber.startsWith('0')) {
        formattedNumber = '+62${formattedNumber.substring(1)}';
      } else if (!formattedNumber.startsWith('62')) {
        formattedNumber = '+62$formattedNumber';
      } else {
        formattedNumber = '+$formattedNumber';
      }
    }
    final Uri url = Uri.parse('https://wa.me/$formattedNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Kesalahan',
        'Tidak dapat membuka WhatsApp untuk nomor $phoneNumber',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void copyToClipboard(String text) {
    try {
      Clipboard.setData(ClipboardData(text: text));
      Get.snackbar(
        'Berhasil',
        'Nomor $text telah disalin ke clipboard',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success.withOpacity(0.8),
        colorText: AppColors.white,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Kesalahan',
        'Gagal menyalin nomor: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger.withOpacity(0.8),
        colorText: AppColors.white,
      );
    }
  }
}
