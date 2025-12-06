import 'package:get/get.dart';

import '../controllers/dana_desa_controller.dart';

class DanaDesaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DanaDesaController>(
      () => DanaDesaController(),
    );
  }
}
