  import 'package:desago/app/constant/api_constant.dart';
  import 'package:desago/app/models/LaporModel.dart';
  import 'package:desago/app/services/dio_services.dart';
  import 'package:desago/app/services/storage_services.dart';
  import 'package:dio/dio.dart';
  import 'package:get/get.dart';

  class LaporDetailController extends GetxController {
    Rx<LaporModel?> laporan = Rx<LaporModel?>(null);
    RxBool isLoading = false.obs;

    @override
    @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    print("===== ON INIT =====");
    print("ARGS: $args");
    print("ARGS TYPE: ${args.runtimeType}");

    if (args != null) {
      print("ARGS DATA: ${args['data']}");
      print("ARGS ID: ${args['id']}");

      if (args['data'] != null) {
        print("MASUK DARI RIWAYAT");
        laporan.value = args['data'] as LaporModel;
      } else if (args['id'] != null) {
        print("MASUK DARI NOTIFIKASI");
        fetchDetail(args['id'].toString());
      } else {
        print("❌ ARGS ADA TAPI ID NULL");
      }
    } else {
      print("❌ ARGS NULL TOTAL");
    }
  }

    Future<void> fetchDetail(String id) async {
    try {
      print("===== FETCH DETAIL START =====");
      print("ID: $id");

      isLoading.value = true;

      final token = await StorageService.getToken();

      final res = await DioService.instance.get(
        '${ApiConstant.laporDetail}/$id',
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
        if (res.data == null) {
          print("❌ RESPONSE DATA NULL");
          laporan.value = null;
          return;
        }

        // 🔥 INI YANG PENTING
        final responseData = res.data;

        if (responseData['data'] == null) {
          print("❌ DATA FIELD NULL");
          laporan.value = null;
          return;
        }

        final laporJson = responseData['data'];

        laporan.value = LaporModel.fromJson(laporJson);

        print("✅ PARSE SUCCESS");
        print("JUDUL: ${laporan.value?.judul}");
      }

    } on DioException catch (dioError) {
      print("❌ DIO ERROR");
      print("MESSAGE: ${dioError.message}");
      print("STATUS: ${dioError.response?.statusCode}");
      print("DATA: ${dioError.response?.data}");
    } catch (e, stackTrace) {
      print("❌ UNKNOWN ERROR: $e");
      print(stackTrace);
    } finally {
      isLoading.value = false;
      print("===== FETCH DETAIL END =====");
    }
  }
  }

