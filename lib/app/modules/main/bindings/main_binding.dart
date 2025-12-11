import 'package:desago/app/modules/akun/controllers/akun_controller.dart';
import 'package:desago/app/modules/berita_list/controllers/berita_list_controller.dart';
import 'package:desago/app/modules/home/controllers/home_controller.dart';
import 'package:desago/app/modules/surat_petunjuk/controllers/surat_petunjuk_controller.dart';
import 'package:get/get.dart';

import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      () => MainController(),
    );

    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<SuratPetunjukController>(() => SuratPetunjukController(), fenix: true);
    Get.lazyPut<BeritaListController>(() => BeritaListController(), fenix: true);
    Get.lazyPut<AkunController>(() => AkunController(), fenix: true);
  }
}
