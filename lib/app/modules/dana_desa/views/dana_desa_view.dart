import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';

import '../controllers/dana_desa_controller.dart';

class DanaDesaView extends GetView<DanaDesaController> {
  const DanaDesaView({super.key});
  
  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundScaffold,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _totalPengeluaran(),
                  SizedBox(height: AppResponsive.h(3)),
                  _dividerTitle('Rincian Pendapatan'),
                  SizedBox(height: AppResponsive.h(3)),
                  _rincianPendapatan(),
                  SizedBox(height: AppResponsive.h(3)),
                  _dividerTitle('Rincian Belanja'),
                  SizedBox(height: AppResponsive.h(3)),
                  _rincianPengeluaran()
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
  
  // Widget untuk header
  Widget _buildHeader() {
  return Container(
    width: double.infinity,
    height: 280,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFFE00004),
          Color(0xFFB80003),
          Color(0xFFE00004),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(40),
      ),
    ),
    child: SafeArea(
      child: Stack(
        children: [
          // Back Button
          Positioned(
            left: 16,
            top: 16,
            child: _circleButton(
              icon: Icons.arrow_back_ios_new,
              onTap: () => Get.back(),
            ),
          ),

          // PDF Button
          Positioned(
            right: 16,
            top: 16,
            child: _pdfButton(),
          ),

          // Content Tengah
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Pemerintah
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                  ),
                  child: Icon(
                    Icons.account_balance,
                    color: Colors.white,
                    size: 36,
                  ),
                ),

                SizedBox(height: 12),

                Text(
                  'Pemerintah Desa',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  'Desa Jaya Raya',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'Kec. Bungursari, Kab. Temanggung, Prov. Jawa Tengah',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),

                SizedBox(height: 16),

                // Chip Tahun Anggaran
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Tahun Anggaran 2025',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
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

Widget _circleButton({
  required IconData icon,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
      ),
      child: Icon(icon, color: Colors.white),
    ),
  );
}

Widget _pdfButton() {
  return GestureDetector(
    onTap: () {
      // download pdf
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.2),
      ),
      child: Row(
        children: [
          Icon(Icons.download, color: Colors.white, size: 16),
          SizedBox(width: 6),
          Text(
            'PDF',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    ),
  );
}

Widget _danaDesaCard({
  required String title,
  required String nominal,
  required IconData icon,
  required bool profit,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15), // GLASS
        border: Border.all(
          color: AppColors.borderDana.withOpacity(0.4),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.bodyMedium(),
                ),
                SizedBox(height: AppResponsive.h(0.5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      nominal,
                      style: AppText.h5(),
                    ),
                    Icon(
                      icon,
                      color: profit ? AppColors.darkGreen : AppColors.primary,
                    )
                  ],
                ),
                SizedBox(height: AppResponsive.h(1)),
              ],
            ),
          ),
    
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: profit ? AppColors.darkGreen.withOpacity(0.85) : AppColors.primary.withOpacity(0.85),
              borderRadius: BorderRadius.circular(20),
            ),
          )
        ],
      ),
    ),
  );
}

Widget _totalPengeluaran(){
  return Obx((){
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.apbn_pengeluaran.isEmpty) {
      return const Text('Belum ada data belanja');
    }
    if (controller.apbn_pendapatan.isEmpty) {
      return const Text('Belum ada data belanja');
    }
    return Column(
      children: [
      _danaDesaCard(
        title: "Jumlah Pendapatan",
        nominal: controller.formatRupiah(controller.totalPendapatan),
        icon: Icons.attach_money,
        profit: true,
      ),
      SizedBox(height: AppResponsive.h(1))
      ,
      _danaDesaCard(
        title: "Jumlah Belanja",
        nominal: controller.formatRupiah(controller.totalBelanja),
        icon: Icons.shopping_basket,
        profit: false,
      ),
    
      ]
    );  
  });  
}

Widget _rincianPendapatan(){
  return Obx( () {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.apbn_pengeluaran.isEmpty) {
      return const Text('Belum ada data belanja');
    }
    return Column(
          children: controller.apbn_pendapatan.map((item) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppResponsive.h(1)),
              child: _danaDesaCard(
                title: item['description'] ?? '-',
                nominal: controller.formatRupiah(item['anggaran'] ?? 0),
                icon: Icons.insert_drive_file,
                profit: true,
              ),
            );
          }).toList(),
        );
  });  
}
Widget _rincianPengeluaran(){
  return Obx( () {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.apbn_pengeluaran.isEmpty) {
      return const Text('Belum ada data belanja');
    }
    return Column(
          children: controller.apbn_pengeluaran.map((item) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppResponsive.h(1)),
              child: _danaDesaCard(
                title: item['description'] ?? '-',
                nominal: controller.formatRupiah(item['anggaran'] ?? 0),
                icon: Icons.insert_drive_file,
                profit: false,
              ),
            );
          }).toList(),
        );
  });  
}

Widget _dividerTitle(String title) {
  return Row(
    children: [
      const Expanded(child: Divider(thickness: 1)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          title,
          style: AppText.bodyMedium(color: AppColors.grey),
        ),
      ),
      const Expanded(child: Divider(thickness: 1)),
    ],
  );
}

}