import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '../controllers/donasi_detail_controller.dart';

class DonasiDetailView extends GetView<DonasiDetailController> {
  const DonasiDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Detail Donasi',
          style: AppText.h5(color: AppColors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.donasi.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Remix.error_warning_line, size: 48, color: AppColors.danger),
                const SizedBox(height: 16),
                Text(
                  'Program donasi tidak ditemukan',
                  style: AppText.h5(color: AppColors.dark),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Kembali ke daftar donasi',
                    style: AppText.button(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          );
        }
        
        final donasi = controller.donasi.value!;
        
        return Column(
          children: [
            // Content - Scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Header
                    Container(
                      width: double.infinity,
                      height: AppResponsive.h(25),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(donasi.gambar_donasi),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    
                    // Content Container
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            donasi.judul,
                            style: AppText.h4(color: AppColors.dark),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Organisasi
                          Row(
                            children: [
                              Icon(
                                Remix.building_line, 
                                size: 18, 
                                color: AppColors.primary
                              ),
                              const SizedBox(width: 8),
                              Text(
                                donasi.organisasi,
                                style: AppText.bodyLarge(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Deadline with Icon
                          Row(
                            children: [
                              Icon(
                                Remix.calendar_event_line, 
                                size: 18, 
                                color: AppColors.danger
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Berakhir: ${donasi.tanggalBerakhir}',
                                style: AppText.bodyLarge(color: AppColors.danger),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Progress donasi
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LinearProgressIndicator(
                                      value: controller.calculateProgress(),
                                      backgroundColor: AppColors.grey.withOpacity(0.2),
                                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
                                      minHeight: 8,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          donasi.terkumpul,
                                          style: AppText.bodyLarge(color: AppColors.success, ),
                                        ),
                                        Text(
                                          controller.getProgressPercentage(),
                                          style: AppText.bodyMedium(color: AppColors.dark),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Target: ${donasi.targetDonasi}',
                                      style: AppText.bodyMedium(color: AppColors.dark),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Deskripsi Donasi
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tentang Program Donasi Ini',
                            style: AppText.h5(color: AppColors.dark),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          Text(
                            donasi.deskripsi,
                            style: AppText.bodyMedium(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Rekening Donasi
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rekening Donasi',
                            style: AppText.h5(color: AppColors.dark),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // BCA
                          _buildRekeningItem(
                            'bankBCA',
                            'assets/img/bank_bca.png',
                            controller.bankInfo['bankBCA']!['name']!,
                            controller.bankInfo['bankBCA']!['accountNumber']!,
                            controller.bankInfo['bankBCA']!['accountName']!,
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // BRI
                          _buildRekeningItem(
                            'bankBRI',
                            'assets/img/bank_bri.png',
                            controller.bankInfo['bankBRI']!['name']!,
                            controller.bankInfo['bankBRI']!['accountNumber']!,
                            controller.bankInfo['bankBRI']!['accountName']!,
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Mandiri
                          _buildRekeningItem(
                            'bankMandiri',
                            'assets/img/bank_mandiri.png',
                            controller.bankInfo['bankMandiri']!['name']!,
                            controller.bankInfo['bankMandiri']!['accountNumber']!,
                            controller.bankInfo['bankMandiri']!['accountName']!,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Pilih Nominal Donasi
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pilih Nominal Donasi',
                            style: AppText.h5(color: AppColors.dark),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Nominal preset buttons
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: controller.nominalOptions.map((nominal) {
                              return Obx(() => OutlinedButton(
                                onPressed: () => controller.setNominal(nominal),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: controller.selectedNominal.value == nominal 
                                    ? AppColors.white 
                                    : AppColors.primary,
                                  backgroundColor: controller.selectedNominal.value == nominal 
                                    ? AppColors.primary 
                                    : AppColors.white,
                                  side: BorderSide(
                                    color: controller.selectedNominal.value == nominal 
                                      ? AppColors.primary 
                                      : AppColors.grey.withOpacity(0.3),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text('Rp $nominal'),
                              ));
                            }).toList(),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Nominal custom
                          Text(
                            'Nominal Lainnya',
                            style: AppText.bodyMedium(color: AppColors.dark),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: controller.nominalController,
                              keyboardType: TextInputType.number,
                              style: AppText.bodyMedium(color: AppColors.dark),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                border: InputBorder.none,
                                hintText: 'Masukkan nominal donasi',
                                hintStyle: AppText.bodyMedium(color: AppColors.grey),
                                prefixText: 'Rp ',
                                prefixStyle: AppText.bodyMedium(color: AppColors.dark),
                              ),
                              onChanged: (value) {
                                controller.setCustomNominal(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            
            // Bottom Button - Donasi
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Hubungi button
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () => controller.hubungiPengelola(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.primary),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Hubungi',
                        style: AppText.button(color: AppColors.primary),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Donasi button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => controller.donasiSekarang(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Donasi Sekarang',
                        style: AppText.button(color: AppColors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
  
  // Widget untuk item rekening bank
  Widget _buildRekeningItem(String bankKey, String logoPath, String bankName, String accountNumber, String accountName) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.muted.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Bank logo placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              logoPath,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Remix.bank_line,
                  color: AppColors.primary,
                );
              },
            ),
          ),
          
          SizedBox(width: 12),
          
          // Bank info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bankName,
                  style: AppText.bodyMedium(color: AppColors.dark, ),
                ),
                SizedBox(height: 4),
                Text(
                  accountNumber,
                  style: AppText.bodyMedium(color: AppColors.dark),
                ),
                Text(
                  'a.n $accountName',
                  style: AppText.bodySmall(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          
          // Copy button
          IconButton(
            onPressed: () => controller.copyRekeningToClipboard(bankKey),
            icon: Icon(
              Remix.file_copy_line,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}