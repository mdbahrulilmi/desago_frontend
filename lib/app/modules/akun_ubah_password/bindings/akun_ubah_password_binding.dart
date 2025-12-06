import 'package:get/get.dart';

import '../controllers/akun_ubah_password_controller.dart';

class AkunUbahPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AkunUbahPasswordController>(
      () => AkunUbahPasswordController(),
    );
  }
}
