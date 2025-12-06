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
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Dana Desa',
          style: AppText.h5(color: AppColors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header - APB Desa dan Tahun
              _buildHeader(),
              
              // Card Ringkasan Dana Desa
              _buildDanaDesaSummary(),
              
              SizedBox(height: 24),
              
              // Grafik Pendapatan dan Belanja dari Tahun ke Tahun
              _buildPendapatanBelanjaTahunanChart(),
              
              SizedBox(height: 24),
              
              // Grafik Pendapatan Desa 2025
              _buildPendapatanChart(),
              
              SizedBox(height: 24),
              
              // Daftar Detail Pendapatan
              _buildPendapatanDetailList(),
              
              SizedBox(height: 24),
              
              // Grafik Belanja Desa 2025
              _buildBelanjaChart(),
              
              SizedBox(height: 24),
              
              // Daftar Detail Belanja
              _buildBelanjaDetailList(),
              
              SizedBox(height: 24),
              
              // Pembiayaan Desa 2025
              _buildPembiayaanSection(),
              
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
  
  // Widget untuk header
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown untuk memilih tahun
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'APB DESA WERE WERE',
                style: AppText.h5(color: AppColors.success),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() => DropdownButton<String>(
                value: controller.selectedYear.value,
                icon: Icon(Icons.keyboard_arrow_down, color: AppColors.dark),
                underline: SizedBox(),
                items: controller.years.map((year) {
                  return DropdownMenuItem<String>(
                    value: year,
                    child: Text(year, style: AppText.bodyMedium(color: AppColors.dark)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) controller.changeYear(value);
                },
              )),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'DESA WERE WERE, Kecamatan Digacom, Kota Digakuib, Provinsi Digaraw',
          style: AppText.bodyMedium(color: AppColors.dark),
        ),
        SizedBox(height: 16),
      ],
    );
  }
  
  // Widget untuk ringkasan dana desa
  Widget _buildDanaDesaSummary() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Pendapatan dan Belanja
          Row(
            children: [
              // Pendapatan
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.arrow_downward, color: AppColors.success, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'Pendapatan',
                            style: AppText.bodyMedium(color: AppColors.dark),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Obx(() => Text(
                        controller.formatRupiah(controller.pendapatan.value),
                        style: AppText.bodyMedium(color: AppColors.success),
                      )),
                    ],
                  ),
                ),
              ),
              // Garis pemisah
              Container(
                height: 60,
                width: 1,
                color: AppColors.grey.withOpacity(0.3),
              ),
              // Belanja
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.arrow_upward, color: AppColors.danger, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'Belanja',
                            style: AppText.bodyMedium(color: AppColors.dark),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Obx(() => Text(
                        controller.formatRupiah(controller.belanja.value),
                        style: AppText.bodyMedium(color: AppColors.danger),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Garis pemisah horizontal
          Container(
            height: 1,
            color: AppColors.grey.withOpacity(0.3),
          ),
          
          // Pembiayaan
          Row(
            children: [
              // Penerimaan
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.call_received, color: AppColors.info, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'Penerimaan',
                            style: AppText.bodyMedium(color: AppColors.dark),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Obx(() => Text(
                        controller.formatRupiah(controller.penerimaan.value),
                        style: AppText.bodyMedium(color: AppColors.info),
                      )),
                    ],
                  ),
                ),
              ),
              // Garis pemisah
              Container(
                height: 60,
                width: 1,
                color: AppColors.grey.withOpacity(0.3),
              ),
              // Pengeluaran
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.call_made, color: AppColors.warning, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'Pengeluaran',
                            style: AppText.bodyMedium(color: AppColors.dark),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Obx(() => Text(
                        controller.formatRupiah(controller.pengeluaran.value),
                        style: AppText.bodyMedium(color: AppColors.warning),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Garis pemisah horizontal
          Container(
            height: 1,
            color: AppColors.grey.withOpacity(0.3),
          ),
          
          // Surplus/Defisit
          Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Surplus/Defisit',
                  style: AppText.bodyMedium(color: AppColors.dark),
                ),
                SizedBox(height: 8),
                Obx(() => Text(
                  controller.formatRupiah(controller.surplus.value),
                  style: AppText.bodyLarge(color: controller.surplus.value >= 0 ? AppColors.success : AppColors.danger),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget untuk grafik pendapatan dan belanja tahunan
  Widget _buildPendapatanBelanjaTahunanChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pendapatan dan Belanja DESA WERE dari Tahun ke Tahun',
          style: AppText.h6(color: AppColors.success),
        ),
        SizedBox(height: 16),
        Container(
          height: 330, // Meningkatkan tinggi chart agar angka terlihat lebih jelas
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Obx(() => BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 5000000000, // Nilai maksimum
              minY: 0, // Memastikan nilai minimal 0
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipPadding: EdgeInsets.all(8),
                  tooltipRoundedRadius: 8,
                  getTooltipColor: (BarChartGroupData group) => Color(0xFF616161),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    String tahun = controller.pendapatanTahunan[group.x.toInt()]['tahun'];
                    double value = rod.toY;
                    String type = rodIndex == 0 ? 'Pendapatan' : 'Belanja';
                    return BarTooltipItem(
                      '$type $tahun\n',
                      TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: controller.formatRupiah(value),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      String tahun = controller.pendapatanTahunan[value.toInt()]['tahun'];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          tahun,
                          style: AppText.small(color: AppColors.dark),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1000000000,
                    reservedSize: 100,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return SizedBox();
                      
                      // Format angka dengan pemisah ribuan
                      String formattedValue = value.toStringAsFixed(0)
                        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
                          (Match m) => '${m[1]}.');
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          formattedValue,
                          style: AppText.small(color: AppColors.dark),
                          textAlign: TextAlign.right,
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1000000000,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppColors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                },
              ),
              borderData: FlBorderData(show: false),
              barGroups: controller.getPendapatanBelanjaBarGroups(),
            ),
          )),
        ),
        SizedBox(height: 16),
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: controller.pendapatanColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: 8),
                Text('Pendapatan', style: AppText.bodySmall(color: AppColors.dark)),
              ],
            ),
            SizedBox(width: 24),
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: controller.belanjaColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: 8),
                Text('Belanja', style: AppText.bodySmall(color: AppColors.dark)),
              ],
            ),
          ],
        ),
      ],
    );
  }
  
  // Widget untuk grafik pendapatan
  Widget _buildPendapatanChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pendapatan DESA WERE 2025',
          style: AppText.h6(color: AppColors.success),
        ),
        SizedBox(height: 16),
        Container(
          height: 350,
          padding: EdgeInsets.all(21),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Obx(() => BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 3000000000, // Nilai maksimum
              minY: 0, // Memastikan nilai minimal 0
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipPadding: EdgeInsets.all(8),
                  tooltipRoundedRadius: 8,
                  getTooltipColor: (BarChartGroupData group) => Color(0xFF616161),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final data = controller.pendapatanDetail[group.x.toInt()];
                    return BarTooltipItem(
                      '${data['kategori']}\n',
                      TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: controller.formatRupiah(data['jumlah'].toDouble()),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                      reservedSize: 50, 
                    getTitlesWidget: (value, meta) {
                      final kategori = controller.pendapatanDetail[value.toInt()]['kategori'] as String;
                      final words = kategori.split(' ');
                      
                      return Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 10),
                        child: Column(
                          children: [
                            Text(
                              words.length > 1 ? words.sublist(0, words.length - 1).join(' ') : words.first,
                              style: AppText.small(color: AppColors.dark),
                              textAlign: TextAlign.center,
                            ),
                            if (words.length > 1)
                              Text(
                                words.last,
                                style: AppText.small(color: AppColors.dark),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 500000000,
                    reservedSize: 95, // Tambah ruang untuk angka yang lebih panjang
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return SizedBox();
                      
                      // Format angka dengan pemisah ribuan
                      String formattedValue = value.toStringAsFixed(0)
                        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
                          (Match m) => '${m[1]}.');
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          formattedValue,
                          style: AppText.small(color: AppColors.dark),
                          textAlign: TextAlign.right,
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 500000000,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppColors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                },
              ),
              borderData: FlBorderData(show: false),
              barGroups: controller.pendapatanDetail.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: data['jumlah'].toDouble(),
                      color: controller.pendapatanColors[index % controller.pendapatanColors.length],
                      width: 25,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          )),
        ),
      ],
    );
  }
  
  // Widget untuk daftar detail pendapatan
  Widget _buildPendapatanDetailList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Obx(() => ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.pendapatanDetail.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppColors.grey.withOpacity(0.2),
            ),
            itemBuilder: (context, index) {
              final data = controller.pendapatanDetail[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        data['kategori'],
                        style: AppText.bodyMedium(color: AppColors.dark),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: data['persentase'] / 100,
                          backgroundColor: AppColors.grey.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            controller.pendapatanColors[index % controller.pendapatanColors.length],
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        controller.formatRupiah(data['jumlah'].toDouble()),
                        style: AppText.bodySmall(color: AppColors.dark),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
        ),
      ],
    );
  }
  
  // Widget untuk grafik belanja
  Widget _buildBelanjaChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Belanja DESA WERE 2025',
          style: AppText.h6(color: AppColors.success),
        ),
        SizedBox(height: 16),
        Container(
          height: 330, // Meningkatkan tinggi chart agar angka terlihat lebih jelas
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Obx(() => BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 1000000000, // Nilai maksimum
              minY: 0, // Memastikan nilai minimal 0
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipPadding: EdgeInsets.all(8),
                  tooltipRoundedRadius: 8,
                  getTooltipColor: (BarChartGroupData group) => Color(0xFF616161),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final data = controller.belanjaDetail[group.x.toInt()];
                    return BarTooltipItem(
                      '${data['kategori']}\n',
                      TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: controller.formatRupiah(data['jumlah'].toDouble()),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return SizedBox.shrink(); // Hide complex bottom titles for better mobile view
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 200000000,
                    reservedSize: 90, // Tambah ruang untuk angka yang lebih panjang
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return SizedBox();
                      
                      // Format angka dengan pemisah ribuan
                      String formattedValue = value.toStringAsFixed(0)
                        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
                          (Match m) => '${m[1]}.');
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          formattedValue,
                          style: AppText.small(color: AppColors.dark),
                          textAlign: TextAlign.right,
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 200000000,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppColors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                },
              ),
              borderData: FlBorderData(show: false),
              barGroups: controller.belanjaDetail.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: data['jumlah'].toDouble(),
                      color: controller.belanjaColors[index % controller.belanjaColors.length],
                      width: 25,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          )),
        ),
        // Simplified legend for complex categories
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.belanjaDetail.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: controller.belanjaColors[index % controller.belanjaColors.length],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  '${index + 1}',
                  style: AppText.small(color: AppColors.dark),
                ),
              ],
            );
          }).toList(),
        ),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: controller.belanjaDetail.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                '${index + 1}. ${data['kategori']}',
                style: AppText.small(color: AppColors.dark),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  // Widget untuk daftar detail belanja
  Widget _buildBelanjaDetailList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Obx(() => ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.belanjaDetail.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppColors.grey.withOpacity(0.2),
            ),
            itemBuilder: (context, index) {
              final data = controller.belanjaDetail[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        data['kategori'],
                        style: AppText.bodySmall(color: AppColors.dark),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: data['persentase'] / 100,
                          backgroundColor: AppColors.grey.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            controller.belanjaColors[index % controller.belanjaColors.length],
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        controller.formatRupiah(data['jumlah'].toDouble()),
                        style: AppText.bodySmall(color: AppColors.dark),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
        ),
      ],
    );
  }
  
  // Widget untuk pembiayaan
  Widget _buildPembiayaanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pembiayaan DESA WERE 2025',
          style: AppText.h6(color: AppColors.success),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Penerimaan',
                      style: AppText.bodyMedium(color: AppColors.dark),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 80,
                      child: Center(
                        child: Text(
                          'Rp0,00',
                          style: AppText.bodyLarge(color: AppColors.dark),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 100,
                width: 1,
                color: AppColors.grey.withOpacity(0.3),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Pengeluaran',
                      style: AppText.bodyMedium(color: AppColors.dark),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 80,
                      child: Center(
                        child: Text(
                          'Rp0,00',
                          style: AppText.bodyLarge(color: AppColors.dark),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Obx(() => ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.pembiayaanDetail.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppColors.grey.withOpacity(0.2),
            ),
            itemBuilder: (context, index) {
              final data = controller.pembiayaanDetail[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        data['kategori'],
                        style: AppText.bodyMedium(color: AppColors.dark),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: 0, // data['persentase'] / 100,
                          backgroundColor: AppColors.grey.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.grey,
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        controller.formatRupiah(data['jumlah'].toDouble()),
                        style: AppText.bodySmall(color: AppColors.dark),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
        ),
      ],
    );
  }
}