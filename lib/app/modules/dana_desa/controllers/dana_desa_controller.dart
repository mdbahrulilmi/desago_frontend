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
  

  final selectedYear = 2025.obs;

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
    queryParameters: {'desa_id': ApiConstant.desaId, 'tahun': selectedYear},
  );
  debugPrint('Dana desa raw data: ${res.data}');

  final allData = (res.data['data'] as List)
      .map((e) => AnggaranModel.fromJson(e))
      .toList();

  pendapatan.assignAll(allData.where((e) => e.kategori?.tipe == 'pendapatan'));
  belanja.assignAll(allData.where((e) => e.kategori?.tipe == 'belanja'));

  _cachedPendapatan = pendapatan.toList();
  _cachedBelanja = belanja.toList();
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
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [

              pw.Text(
                'RENCANA PENGGUNAAN DANA',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),

              pw.SizedBox(height: 4),

              pw.Text(
                '(RPD-ADD)',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),

              pw.Divider(thickness: 1),

              pw.SizedBox(height: 10),

              // ===== INFO DESA =====
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Desa : $desaNama'),
                      pw.Text('Tahun Anggaran : $selectedYear'),
                    ],
                  ),

                  pw.Text(
                    'PEMERINTAH DESA',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 20),
            ],
          ),
        ),

        pw.SizedBox(height: 20),

        // ===== PENDAPATAN =====
        pw.Text('Pendapatan', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        _pdfTable(pendapatan, profit: true),

        pw.SizedBox(height: 20),

        // ===== BELANJA =====
        pw.Text('Belanja', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        _pdfTable(belanja, profit: false),
      ],
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

pw.Widget _pdfTable(List<AnggaranModel> list, {required bool profit}) {
  final total = list.fold<num>(
    0,
    (sum, item) => sum + (item.anggaran ?? 0),
  );

  return pw.Table(
    border: pw.TableBorder.all(color: PdfColors.grey),
    columnWidths: {
      0: const pw.FlexColumnWidth(1), // No
      1: const pw.FlexColumnWidth(4), // Uraian
      2: const pw.FlexColumnWidth(2), // Anggaran
    },
    children: [

      // ===== HEADER =====
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey300),
        children: [
          _headerCell('No'),
          _headerCell('Uraian'),
          _headerCell('Anggaran', alignRight: true),
        ],
      ),

      // ===== DATA =====
      ...List.generate(list.length, (index) {
        final item = list[index];
        final level = kategoriLevel(item.kategori!);

        return pw.TableRow(
          children: [
            _cell('${index + 1}'),

            // uraian dengan indent
            pw.Padding(
              padding: pw.EdgeInsets.only(
                left: 6.0 * level,
                top: 6,
                bottom: 6,
                right: 6,
              ),
              child: pw.Text(
                item.kategori?.nama ?? '-',
                style: const pw.TextStyle(fontSize: 11),
              ),
            ),

            _cell(
              formatRupiah(item.anggaran),
              alignRight: true,
              color: profit ? PdfColors.green : PdfColors.red,
            ),
          ],
        );
      }),

      // ===== TOTAL =====
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey200),
        children: [
          _cell(''),
          _cell(
            'TOTAL',
            bold: true,
          ),
          _cell(
            formatRupiah(total),
            alignRight: true,
            bold: true,
            color: profit ? PdfColors.green : PdfColors.red,
          ),
        ],
      ),
    ],
  );
}

pw.Widget _headerCell(String text, {bool alignRight = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(6),
    child: pw.Align(
      alignment: alignRight ? pw.Alignment.centerRight : pw.Alignment.centerLeft,
      child: pw.Text(
        text,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      ),
    ),
  );
}

pw.Widget _cell(
  String text, {
  bool alignRight = false,
  bool bold = false,
  PdfColor? color,
}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(6),
    child: pw.Align(
      alignment: alignRight ? pw.Alignment.centerRight : pw.Alignment.centerLeft,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color,
        ),
      ),
    ),
  );
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
