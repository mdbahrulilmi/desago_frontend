import 'package:get/get.dart';

import '../controllers/tautkan_akun_controller.dart';

class TautkanAkunBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TautkanAkunController>(
      () => TautkanAkunController(),
    );
  }
}
