import 'package:get/get.dart';

import '../controllers/akun_edit_controller.dart';

class AkunEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AkunEditController>(
      () => AkunEditController(),
    );
  }
}
