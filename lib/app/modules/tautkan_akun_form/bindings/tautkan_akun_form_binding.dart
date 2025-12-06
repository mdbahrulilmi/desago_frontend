import 'package:get/get.dart';

import '../controllers/tautkan_akun_form_controller.dart';

class TautkanAkunFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TautkanAkunFormController>(
      () => TautkanAkunFormController(),
    );
  }
}
