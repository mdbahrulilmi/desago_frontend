import 'package:get/get.dart';

class BeritaDetailController extends GetxController {
  // Reactive variable untuk menyimpan detail berita
  final Rx<Map<String, dynamic>> berita = Rx<Map<String, dynamic>>({});

  @override
  void onInit() {
    super.onInit();
    // Ambil argumen berita yang dikirim dari halaman sebelumnya
    final arguments = Get.arguments;
    if (arguments != null) {
      berita.value = arguments;
      // Increment views
      berita.value['views'] = (berita.value['views'] ?? 0) + 1;
    }
  }

  // Metode untuk berbagi berita
  void shareBerita() {
    // Implementasi berbagi berita
    Get.snackbar(
      'Berbagi Berita',
      'Fitur berbagi sedang dikembangkan',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Metode untuk menandai sebagai favorit
  void toggleFavorite() {
    // Implementasi toggle favorit
    Get.snackbar(
      'Favorit',
      'Berita telah ditambahkan ke favorit',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}