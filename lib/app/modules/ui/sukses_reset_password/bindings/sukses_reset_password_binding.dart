import 'package:get/get.dart';

import '../controllers/sukses_reset_password_controller.dart';

class SuksesResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuksesResetPasswordController>(
      () => SuksesResetPasswordController(),
    );
  }
}
