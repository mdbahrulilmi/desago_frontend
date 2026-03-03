import 'package:desago/app/modules/surat_list/controllers/surat_list_controller.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  static BottomNavigationController get to => Get.find();

  final RxInt selectedIndex = 0.obs;

  final List<String> indexToRoute = [
    Routes.HOME,
    Routes.SURAT_FORM,
    Routes.AKTIVITAS,
    Routes.AKUN,
  ];

  final String laporRoute = Routes.LAPOR;

  final List<String> pageNames = [
    'Beranda',
    'Surat',
    'Aktivitas',
    'Akun',
  ];

  @override
  void onInit() {
    super.onInit();
    final currentRoute = Get.currentRoute;
    final index = indexToRoute.indexOf(currentRoute);
    if (index != -1) {
      selectedIndex.value = index;
    }
  }

  void changePage(int index) {
    selectedIndex.value = index;

    if (index != 2) {
      if (Get.isRegistered<SuratListController>()) {
        Get.find<SuratListController>().resetState();
      }
    }
  }

  void navigateToLapor() {
    Get.toNamed(laporRoute);
  }

  bool isActive(int index) => selectedIndex.value == index;
}
