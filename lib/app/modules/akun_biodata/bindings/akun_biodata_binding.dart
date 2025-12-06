import 'package:get/get.dart';

import '../controllers/akun_biodata_controller.dart';

class AkunBiodataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AkunBiodataController>(
      () => AkunBiodataController(),
    );
  }
}
