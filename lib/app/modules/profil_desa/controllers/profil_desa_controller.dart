import 'dart:convert';

import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/ProfilDesaModel.dart';
import 'package:desago/app/models/PemdesAparaturModel.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get_storage/get_storage.dart';

class ProfilDesaController extends GetxController
    with GetSingleTickerProviderStateMixin {

  final box = GetStorage();
  static const _cacheKey = 'profil_desa_cache';

  late TabController tabController;
  final isLoading = true.obs;
  final Rx<ProfilDesaModel?> desa = Rx<ProfilDesaModel?>(null);

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hasCache = _loadFromCache();

        if (!hasCache) {
          fetchProfile();
        } else {
          isLoading.value = false;
        }
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> refreshProfile() async {
    await fetchProfile();
  }

   bool _loadFromCache() {
    final cached = box.read(_cacheKey);
    if (cached == null) return false;

    try {
      desa.value = ProfilDesaModel.fromJson(
        cached is String ? jsonDecode(cached) : cached,
      );
      debugPrint('🟡 PROFIL DESA: loaded from cache');
      return true;
    } catch (e) {
      debugPrint('🔴 Cache error: $e');
      return false;
    }
  }

  void _saveToCache(Map<String, dynamic> data) {
    box.write(_cacheKey, jsonEncode(data));
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      final res = await DioService.instance.get(ApiConstant.profilDesa);
      desa.value = ProfilDesaModel.fromJson(res.data);
      _saveToCache(res.data);
      debugPrint('🟢 PROFIL DESA: fetched from API');
    } catch (e) {
      debugPrint('🔴 fetchProfile error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  

  List<PemdesAparaturModel> get perangkatDesa =>
      desa.value?.perangkatDesa ?? [];

  List<PemdesAparaturModel> get bpdList =>
      desa.value?.bpd ?? [];

  void showPerangkatDetail(PemdesAparaturModel perangkat) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.muted,
                    backgroundImage: perangkat.gambar.isNotEmpty
                        ? NetworkImage(perangkat.gambar)
                        : const AssetImage('assets/img/kepala_desa.jpg')
                            as ImageProvider,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(perangkat.nama,
                            style: AppText.h6(color: AppColors.text)),
                        SizedBox(height: AppResponsive.h(0.5)),
                        SelectableText(
                          "NIP : ${perangkat.nip}" ?? '-',
                          style: AppText.bodyMedium(color: AppColors.text),
                        ),
                        Text(perangkat.jabatan,
                            style: AppText.bodyMedium(
                                color: AppColors.primary)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildDetailItem('Periode', perangkat.periode),
              _buildDetailItem('Pendidikan', perangkat.pendidikan),
              _buildDetailItem('Alamat', perangkat.alamat),
              _buildDetailItem(
                'No. Telp',
                perangkat.canShowPhone
                    ? perangkat.noTelepon
                    : 'Disembunyikan',
              ),

              const SizedBox(height: 12),

              if (perangkat.canShowPhone)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            callNumber(perangkat.noTelepon),
                          style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: const Icon(Icons.call, color: AppColors.secondary),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            openWhatsApp(perangkat.noTelepon),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.bottonGreen,
                        ),
                        child: const Icon(Remix.whatsapp_line, color: AppColors.secondary),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style:
                    AppText.bodyMedium(color: AppColors.textSecondary)),
          ),
          const Text(': '),
          Expanded(
            child: Text(value,
                style: AppText.bodyMedium(color: AppColors.text)),
          ),
        ],
      ),
    );
  }

  /// =========================
  /// ACTIONS
  /// =========================
  Future<void> openWhatsApp(String phoneNumber) async {
    var number = phoneNumber.startsWith('0')
        ? '+62${phoneNumber.substring(1)}'
        : phoneNumber;

    final url = Uri.parse('https://wa.me/$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> callNumber(String phoneNumber) async {
    final url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Berhasil',
      'Nomor disalin',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
