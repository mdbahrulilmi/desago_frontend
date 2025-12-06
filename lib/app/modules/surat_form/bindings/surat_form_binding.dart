import 'package:get/get.dart';

import '../controllers/surat_form_controller.dart';

class SuratFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuratFormController>(
      () => SuratFormController(),
    );
  }
}
