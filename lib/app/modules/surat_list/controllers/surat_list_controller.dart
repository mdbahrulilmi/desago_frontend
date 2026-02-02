import 'dart:convert';
import 'package:get/get.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/constant/api_constant.dart';

class SuratListController extends GetxController {
  final isLoading = true.obs;
  final jenisSuratList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchJenisSurat();
  }

  Future<void> fetchJenisSurat() async {
    try {
      isLoading.value = true;

      final response = await DioService.instance.get(ApiConstant.jenisSurat);

      dynamic raw = response.data;
      List listData = [];

      if (raw is List) {
        listData = raw;
      } 
      else if (raw is Map) {
        if (raw['data'] is List) {
          listData = raw['data'];
        } 
        else if (raw['data'] is String) {
          listData = jsonDecode(raw['data']);
        }
      }

      jenisSuratList.assignAll(
        listData.map((e) => Map<String, dynamic>.from(e)).toList(),
      );

      print('Jenis surat loaded: ${jenisSuratList.length}');
    } catch (e, s) {
      print('fetchJenisSurat error: $e');
      print(s);
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToDetail(Map<String, dynamic> surat) {
  Get.toNamed(
    '/surat-form',
    arguments: {
      'suratId': surat['id'].toString(),       // pastikan string
      'suratTitle': surat['nama'].toString(),  // pastikan string
      'suratData': surat,
    },
  );
}

}
