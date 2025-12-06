import 'package:get/get.dart';

import '../controllers/loker_desa_detail_controller.dart';

class LokerDesaDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LokerDesaDetailController>(
      () => LokerDesaDetailController(),
    );
  }
}
