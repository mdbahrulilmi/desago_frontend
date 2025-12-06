import 'package:get/get.dart';

import '../controllers/cek_bansos_hasil_controller.dart';

class CekBansosHasilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CekBansosHasilController>(
      () => CekBansosHasilController(),
    );
  }
}
