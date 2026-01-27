import 'package:get/get.dart';

class LaporDetailController extends GetxController {
  var laporan = {}.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    print('Arguments received: $args'); 
    if (args != null && args['data'] != null) {
      laporan.value = args['data'];
    }
  }
}

