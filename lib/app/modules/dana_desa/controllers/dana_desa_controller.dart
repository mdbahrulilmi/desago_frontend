import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/AnggaranKategoriModel.dart';
import 'package:desago/app/models/AnggaranModel.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart'; 
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class DanaDesaController extends GetxController {

  final box = GetStorage();

  final RxList<AnggaranModel> pendapatan = <AnggaranModel>[].obs;
  final RxList<AnggaranModel> belanja = <AnggaranModel>[].obs;
  final RxString desaNama = ''.obs;

  final Map<int, AnggaranKategoriModel> kategoriMap = {};

  final RxBool isLoading = true.obs;
  final RxBool showPendapatan = false.obs;
  final RxBool showBelanja = true.obs;

  final selectedYear = DateTime.now().year.obs;

  String get _kategoriKey => 'kategori_cache';
  String get _tahunKey => 'dana_desa_${selectedYear.value}';

  @override
  void onInit() {
    super.onInit();

    // kalau tahun berubah → reload data
    ever(selectedYear, (_) {
      fetchAllData();
    });

    fetchAllData();
  }

  // ===========================
  // FETCH ALL
  // ===========================

  Future<void> fetchAllData({bool forceRefresh = false}) async {
    try {
      isLoading.value = true;

      await fetchKategori(forceRefresh: forceRefresh);
      await fetchDanaDesa(forceRefresh: forceRefresh);

    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================
  // KATEGORI CACHE
  // ===========================

  Future<void> fetchKategori({bool forceRefresh = false}) async {

    if (!forceRefresh && box.hasData(_kategoriKey)) {

      final cached = jsonDecode(box.read(_kategoriKey));
      final list = (cached as List)
          .map((e) => AnggaranKategoriModel.fromJson(e))
          .toList();

      kategoriMap.clear();
      for (final k in list) {
        kategoriMap[k.id] = k;
      }
      return;
    }
    final res = await DioService.instance.get(ApiConstant.anggaranKategori);

    final raw = res.data['data'];

    final list = (raw as List)
        .map((e) => AnggaranKategoriModel.fromJson(e))
        .toList();

    kategoriMap.clear();
    for (final k in list) {
      kategoriMap[k.id] = k;
    }

    box.write(_kategoriKey, jsonEncode(raw));
  }

  // ===========================
  // DANA DESA CACHE PER TAHUN
  // ===========================

 Future<void> fetchDanaDesa({bool forceRefresh = false}) async {

  // 🔥 1️⃣ LOAD CACHE DULU (kalau ada)
  if (box.hasData(_tahunKey)) {

    final cached = jsonDecode(box.read(_tahunKey));

    if (desaNama.value.isEmpty) {
      desaNama.value = cached['desa'] ?? '';
    }

    final list = (cached['data'] as List)
        .map((e) => AnggaranModel.fromJson(e))
        .toList();

    pendapatan.assignAll(
        list.where((e) => e.kategori?.tipe == 'pendapatan'));

    belanja.assignAll(
        list.where((e) => e.kategori?.tipe == 'belanja'));
  }

  try {
    final res = await DioService.instance.get(
      ApiConstant.anggaran,
      queryParameters: {
        'desa_id': ApiConstant.desaId,
        'tahun': selectedYear.value,
      },
    );

    if (desaNama.value.isEmpty) {
      desaNama.value = res.data['desa'] ?? '';
    }

    final raw = res.data['data'] ?? [];

    final allData = (raw as List)
        .map((e) => AnggaranModel.fromJson(e))
        .toList();

    pendapatan.assignAll(
        allData.where((e) => e.kategori?.tipe == 'pendapatan'));

    belanja.assignAll(
        allData.where((e) => e.kategori?.tipe == 'belanja'));

    // 🔥 UPDATE CACHE
    box.write(_tahunKey, jsonEncode({
      'desa': desaNama.value,
      'data': raw,
    }));

  } catch (e) {
  }
}
  // HELPER
  // ===========================

  int kategoriLevel(AnggaranKategoriModel kategori) {
    int level = 0;
    AnggaranKategoriModel? current = kategori;

    while (current?.parentId != null) {
      final parent = kategoriMap[current!.parentId!];
      if (parent == null) break;
      level++;
      current = parent;
      if (level >= 5) break;
    }
    return level;
  }

  int totalByKategori(int kategoriId) {
    int total = 0;

    final allData = [...pendapatan, ...belanja];

    for (final item in allData) {
      if (item.kategori?.id == kategoriId) {
        total += (item.anggaran ?? 0).toInt();
      }
    }

    for (final item in allData) {
      if (item.kategori?.parentId == kategoriId) {
        total += totalByKategori(item.kategori!.id);
      }
    }

    return total;
  }

  void togglePendapatan() => showPendapatan.toggle();
  void toggleBelanja() => showBelanja.toggle();

  int get totalPendapatan =>
      pendapatan.fold(0, (sum, e) => sum + (e.anggaran ?? 0));

  int get totalBelanja =>
      belanja.fold(0, (sum, e) => sum + (e.anggaran ?? 0));

  String formatRupiah(num value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }
  
pw.Widget _infoCard(String title, String value, PdfColor color) {
  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(vertical: 6),
    padding: const pw.EdgeInsets.all(12),
    decoration: pw.BoxDecoration(
      color: color,
      borderRadius: pw.BorderRadius.circular(8),
    ),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            color: PdfColors.white,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            color: PdfColors.white,
            fontWeight: pw.FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}

  Future<void> generatePdf() async {
  final pdf = pw.Document();

  final bg = await imageFromAssetBundle('assets/background/dana_desa_pdf.jpg');

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (context) {
        return pw.Stack(
          children: [
            pw.Positioned.fill(
              child: pw.Image(bg, fit: pw.BoxFit.cover),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(24),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 40),

                  pw.Center(
                    child: pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              'APB',
                              style: pw.TextStyle(
                                fontSize: 34,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.black,
                              ),
                            ),
                            pw.Text(
                              ' DESA',
                              style: pw.TextStyle(
                                fontSize: 34,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.red,
                              ),
                            ),
                          ]
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                        pw.Text(
                          desaNama.value,
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          ' ${selectedYear.value}',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            ),
                        )]),
                      ],
                    ),
                  ),
                  

                  pw.SizedBox(height: 30),
                  _bigNumber(
                    'Total Pendapatan',
                    totalPendapatan,
                    PdfColors.teal,
                  ),
                  pw.SizedBox(height: 10),

                  ...pendapatan.take(6).map((e) => _rowItem(
                        e.kategori?.nama ?? '-',
                        e.anggaran ?? 0,
                      )),

                  pw.SizedBox(height: 20),

                  _bigNumber(
                    'Total Belanja',
                    totalBelanja,
                    PdfColors.red,
                  ),

                  pw.SizedBox(height: 20),

                  pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                              _sectionBox(
                                'Penyelenggaraan Pemerintahan',
                                totalByKategori(10),
                                PdfColors.blue,
                              ),
                              _sectionDetail(byKategori(10)),

                              _sectionBox(
                                'Pelaksanaan Pembangunan',
                                totalByKategori(11),
                                PdfColors.green,
                              ),
                              _sectionDetail(byKategori(11)),

                              _sectionBox(
                                'Pemberdayaan Masyarakat',
                                totalByKategori(13),
                                PdfColors.red,
                              ),
                              _sectionDetail(byKategori(13)),
                        ],
                      ),
                    ),

                    pw.SizedBox(width: 12),

                    pw.Expanded(
                      child: pw.Column(
                          children: [
                            _sectionBox(
                              'Pembinaan Masyarakat',
                              totalByKategori(12),
                              PdfColors.orange,
                            ),
                            _sectionDetail(byKategori(12)),

                            _sectionBox(
                              'Penanggulangan Bencana',
                              totalByKategori(14),
                              PdfColors.teal,
                            ),
                            _sectionDetail(byKategori(14)),
                          ],
                        ),
                    ),
                  ],
                )
                 
                ],
              ),
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (format) async => pdf.save(),
  );
}

