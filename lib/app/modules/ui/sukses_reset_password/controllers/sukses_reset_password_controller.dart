import 'package:desago/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SuksesResetPasswordController extends GetxController {
  void onBackToLogin() {
    Get.offAllNamed(Routes.LOGIN);
  }
}
