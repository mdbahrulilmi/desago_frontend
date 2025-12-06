import 'package:get/get.dart';

import '../controllers/donasi_detail_controller.dart';

class DonasiDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DonasiDetailController>(
      () => DonasiDetailController(),
    );
  }
}
