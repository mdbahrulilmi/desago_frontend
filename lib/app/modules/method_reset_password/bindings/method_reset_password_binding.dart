import 'package:get/get.dart';

import '../controllers/method_reset_password_controller.dart';

class MethodResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MethodResetPasswordController>(
      () => MethodResetPasswordController(),
    );
  }
}
