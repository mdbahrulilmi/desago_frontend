import 'package:desago/app/routes/app_pages.dart';
import 'package:get/get.dart';

class MethodResetPasswordController extends GetxController {
  void onEmailMethodSelected() {
    Get.toNamed(Routes.LUPA_PASSWORD);
  }

  void onWhatsAppMethodSelected() {
    Get.toNamed(Routes.LUPA_PASSWORD_WA);
  }
}
