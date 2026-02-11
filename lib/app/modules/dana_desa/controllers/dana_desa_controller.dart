import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/AnggaranKategoriModel.dart';
import 'package:desago/app/models/AnggaranModel.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart'; 

class DanaDesaController extends GetxController {
  final RxList<AnggaranModel> pendapatan = <AnggaranModel>[].obs;
  final RxList<AnggaranModel> belanja = <AnggaranModel>[].obs;
  final RxString desaNama = ''.obs; 
  final Map<int, AnggaranKategoriModel> kategoriMap = {};
  final RxBool isLoading = true.obs;
  final RxBool showPendapatan = false.obs;
  final RxBool showBelanja = true.obs;

  bool _isKategoriCached = false;
  bool _isDanaDesaCached = false;
  List<AnggaranModel> _cachedPendapatan = [];
  List<AnggaranModel> _cachedBelanja = [];
  String _cachedDesaNama = '';

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  Future<void> fetchAllData({bool forceRefresh = false}) async {
    try {
      isLoading.value = true;

      if (!_isKategoriCached || forceRefresh) await fetchKategori();
      if (!_isDanaDesaCached || forceRefresh) {
        await fetchDanaDesa();
      } else {
        pendapatan.assignAll(_cachedPendapatan);
        belanja.assignAll(_cachedBelanja);
        desaNama.value = _cachedDesaNama;
      }

      debugPrint('TOTAL KATEGORI DI MAP: ${kategoriMap.length}');
    } catch (e) {
      debugPrint('Error fetchAllData: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchKategori() async {
  debugPrint('Fetching kategori...');
  final res = await DioService.instance.get(ApiConstant.anggaranKategori);
  debugPrint('Kategori raw data: ${res.data['data']}');

  final list = (res.data['data'] as List)
      .map((e) => AnggaranKategoriModel.fromJson(e))
      .toList();

  kategoriMap.clear();
  for (final k in list) kategoriMap[k.id] = k;

  _isKategoriCached = true;
  debugPrint('Kategori map cached: ${kategoriMap.length}');
}

Future<void> fetchDanaDesa() async {
  debugPrint('Fetching dana desa...');
  final res = await DioService.instance.get(ApiConstant.anggaran,
    queryParameters: {'desa_id': ApiConstant.desaId, 'tahun': 2025},
  );
  debugPrint('Dana desa raw data: ${res.data}');

  desaNama.value = res.data['desa'] ?? '-';

  final allData = (res.data['data'] as List)
      .map((e) => AnggaranModel.fromJson(e))
      .toList();

  pendapatan.assignAll(allData.where((e) => e.kategori?.tipe == 'pendapatan'));
  belanja.assignAll(allData.where((e) => e.kategori?.tipe == 'belanja'));

  _cachedPendapatan = pendapatan.toList();
  _cachedBelanja = belanja.toList();
  _cachedDesaNama = desaNama.value;
  _isDanaDesaCached = true;

  debugPrint('Pendapatan count: ${pendapatan.length}');
  debugPrint('Belanja count: ${belanja.length}');
  debugPrint('Desa nama: ${desaNama.value}');
}

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

  void togglePendapatan() => showPendapatan.toggle();
  void toggleBelanja() => showBelanja.toggle();

  int get totalPendapatan => pendapatan.fold(0, (sum, e) => sum + e.anggaran);
  int get totalBelanja => belanja.fold(0, (sum, e) => sum + e.anggaran);

  String formatRupiah(num value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }

Future<void> generatePdf() async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(20),
      build: (context) => [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            gradient: const pw.LinearGradient(
              colors: [PdfColors.red, PdfColors.deepOrange, PdfColors.red],
            ),
            borderRadius: pw.BorderRadius.circular(12),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text('Pemerintah Desa', style: pw.TextStyle(color: PdfColors.white, fontSize: 14)),
              pw.SizedBox(height: 6),
              pw.Text('Desa ${desaNama}', style: pw.TextStyle(color: PdfColors.white, fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 4),
              pw.Text('Tahun Anggaran 2025', style: pw.TextStyle(color: PdfColors.white, fontSize: 12)),
            ],
          ),
        ),

        pw.SizedBox(height: 20),

        // ===== PENDAPATAN =====
        pw.Text('Pendapatan', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        _pdfList(pendapatan, profit: true),

        pw.SizedBox(height: 20),

        // ===== BELANJA =====
        pw.Text('Belanja', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        _pdfList(belanja, profit: false),
      ],
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

pw.Widget _pdfList(List<AnggaranModel> list, {required bool profit}) {
  return pw.Column(
    children: list.map((item) {
      final level = kategoriLevel(item.kategori!);
      return pw.Padding(
        padding: pw.EdgeInsets.only(left: 20.0 * level, top: 4, bottom: 4),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Row(
              children: [
                if (level > 0)
                  pw.Container(
                    width: 12,
                    height: 12,
                    decoration: pw.BoxDecoration(
                      shape: pw.BoxShape.circle,
                      border: pw.Border.all(color: PdfColors.grey, width: 1),
                    ),
                  ),
                  pw.SizedBox(width: 4),
                pw.Text(item.kategori?.nama ?? '-', style: pw.TextStyle(fontSize: 12)),
              ],
            ),
            
            pw.Text(formatRupiah(item.anggaran), 
                style: pw.TextStyle(
                  fontSize: 12,
                  color: profit ? PdfColors.green : PdfColors.red,
                  fontWeight: pw.FontWeight.bold,
                )),
          ],
        ),
      );
    }).toList(),
  );
}

}
