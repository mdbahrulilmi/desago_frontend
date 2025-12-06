import 'package:get/get.dart';

import '../controllers/cek_bansos_controller.dart';

class CekBansosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CekBansosController>(
      () => CekBansosController(),
    );
  }
}
