import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/PerangkatModel.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilDesaController extends GetxController with GetSingleTickerProviderStateMixin {
  // Controller untuk TabBar
  late TabController tabController;
  var isLoading = true.obs;
  final profile = <String, dynamic>{}.obs;
  final RxList<PerangkatModel> perangkatDesa = <PerangkatModel>[].obs;
  final RxList<PerangkatModel> bpdList = <PerangkatModel>[].obs;

 @override
  void onInit() {
    fetchprofile();
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onClose() {
    // Dispose TabController
    tabController.dispose();
    super.onClose();
  }

  Future<void> fetchprofile() async {
  try {
    isLoading.value = true;

    final res = await DioService.instance.get(ApiConstant.profilDesa);
    final data = Map<String, dynamic>.from(res.data);

    profile.value = data;

    // 🔥 AMBIL LIST PERANGKAT DESA
    if (data['perangkat_desa'] is List) {
    final list = data['perangkat_desa'];

    bpdList.value = list
        .where((e) => e['is_bpd'] == 1)
        .map<PerangkatModel>((e) => PerangkatModel.fromJson(e))
        .toList();

    perangkatDesa.value = list
        .where((e) => e['is_bpd'] == 0)
        .map<PerangkatModel>((e) => PerangkatModel.fromJson(e))
        .toList();
  }
  print(bpdList);

  } catch (e) {
    print('Error fetch profile: $e');
  } finally {
    isLoading.value = false;
  }
}

  void showPerangkatDetail(PerangkatModel perangkat) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Foto
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.muted,
                    backgroundImage: perangkat.image != null && perangkat.image!.isNotEmpty
                    ? NetworkImage(perangkat.image!)
                    : const AssetImage('assets/img/kepala_desa.jpg') as ImageProvider,
                    onBackgroundImageError: (exception, stackTrace) {},
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          perangkat.nama,
                          style: AppText.h6(color: AppColors.dark),
                        ),
                        Text(
                          perangkat.jabatan,
                          style: AppText.bodyMedium(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Informasi Detail
              _buildDetailItem('Periode', perangkat.periode),
              _buildDetailItem('Pendidikan', perangkat.pendidikan),
              _buildDetailItem('Alamat', perangkat.alamat),
              _buildDetailItem('No. Telp', perangkat.noTelp),
              
              const SizedBox(height: 10),
              
              SizedBox(
                child: Row(
                  spacing: 10.0,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => callNumber(perangkat.noTelp),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Icon(Icons.call)
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => openWhatsApp(perangkat.noTelp),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.bottonGreen,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Icon(Remix.whatsapp_line)
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 10.0, right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppText.bodyMedium(color: AppColors.textSecondary),
            ),
          ),
          Text(': ', style: AppText.bodyMedium(color: AppColors.text)),
          Expanded(
            child: Text(
              value,
              style: AppText.bodyMedium(color: AppColors.text),
            ),
          ),
        ],
      ),
    );
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