pw.Widget _bigNumber(String title, num value, PdfColor color) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 24,
          fontWeight: pw.FontWeight.bold,
          color: color,
        ),
      ),
      pw.Text(
        formatRupiah(value),
        style: pw.TextStyle(
          fontSize: 24,
          fontWeight: pw.FontWeight.bold,
          color: color,
        ),
      ),
    ],
  );
}
pw.Widget _rowItem(String title, num value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(title, style: const pw.TextStyle(fontSize: 18)),
        pw.Text(formatRupiah(value),
            style: const pw.TextStyle(fontSize: 18)),
      ],
    ),
  );
}
pw.Widget _sectionBox(String title, num value, PdfColor color) {
  return pw.Container(
    width: double.infinity,
    margin: const pw.EdgeInsets.symmetric(vertical: 6),
    padding: const pw.EdgeInsets.all(10),
    decoration: pw.BoxDecoration(
      color: color,
      borderRadius: pw.BorderRadius.circular(10),
    ),
    child: pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            color: PdfColors.white,
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          formatRupiah(value),
          style: pw.TextStyle(
            fontSize: 20,
            color: PdfColors.white,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

List<AnggaranModel> byKategori(int kategoriId) {
  final kategoriIds = <int>{};

  void collectKategori(int id) {
    kategoriIds.add(id);

    for (final k in kategoriMap.values) {
      if (k.parentId == id) {
        collectKategori(k.id);
      }
    }
  }

  collectKategori(kategoriId);

  return belanja
      .where((e) => kategoriIds.contains(e.kategori?.id))
      .toList();
}

pw.Widget _sectionDetail(List<AnggaranModel> items) {
  return pw.Container(
    width: double.infinity,
    margin: const pw.EdgeInsets.only(bottom: 10),
    padding: const pw.EdgeInsets.all(8),
    decoration: pw.BoxDecoration(
      color: PdfColors.white,
      borderRadius: pw.BorderRadius.circular(8),
      border: pw.Border.all(color: PdfColors.grey300),
    ),
    child: pw.Column(
      children: items.map((e) {
        return pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 2),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  e.kategori?.nama ?? '-',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
              pw.Text(
                formatRupiah(e.anggaran ?? 0),
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}
}
