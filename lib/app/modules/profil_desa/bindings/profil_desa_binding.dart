import 'package:get/get.dart';

import '../controllers/profil_desa_controller.dart';

class ProfilDesaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilDesaController>(
      () => ProfilDesaController(),
    );
  }
}
