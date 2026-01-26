import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/NomorPentingModel.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class NomorPentingController extends GetxController {
  final RxList<NomorPentingModel> nomorDarurat = <NomorPentingModel>[].obs;
  final RxList<NomorPentingModel> filteredNomor = <NomorPentingModel>[].obs;
  final TextEditingController searchController = TextEditingController();
  final RxString searchText = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNomorDarurat();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchNomorDarurat() async {
  try {
    isLoading.value = true;

    final res = await DioService.instance.get(ApiConstant.nomorDarurat);

    final List listData =
        res.data is List ? res.data : res.data['data'] ?? [];

    nomorDarurat.value =
        listData.map((e) => NomorPentingModel.fromJson(e)).toList();

      filteredNomor.assignAll(nomorDarurat);
    } catch (e) {
      nomorDarurat.clear();
      filteredNomor.clear();
      print("Error fetchNomorDarurat: $e");
    } finally {
      isLoading.value = false;
    }
  }


  void filterNomorDarurat(String keyword) {
    if (keyword.isEmpty) {
      filteredNomor.assignAll(nomorDarurat);
    } else {
      filteredNomor.assignAll(
        nomorDarurat.where((item) {
          return item.name.toLowerCase().contains(keyword.toLowerCase());
        }).toList(),
      );
    }
  }



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
