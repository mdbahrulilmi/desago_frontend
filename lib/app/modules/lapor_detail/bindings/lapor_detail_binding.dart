import 'package:get/get.dart';

import '../controllers/lapor_detail_controller.dart';

class LaporDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LaporDetailController>(
      () => LaporDetailController(),
    );
  }
}
