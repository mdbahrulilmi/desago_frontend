import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/BeritaModel.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/services/storage_services.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class BeritaDetailController extends GetxController {

  Rxn<BeritaModel> berita = Rxn<BeritaModel>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is BeritaModel) {
      berita.value = args;
      isLoading.value = false;
      return;
    }

    if (args is Map && args['id'] != null) {
      fetchDetail(args['id'].toString());
      return;
    }
  }

  Future<void> fetchDetail(String id) async {
    try {

      isLoading.value = true;

      final token = await StorageService.getToken();

      final res = await DioService.instance.get(
        '${ApiConstant.beritaDetail}/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (res.statusCode == 200) {
        final data = res.data['data'];
        if (data != null) {
          berita.value = BeritaModel.fromJson(data);
        } else {
        }
      }

    } on DioException catch (dioError) {
    } catch (e, stackTrace) {
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite() {
    Get.snackbar(
      'Favorit',
      'Berita telah ditambahkan ke favorit',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void shareBerita() {

    final data = berita.value;
    if (data == null) return;

    final title = data.judul ?? 'Berita Desa';
    final fullText = data.content ?? '';
    const maxLength = 100;

    final excerpt = fullText.length > maxLength
        ? '${fullText.substring(0, maxLength)}...'
        : fullText;

    final link = data.link ?? 'https://desagodigital.id';

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