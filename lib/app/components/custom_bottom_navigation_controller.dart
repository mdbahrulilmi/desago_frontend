import 'package:desago/app/routes/app_pages.dart';
import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  static BottomNavigationController get to => Get.find();

  final RxInt selectedIndex = 0.obs;

  /// WAJIB 1–1 dengan urutan bottom nav
  final List<String> indexToRoute = [
    Routes.HOME,
    Routes.BERITA_LIST,
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
    if (index == selectedIndex.value) return;

    selectedIndex.value = index;
  }

  void navigateToLapor() {
    Get.toNamed(laporRoute);
  }

  bool isActive(int index) => selectedIndex.value == index;
}
