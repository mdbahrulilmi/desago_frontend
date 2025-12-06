import 'package:get/get.dart';

import '../controllers/berita_list_controller.dart';

class BeritaListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BeritaListController>(
      () => BeritaListController(),
    );
  }
}
