import 'package:get/get.dart';

import '../controllers/agenda_detail_controller.dart';

class AgendaDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgendaDetailController>(
      () => AgendaDetailController(),
    );
  }
}
