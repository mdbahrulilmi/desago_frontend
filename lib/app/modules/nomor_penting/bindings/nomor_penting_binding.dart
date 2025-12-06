import 'package:get/get.dart';

import '../controllers/nomor_penting_controller.dart';

class NomorPentingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NomorPentingController>(
      () => NomorPentingController(),
    );
  }
}
