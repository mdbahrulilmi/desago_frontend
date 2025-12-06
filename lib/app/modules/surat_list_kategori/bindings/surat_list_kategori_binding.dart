import 'package:get/get.dart';

import '../controllers/surat_list_kategori_controller.dart';

class SuratListKategoriBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuratListKategoriController>(
      () => SuratListKategoriController(),
    );
  }
}
