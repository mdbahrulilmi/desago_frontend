import 'package:desago/app/models/AnggaranModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _totalPendapatan(),
                  SizedBox(height: AppResponsive.h(2)),
                  _totalBelanja(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildHeader(context) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE00004), Color(0xFFB80003), Color(0xFFE00004)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 16,
              top: 16,
              child: _circleButton(
                icon: Icons.arrow_back_ios_new,
                onTap: () => Get.back(),
              ),
            ),
            Positioned(
              right: 16,
              top: 16,
              child: _pdfButton(),
            ),
            Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_balance, color: Colors.white, size: 48),
                const SizedBox(height: 12),
                const Text('Pemerintah Desa', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 6),
                
                Obx(() => Text(
                      'Desa ${controller.desaNama.value}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    )),
                
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // penting supaya Row tidak expand
                  children: [
                    Text(
                      'Tahun Anggaran',
                      style: AppText.bodyMedium(color: Colors.white70),
                    ),
                    InkWell(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            final years = List.generate(10, (index) => 2021 + index);
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              insetPadding: const EdgeInsets.all(50), 
                              child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(
                                    initialItem: years.indexOf(controller.selectedYear.value),
                                  ),
                                  itemExtent: 40,
                                  onSelectedItemChanged: (index) {
                                    controller.selectedYear.value = years[index];
                                    controller.fetchDanaDesa();
                                  },
                                  children: years
                                      .map((year) => Center(child: Text(year.toString())))
                                      .toList(),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                        child: Obx(() => Text(
                              controller.selectedYear.value.toString(),
                              style: AppText.h6(color: AppColors.secondary),
                            )),
                      ),
                    ),
                  ],
                ),],
            ),
          )
],
        ),
      ),
    );
  }

  // ================= TOTAL =================

  Widget _totalPendapatan() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const CircularProgressIndicator();
      }

      return Column(
        children: [
          GestureDetector(
            onTap: controller.togglePendapatan,
            child: _danaDesaCard(
              title: "Jumlah Pendapatan",
              nominal:
                  controller.formatRupiah(controller.totalPendapatan),
              icon: controller.showPendapatan.value
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              profit: true,
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: controller.showPendapatan.value
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: _rincianPendapatan(),
            secondChild: const SizedBox(),
          ),
        ],
      );
    });
  }

  Widget _totalBelanja() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const CircularProgressIndicator();
      }

      return Column(
        children: [
          GestureDetector(
            onTap: controller.toggleBelanja,
            child: _danaDesaCard(
              title: "Jumlah Belanja",
              nominal: controller.formatRupiah(controller.totalBelanja),
              icon: controller.showBelanja.value
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              profit: false,
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: controller.showBelanja.value
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: _rincianBelanja(),
            secondChild: const SizedBox(),
          ),
        ],
      );
    });
  }

  // ================= RINCIAN =================

  Widget _rincianPendapatan() {
  return Obx(() {
    return Column(
      children: controller.pendapatan.map<Widget>((item) {
        final level = _kategoriLevel(item);

        debugPrint(
          'PENDAPATAN | kategori: ${item.kategori?.nama} | level: $level | parent: ${item.kategori?.parentId}',
        );

        return Padding(
          padding: EdgeInsets.only(top: AppResponsive.h(1)),
          child: _danaDesaCard(
            title: item.kategori?.nama ?? '-',
            nominal: controller.formatRupiah(item.anggaran),
            icon: Icons.subdirectory_arrow_right,
            profit: true,
            level: level,
          ),
        );
      }).toList(),
    );
  });
}


  Widget _rincianBelanja() {
  return Obx(() {
    return Column(
      children: controller.belanja.map<Widget>((item) {
        final level = _kategoriLevel(item);

        debugPrint(
          'BELANJA | kategori: ${item.kategori?.nama} | level: $level | parent: ${item.kategori?.parentId}',
        );

        return Padding(
          padding: EdgeInsets.only(top: AppResponsive.h(1)),
          child: _danaDesaCard(
            title: item.kategori?.nama ?? '-',
            nominal: controller.formatRupiah(item.anggaran),
            icon: Icons.subdirectory_arrow_right,
            profit: false,
            level: level,
          ),
        );
      }).toList(),
    );
  });
}


  // ================= COMPONENT =================

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
      controller.generatePdf();
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.download, color: Colors.white, size: 16),
          SizedBox(width: 6),
          Text('PDF', style: TextStyle(color: Colors.white)),
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
    int level = 0,
  }) {
    final double indent = level * 24.0;
    final double screenWidth = Get.width;
    final double cardWidth = screenWidth - 40 - indent;

    final double fontScale = (1 - (level * 0.1)).clamp(0.7, 1.0);
    final double horizontalPadding = (14.0 - level).clamp(8.0, 14.0);
    final double verticalPadding = (12.0 - level).clamp(6.0, 12.0);
    final double radius = (14.0 - level).clamp(8.0, 14.0);
    final double bgOpacity =
        (level == 0 ? 0.22 : 0.16 - (level * 0.02)).clamp(0.08, 0.22);

    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: Container(
        width: cardWidth,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(bgOpacity),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: AppColors.borderDana.withOpacity(
              level == 0 ? 0.4 : 0.25,
            ),
          ),
        ),
        child: Row(
          children: [
            if (level > 0)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.subdirectory_arrow_right,
                  size: (16.0 - level).clamp(10, 16),
                  color: AppColors.grey,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodyMedium().copyWith(
                      fontSize: 14 * fontScale,
                      color: AppColors.dark
                          .withOpacity(level == 0 ? 1 : 0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    nominal,
                    style: AppText.h5().copyWith(
                      fontSize: 18 * fontScale,
                      fontWeight: level == 0
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                 Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: profit ? AppColors.darkGreen : AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )
                ],
              ),
            ),
            Icon(
              icon,
              size: (22.0 - (level * 2)).clamp(14, 22),
              color:
                  profit ? AppColors.darkGreen : AppColors.primary,
            ),
            
          ],
        ),
      ),
    );
  }

  int _kategoriLevel(AnggaranModel item) {
    if (item.kategori == null) return 0;
    return controller.kategoriLevel(item.kategori!);
  }
}
