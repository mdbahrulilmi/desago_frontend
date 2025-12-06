import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DanaDesaController extends GetxController {
  // Tahun yang dipilih
  final selectedYear = '2025'.obs;
  final years = ['2021', '2022', '2023', '2024', '2025'].obs;

  // Data untuk pendapatan dan belanja
  final pendapatan = RxDouble(4214594880);
  final belanja = RxDouble(1690875236);
  final penerimaan = RxDouble(0);
  final pengeluaran = RxDouble(0);
  final surplus = RxDouble(2523719644);

  // Data untuk chart pendapatan dan belanja per tahun
  final pendapatanTahunan = <Map<String, dynamic>>[
    {'tahun': '2021', 'pendapatan': 0, 'belanja': 1000000000},
    {'tahun': '2022', 'pendapatan': 0, 'belanja': 895100000},
    {'tahun': '2023', 'pendapatan': 1481617284, 'belanja': 1284395711},
    {'tahun': '2024', 'pendapatan': 2022772105, 'belanja': 1691945520},
    {'tahun': '2025', 'pendapatan': 4214594880, 'belanja': 1690875236},
  ].obs;

  // Data untuk rincian pendapatan tahun 2025
  final pendapatanDetail = <Map<String, dynamic>>[
    {'kategori': 'Pendapatan Asli Desa', 'jumlah': 355000000, 'persentase': 8.4},
    {'kategori': 'Pendapatan Transfer', 'jumlah': 2729594880, 'persentase': 64.8},
    {'kategori': 'Pendapatan Lain-lain', 'jumlah': 1130000000, 'persentase': 26.8},
  ].obs;

  // Data untuk rincian belanja tahun 2025
  final belanjaDetail = <Map<String, dynamic>>[
    {'kategori': 'Penyelenggaraan Pemerintahan Desa', 'jumlah': 901711676, 'persentase': 53.3},
    {'kategori': 'Pelaksanaan Pembangunan Desa', 'jumlah': 304143040, 'persentase': 18.0},
    {'kategori': 'Pembinaan Kemasyarakatan Desa', 'jumlah': 87290520, 'persentase': 5.2},
    {'kategori': 'Pemberdayaan Masyarakat Desa', 'jumlah': 224930000, 'persentase': 13.3},
    {'kategori': 'Penanggulangan Bencana, Keadaan Darurat, dan Keadaan Mendesak Desa', 'jumlah': 172800000, 'persentase': 10.2},
  ].obs;

  // Data untuk pembiayaan
  final pembiayaanDetail = <Map<String, dynamic>>[
    {'kategori': 'Penerimaan', 'jumlah': 0, 'persentase': 0},
    {'kategori': 'Pengeluaran', 'jumlah': 0, 'persentase': 0},
  ].obs;

  // Warna untuk chart
  final pendapatanColor = Color(0xFF47A03E);
  final belanjaColor = Color(0xFFAFE78D);
  final pendapatanColors = [
    Color(0xFF47A03E), // Hijau tua untuk Pendapatan Asli Desa
    Color(0xFF1FAB3F), // Hijau normal untuk Pendapatan Transfer
    Color(0xFF7CCC64), // Hijau muda untuk Pendapatan Lain-lain
  ];
  final belanjaColors = [
    Color(0xFFA6E070), // Hijau muda
    Color(0xFFBEE897),
    Color(0xFFCAEDAA),
    Color(0xFFD6F2BC),
    Color(0xFFE2F7CE),
  ];

  void changeYear(String year) {
    selectedYear.value = year;
    // Di implementasi sebenarnya, di sini akan memuat data berdasarkan tahun
    // yang dipilih dari API atau lokal.
  }

  // Buat data untuk bar chart perbandingan pendapatan dan belanja
  List<BarChartGroupData> getPendapatanBelanjaBarGroups() {
    return pendapatanTahunan.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data['pendapatan'].toDouble(),
            color: pendapatanColor,
            width: 15,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
          BarChartRodData(
            toY: data['belanja'].toDouble(),
            color: belanjaColor,
            width: 15,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
      );
    }).toList();
  }

  // Mendapatkan label untuk x-axis pada bar chart
 List<String> getXAxisLabels() {
    return pendapatanTahunan.map((data) => data['tahun'].toString()).toList();
  }
  // Format angka menjadi format rupiah
  String formatRupiah(double nominal) {
    if (nominal == 0) return 'Rp0';
    
    // Memformat angka sebagai string dengan pemisah ribuan
    String result = nominal.toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    
    return 'Rp$result';
  }
}