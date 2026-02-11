import 'package:desago/app/models/LaporModel.dart';
import 'package:get/get.dart';

class LaporDetailController extends GetxController {
  Rx<LaporModel?> laporan = Rx<LaporModel?>(null);

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args != null && args['data'] != null) {
      laporan.value = args['data'] as LaporModel;
    }
  }
}


