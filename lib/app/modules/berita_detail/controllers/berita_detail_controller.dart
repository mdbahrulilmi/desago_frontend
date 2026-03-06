import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/BeritaModel.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/services/storage_services.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class BeritaDetailController extends GetxController {

  /// STATE aman
  Rxn<BeritaModel> berita = Rxn<BeritaModel>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    print("===== ON INIT BERITA =====");
    print("ARGS: $args");

    // dari list berita
    if (args is BeritaModel) {
      print("MASUK DARI LIST BERITA");
      berita.value = args;
      isLoading.value = false;
      return;
    }

    // dari notifikasi
    if (args is Map && args['id'] != null) {
      print("MASUK DARI NOTIFIKASI");
      fetchDetail(args['id'].toString());
      return;
    }

    print("❌ ARGUMENT TIDAK VALID");
  }

  Future<void> fetchDetail(String id) async {
    try {

      isLoading.value = true;

      print("===== FETCH DETAIL BERITA START =====");
      print("ID: $id");

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

      print("STATUS CODE: ${res.statusCode}");
      print("RAW RESPONSE: ${res.data}");

      if (res.statusCode == 200) {
        final data = res.data['data'];
        if (data != null) {
          berita.value = BeritaModel.fromJson(data);
          print("✅ BERITA DIMUAT: ${berita.value?.judul}");
        } else {
          print("❌ DATA NULL");
        }
      }

    } on DioException catch (dioError) {
      print("❌ DIO ERROR: ${dioError.message}");
    } catch (e, stackTrace) {
      print("❌ UNKNOWN ERROR: $e");
      print(stackTrace);
    } finally {
      isLoading.value = false;
      print("===== FETCH DETAIL BERITA END =====");
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