import 'package:get/get.dart';

import '../controllers/lapor_riwayat_controller.dart';

class LaporRiwayatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LaporRiwayatController>(
      () => LaporRiwayatController(),
    );
  }
}
