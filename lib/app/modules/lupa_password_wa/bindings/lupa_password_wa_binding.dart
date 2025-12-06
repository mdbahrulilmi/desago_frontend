import 'package:get/get.dart';

import '../controllers/lupa_password_wa_controller.dart';

class LupaPasswordWaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LupaPasswordWaController>(
      () => LupaPasswordWaController(),
    );
  }
}
