import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:remixicon/remixicon.dart';

import '../controllers/cek_bansos_hasil_controller.dart';

class CekBansosHasilView extends GetView<CekBansosHasilController> {
  const CekBansosHasilView({super.key});
  
  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Hasil Cek Bansos',
          style: AppText.h5(color: AppColors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => controller.hasilList.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Remix.search_eye_line,
                  size: 72,
                  color: AppColors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Tidak ada data yang ditemukan',
                  style: AppText.bodyLarge(color: AppColors.dark),
                ),
              ],
            ),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header wilayah
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWilayahInfo('Provinsi', controller.wilayah['provinsi'] ?? '-'),
                        SizedBox(height: 8),
                        _buildWilayahInfo('Kabupaten', controller.wilayah['kabupaten'] ?? '-'),
                        SizedBox(height: 8),
                        _buildWilayahInfo('Kecamatan', controller.wilayah['kecamatan'] ?? '-'),
                        SizedBox(height: 8),
                        _buildWilayahInfo('Kelurahan', controller.wilayah['kelurahan'] ?? '-'),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Daftar hasil pencarian
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.hasilList.length,
                    itemBuilder: (context, index) {
                      final data = controller.hasilList[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header dengan nama dan umur
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      data['nama'] ?? 'NAMA TIDAK TERSEDIA',
                                      style: AppText.bodyLarge(color: AppColors.white, ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Text(
                                    '${data['umur'] ?? '-'} Tahun',
                                    style: AppText.bodyMedium(color: AppColors.white),
                                  ),
                                ],
                              ),
                            ),
                            
                            // List card program bansos
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // BPNT
                                  _buildBansosCard(
                                    'BPNT',
                                    data['bpnt']['status'] ?? false,
                                    data['bpnt']['keterangan'] ?? '-',
                                    data['bpnt']['periode'] ?? '-',
                                  ),
                                  
                                  // BST
                                  _buildBansosCard(
                                    'BST',
                                    data['bst']['status'] ?? false,
                                    data['bst']['keterangan'] ?? '-',
                                    data['bst']['periode'] ?? '-',
                                  ),
                                  
                                  // PKH
                                  _buildBansosCard(
                                    'PKH',
                                    data['pkh']['status'] ?? false,
                                    data['pkh']['keterangan'] ?? '-',
                                    data['pkh']['periode'] ?? '-',
                                  ),
                                  
                                  // PBI-JK
                                  _buildBansosCard(
                                    'PBI-JK',
                                    data['pbi_jk']['status'] ?? false,
                                    '-', // PBI-JK tidak memiliki keterangan
                                    data['pbi_jk']['periode'] ?? '-',
                                  ),
                                  
                                  // BLT-BBM
                                  _buildBansosCard(
                                    'BLT-BBM',
                                    data['blt_bbm']['status'] ?? false,
                                    data['blt_bbm']['keterangan'] ?? '-',
                                    data['blt_bbm']['periode'] ?? '-',
                                  ),
                                  
                                  // Bantuan Yatim Piatu
                                  _buildBansosCard(
                                    'BANTUAN YATIM PIATU',
                                    data['bantuan_yatim_piatu']['status'] ?? false,
                                    data['bantuan_yatim_piatu']['keterangan'] ?? '-',
                                    data['bantuan_yatim_piatu']['periode'] ?? '-',
                                  ),
                                  
                                  // RST
                                  _buildBansosCard(
                                    'RUMAH SEJAHTERA TERPADU (RST)',
                                    data['rst']['status'] ?? false,
                                    data['rst']['keterangan'] ?? '-',
                                    data['rst']['periode'] ?? '-',
                                  ),
                                  
                                  // Permakanan
                                  _buildBansosCard(
                                    'PERMAKANAN',
                                    data['permakanan']['status'] ?? false,
                                    data['permakanan']['keterangan'] ?? '-',
                                    data['permakanan']['periode'] ?? '-',
                                  ),
                                  
                                  // Sembako Adaptif
                                  _buildBansosCard(
                                    'SEMBAKO ADAPTIF',
                                    data['sembako_adaptif']['status'] ?? false,
                                    data['sembako_adaptif']['keterangan'] ?? '-',
                                    data['sembako_adaptif']['periode'] ?? '-',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
  
  // Widget untuk menampilkan info wilayah
  Widget _buildWilayahInfo(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: AppText.bodyMedium(color: AppColors.dark),
          ),
        ),
        Text(': ', style: AppText.bodyMedium(color: AppColors.dark)),
        Expanded(
          child: Text(
            value,
            style: AppText.bodyMedium(color: AppColors.dark, ),
          ),
        ),
      ],
    );
  }
  
  // Widget untuk membuat card program bansos
  Widget _buildBansosCard(String program, bool status, String keterangan, String periode) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: status ? AppColors.success.withOpacity(0.05) : AppColors.grey.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: status ? AppColors.success.withOpacity(0.3) : AppColors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Status icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: status ? AppColors.success.withOpacity(0.1) : AppColors.danger.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: status
                  ? Icon(Remix.check_line, size: 24, color: AppColors.success)
                  : Icon(Remix.close_line, size: 24, color: AppColors.danger),
              ),
            ),
            SizedBox(width: 12),
            
            // Program info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program,
                    style: AppText.bodyMedium(
                      color: AppColors.dark,
                      
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              'Status: ',
                              style: AppText.bodySmall(color: AppColors.dark),
                            ),
                            Text(
                              status ? 'Aktif' : 'Tidak Aktif',
                              style: AppText.bodySmall(
                                color: status ? AppColors.success : AppColors.danger,
                                
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (keterangan != '-')
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                'Ket: ',
                                style: AppText.bodySmall(color: AppColors.dark),
                              ),
                              Text(
                                keterangan,
                                style: AppText.bodySmall(
                                  color: AppColors.dark,
                                  
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  if (periode != '-') 
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Text(
                            'Periode: ',
                            style: AppText.bodySmall(color: AppColors.dark),
                          ),
                          Text(
                            periode,
                            style: AppText.bodySmall(
                              color: AppColors.dark,
                              
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}