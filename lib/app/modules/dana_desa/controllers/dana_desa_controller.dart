import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DanaDesaController extends GetxController {

final RxList<Map<String, dynamic>> apbn_pendapatan = <Map<String, dynamic>>[].obs;
final RxList<Map<String, dynamic>> apbn_pengeluaran = <Map<String, dynamic>>[].obs;

var isLoading = true.obs;

@override
void onInit() {
  fetchDanaDesa();
  super.onInit();
}

Future<void> fetchDanaDesa() async {
  try {
      isLoading.value = true;
      final res = await DioService.instance.get(ApiConstant.danaDesa);

      final pendapatan =
          List<Map<String, dynamic>>.from(res.data['dana_desa']['pendapatan']);

      final belanja =
          List<Map<String, dynamic>>.from(res.data['dana_desa']['belanja']);

      apbn_pendapatan.assignAll(pendapatan);
      apbn_pengeluaran.assignAll(belanja);

    } catch (e) {
      print("Error fetchDanaDesa: $e");
    } finally {
      isLoading.value = false;
    }
}

int get totalPendapatan {
    return apbn_pendapatan.fold<int>(
      0,
      (sum, item) => sum + (item['anggaran'] as num).toInt(),
    );
  }

  int get totalBelanja {
    return apbn_pengeluaran.fold<int>(
      0,
      (sum, item) => sum + (item['anggaran'] as num).toInt(),
    );
  }

  String formatRupiah(num value) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

}