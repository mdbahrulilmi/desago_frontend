import 'package:get/get.dart';

import '../controllers/surat_list_controller.dart';

class SuratListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuratListController>(
      () => SuratListController(),
    );
  }
}
