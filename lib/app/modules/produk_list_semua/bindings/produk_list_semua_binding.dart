import 'package:get/get.dart';

import '../controllers/produk_list_semua_controller.dart';

class ProdukListSemuaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProdukListSemuaController>(
      () => ProdukListSemuaController(),
    );
  }
}
