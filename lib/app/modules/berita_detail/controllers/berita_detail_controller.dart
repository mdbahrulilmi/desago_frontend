import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class BeritaDetailController extends GetxController {
  final Rx<Map<String, dynamic>> berita = Rx<Map<String, dynamic>>({});

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      berita.value = arguments;
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
  final id = berita['no'];
  final title = berita['judul'] ?? 'Berita Desa';
  final fullText = berita['isi'] ?? '';
  final maxLength = 100; 
  final excerpt = fullText.length > maxLength
    ? '${fullText.substring(0, maxLength)}...'
    : fullText;
  final link = berita['link'] ?? 'tidak-tersedia';

  final text = '''
$title

$excerpt

Baca selengkapnya:
https://desatinggo.id/berita/detail/$id/$link
''';

    Share.share(
      text,
      subject: title,
    );
  }
}