import 'package:get/get.dart';

import '../controllers/surat_list_jenis_controller.dart';

class SuratListJenisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuratListJenisController>(
      () => SuratListJenisController(),
    );
  }
}
