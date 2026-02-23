import 'package:desago/app/modules/aktivitas/controllers/aktivitas_controller.dart';
import 'package:desago/app/modules/akun/controllers/akun_controller.dart';
import 'package:desago/app/modules/berita_list/controllers/berita_list_controller.dart';
import 'package:desago/app/modules/home/controllers/home_controller.dart';
import 'package:desago/app/modules/surat_list/controllers/surat_list_controller.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SuratListController>(() => SuratListController());
    Get.lazyPut<AktivitasController>(() => AktivitasController());
    Get.lazyPut<AkunController>(() => AkunController());
    Get.lazyPut<BeritaListController>(() => BeritaListController());

  }
}