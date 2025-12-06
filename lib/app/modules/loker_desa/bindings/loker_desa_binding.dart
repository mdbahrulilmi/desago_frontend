import 'package:get/get.dart';

import '../controllers/loker_desa_controller.dart';

class LokerDesaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LokerDesaController>(
      () => LokerDesaController(),
    );
  }
}
