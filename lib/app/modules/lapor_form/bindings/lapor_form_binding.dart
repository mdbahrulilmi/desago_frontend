import 'package:get/get.dart';

import '../controllers/lapor_form_controller.dart';

class LaporFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LaporFormController>(
      () => LaporFormController(),
    );
  }
}
