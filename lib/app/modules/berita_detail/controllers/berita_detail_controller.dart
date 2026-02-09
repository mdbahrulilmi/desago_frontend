import 'package:desago/app/models/BeritaModel.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class BeritaDetailController extends GetxController {
  late final BeritaModel berita;

  @override
  void onInit() {
    super.onInit();
    berita = Get.arguments as BeritaModel;
  }


  void toggleFavorite() {
    Get.snackbar(
      'Favorit',
      'Berita telah ditambahkan ke favorit',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

void shareBerita() {
  final id = berita.id;
  final title = berita.judul ?? 'Berita Desa';
  final fullText = berita.content ?? '';
  final maxLength = 100; 
  final excerpt = fullText.length > maxLength
    ? '${fullText.substring(0, maxLength)}...'
    : fullText;
  final link = berita.link ?? 'tidak-tersedia';

  final text = '''
$title

$excerpt

Baca selengkapnya:
$link
''';

    Share.share(
      text,
      subject: title,
    );
  }
}