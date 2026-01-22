import 'package:get/get.dart';
// import 'package:share_plus/share_plus.dart';

class BeritaDetailController extends GetxController {
  final Rx<Map<String, dynamic>> berita = Rx<Map<String, dynamic>>({});

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      berita.value = arguments;
      print(berita.value["user_desa"]);
      berita.value['views'] = (berita.value['views'] ?? 0) + 1;
    }
  }

  void toggleFavorite() {
    Get.snackbar(
      'Favorit',
      'Berita telah ditambahkan ke favorit',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

void shareBerita(Map<String, dynamic> berita) {
    final raw = berita['raw'];

    final text = '''
    ${berita['title']}

    ${berita['excerpt']}

  Baca selengkapnya:
  https://desatinggo.id/berita/${raw['slug']}
  ''';

    // Share.share(
    //   text,
    //   subject: berita['title'],
    // );
  }
}