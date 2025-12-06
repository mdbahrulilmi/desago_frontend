import 'package:get/get.dart';

import '../controllers/akun_pengaturan_controller.dart';

class AkunPengaturanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AkunPengaturanController>(
      () => AkunPengaturanController(),
    );
  }
}
