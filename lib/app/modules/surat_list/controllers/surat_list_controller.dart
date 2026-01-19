import 'package:get/get.dart';

class SuratListController extends GetxController {
  final isLoading = true.obs;
  final jenisSuratList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchJenisSurat();
  }

  void fetchJenisSurat() {
    isLoading.value = true;

    // LANGSUNG AMBIL SURAT KETERANGAN
    jenisSuratList.value = _getSuratKeteranganList();

    isLoading.value = false;
  }

  void navigateToDetail(Map<String, dynamic> surat) {
    Get.toNamed('/surat-form', arguments: {
      'suratId': surat['id'],
      'suratTitle': surat['title'],
      'suratData': surat,
    });
  }

  // ================= DATA =================
  List<Map<String, dynamic>> _getSuratKeteranganList() {
    return [
      {
        'id': 'k1',
        'title': 'Surat Keterangan Format Bebas',
        'description': 'Surat keterangan dengan format bebas sesuai kebutuhan',
        'estimasi': '3 hari kerja'
      },
      {
        'id': 'k2',
        'title': 'Surat Keterangan Asal-Usul',
        'description': 'Surat yang menerangkan asal-usul seseorang',
        'estimasi': '3 hari kerja'
      },
    ];
  }
}
