import 'dart:io';
import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/controllers/auth_controller.dart';
import 'package:desago/app/modules/akun/controllers/akun_controller.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/services/storage_services.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TautkanAkunFormController extends GetxController {

  final nikController = TextEditingController();
  final namaController = TextEditingController();
  final tanggalLahirController = TextEditingController();
  final tempatLahirController = TextEditingController();
  final statusPerkawinanController = TextEditingController();
  final agamaController = TextEditingController();
  final alamatController = TextEditingController();
  final pekerjaanController = TextEditingController();
  final berlakuHinggaController = TextEditingController();
  final nokkController = TextEditingController();
  final jenisKelaminController = TextEditingController();
  final golonganDarahController = TextEditingController();
  final kewarganegaraanController = TextEditingController();
  final ktpImage = Rx<File?>(null);
  final kkImage = Rx<File?>(null);

  final isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();
  
  final authController = Get.put(AuthController());

  Future<void> pickImage(bool isKTP) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) {
      return;
    }

    if (isKTP) {
      ktpImage.value = File(image.path);
    } else {
      kkImage.value = File(image.path);
    }
  }

  void clearKtpImage() => ktpImage.value = null;
  void clearKkImage() => kkImage.value = null;

  Future<void> submit() async {

    if (nikController.text.isEmpty || nokkController.text.isEmpty) {
      Get.snackbar("Error", "NIK dan No KK wajib diisi");
      return;
    }

    if (ktpImage.value == null || kkImage.value == null) {
      Get.snackbar("Error", "Foto KTP dan KK wajib diupload");
      return;
    }

    String? token = StorageService.getToken();
    if (token == null) {
      Get.snackbar("Error", "Token tidak ditemukan, silakan login ulang");
      return;
    }

    try {
      isLoading.value = true;

      dio.FormData formData = dio.FormData.fromMap({
        "nik": nikController.text,
        "nama_lengkap": namaController.text,
        "tanggal_lahir": tanggalLahirController.text,
        "tempat_lahir": tempatLahirController.text,
        "kewarganegaraan": kewarganegaraanController.text,
        "jenis_kelamin": jenisKelaminController.text,
        "golongan_darah": golonganDarahController.text,
        "status_perkawinan": statusPerkawinanController.text,
        "agama": agamaController.text,
        "alamat": alamatController.text,
        "pekerjaan": pekerjaanController.text,
        "berlaku_hingga": berlakuHinggaController.text,
        "no_kk": nokkController.text,

        "ktp_file": await dio.MultipartFile.fromFile(
          ktpImage.value!.path,
          filename: ktpImage.value!.path.split('/').last,
        ),

        "kk_file": await dio.MultipartFile.fromFile(
          kkImage.value!.path,
          filename: kkImage.value!.path.split('/').last,
        ),
      });
      final response = await DioService.instance.post(
        ApiConstant.biodataStore,
        data: formData,
        options: dio.Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );
      Get.back();
      Get.back();
      authController.initAuth();
      Get.snackbar(
        "Berhasil",
        response.data["message"] ?? "Data berhasil dikirim",
      );

    } on dio.DioException catch (e) {

      if (e.response != null) {
        final data = e.response!.data;
        if (e.response!.statusCode == 422 && data["errors"] != null) {
          final firstError = data["errors"].values.first[0];
          Get.snackbar("Validasi Error", firstError);
        } else {
          Get.snackbar(
            "Error",
            data["message"]?.toString() ?? "Terjadi kesalahan",
          );
        }

      } else {
        Get.snackbar("Error", "Tidak dapat terhubung ke server");
      }

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void fillFormFromOCR(Map<String, String> ktpData) {

    nikController.text = ktpData["nik"] ?? '';
    namaController.text = ktpData["nama_lengkap"] ?? '';
    tanggalLahirController.text = ktpData["tanggal_lahir"] ?? '';
    tempatLahirController.text = ktpData["tempat_lahir"] ?? '';
    jenisKelaminController.text = ktpData["jenis_kelamin"] ?? '';
    golonganDarahController.text = ktpData["golongan_darah"] ?? '';
    kewarganegaraanController.text = ktpData["kewarganegaraan"] ?? '';
    statusPerkawinanController.text = ktpData["status_perkawinan"] ?? '';
    agamaController.text = ktpData["agama"] ?? '';
    alamatController.text = ktpData["alamat"] ?? '';
    pekerjaanController.text = ktpData["pekerjaan"] ?? '';
    berlakuHinggaController.text = ktpData["berlaku_hingga"] ?? '';
  }

  @override
  void onClose() {
    nikController.dispose();
    namaController.dispose();
    tanggalLahirController.dispose();
    tempatLahirController.dispose();
    statusPerkawinanController.dispose();
    agamaController.dispose();
    alamatController.dispose();
    pekerjaanController.dispose();
    berlakuHinggaController.dispose();
    nokkController.dispose();
    super.onClose();
  }
}
