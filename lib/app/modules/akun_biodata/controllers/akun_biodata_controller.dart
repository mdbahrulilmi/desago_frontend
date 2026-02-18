import 'package:desago/app/components/alert.dart';
import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/BiodataModel.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/services/storage_services.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class AkunBiodataController extends GetxController {

  final Rxn<BiodataModel> user = Rxn<BiodataModel>();
  final RxBool isLoading = false.obs;

  @override
    void onInit() {
      print("ON INIT KE PANGGIL");
      super.onInit();
      fetchUserData();
    }

  // ================= FETCH USER =================

  Future<void> fetchUserData() async {
    print("FETCH KE PANGGIL");
    try {
      isLoading.value = true;

      final token = StorageService.getToken();

      if (token == null) {
        Get.snackbar("Error", "Token tidak ditemukan");
        return;
      }

      final response = await DioService.instance.get(
        ApiConstant.biodata,
        options: dio.Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      user.value = BiodataModel.fromJson(response.data);

    } on dio.DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data["message"] ?? "Gagal memuat data",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ================= VERIFICATION =================

  Future<void> requestVerification() async {
    try {
      isLoading.value = true;

      final token = StorageService.getToken();

      await DioService.instance.post(
        ApiConstant.biodata,
        options: dio.Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      await AppDialog.success(
        title: 'Berhasil',
        message:
            'Permintaan verifikasi telah dikirim. Admin desa akan memverifikasi dalam 1x24 jam.',
        buttonText: 'OK',
      );

      await fetchUserData(); // refresh data

    } catch (e) {
      AppDialog.error(
        title: 'Gagal',
        message: 'Gagal mengirim permintaan verifikasi',
        buttonText: 'Tutup',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void editData() {
    Get.toNamed('/edit-biodata');
  }

  // ================= GETTER UNTUK VIEW =================

  String get nik => user.value?.nik ?? "-";
  String get nama => user.value?.namaLengkap ?? "-";
  String get tempatLahir => user.value?.tempatLahir ?? "-";
  String get tanggalLahir => user.value?.tanggalLahir ?? "-";
  String get alamat => user.value?.alamat ?? "-";
  String get agama => user.value?.agama ?? "-";
  String get pekerjaan => user.value?.pekerjaan ?? "-";
  String get statusPerkawinan => user.value?.statusPerkawinan ?? "-";
  String get kewarganegaraan => user.value?.kewarganegaraan ?? "-";
  String get golonganDarah => user.value?.golonganDarah ?? "-";
  String get berlakuHingga => user.value?.berlakuHingga ?? "-";
  String get avatar => user.value?.avatar ?? "-";
  String get jenisKelamin => user.value?.jenisKelamin ?? "-";

  bool get isVerified => user.value?.verification == "";
}
