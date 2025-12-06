import 'package:get/get.dart';

import '../controllers/surat_petunjuk_controller.dart';

class SuratPetunjukBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuratPetunjukController>(
      () => SuratPetunjukController(),
    );
  }
}
