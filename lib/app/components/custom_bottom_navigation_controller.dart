import 'package:desago/app/routes/app_pages.dart';
import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  static BottomNavigationController get to => Get.find();

  final RxInt selectedIndex = 0.obs;

  final List<String> indexToRoute = [
   Routes.HOME,
   Routes.SURAT_PETUNJUK,
   Routes.BERITA_LIST,
   Routes.AKUN
  ];

  final String laporRoute = Routes.LAPOR;


  final List<String> pageNames = [
    'Beranda',
    'Surat',
    'Berita',
    'Akun'
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

  void changePage(int index, {bool useOffAll = true}) {
    if (index >= 0 && index < indexToRoute.length) {
      selectedIndex.value = index;
      if (useOffAll) {
        Get.offAllNamed(indexToRoute[index]);
      } else {
        Get.toNamed(indexToRoute[index]);
      }
    }
  }


  void navigateToLapor() {
    Get.toNamed(laporRoute);
  }

  void navigateToRoute(String route) {
    int index = indexToRoute.indexOf(route);
    if (index != -1) {
      selectedIndex.value = index;
      Get.toNamed(route);
    }
  }

  int getIndexFromRoute(String route) {
    return indexToRoute.indexOf(route);
  }

  String getPageName(int index) {
    if (index >= 0 && index < pageNames.length) {
      return pageNames[index];
    }
    return '';
  }

  bool isActiveRoute(String route) {
    return Get.currentRoute == route;
  }
}