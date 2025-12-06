import 'package:get/get.dart';

class CekBansosHasilController extends GetxController {
  // Variabel untuk menyimpan hasil pencarian
  final hasilList = <Map<String, dynamic>>[].obs;
  
  // Variabel untuk menyimpan informasi wilayah
  final wilayah = <String, String>{}.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadData();
  }
  
  // Method untuk memuat data dari argumen
  void _loadData() {
    if (Get.arguments != null) {
      // Mendapatkan hasil pencarian
      if (Get.arguments['hasil'] != null) {
        hasilList.assignAll(Get.arguments['hasil']);
      }
      
      // Mendapatkan informasi wilayah
      if (Get.arguments['wilayah'] != null) {
        wilayah.assignAll(Get.arguments['wilayah']);
      }
    }
  }
}