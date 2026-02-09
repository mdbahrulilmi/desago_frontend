import 'dart:io';
import 'package:desago/app/components/alert.dart';
import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/helpers/permission_helper.dart';
import 'package:desago/app/models/AkunDesaMode.dart';
import 'package:desago/app/models/KabupatenMode.dart';
import 'package:desago/app/models/KecamatanModel.dart';
import 'package:desago/app/models/ProfileDesa.dart';
import 'package:desago/app/models/ProvinsiModel.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

class TautkanAkunFormController extends GetxController {
  final dio.Dio _dio = DioService.instance;

  final nikController = TextEditingController();
  final kkController = TextEditingController();
  final TextEditingController namaDesaDipilih = TextEditingController();
  final TextEditingController searchController = TextEditingController(); 
  final ktpImage = Rx<File?>(null);
  final kkImage = Rx<File?>(null);
  final ktpFileName = ''.obs;
  final kkFileName = ''.obs;

  final desaList = <AkunDesaModel>[].obs;
  final selectedDesa = Rx<AkunDesaModel?>(null);
  final isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // fetchDesa();
    fetchDummyDesa();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    nikController.dispose();
    kkController.dispose();
    namaDesaDipilih.dispose();
    super.onClose();
  }

  // Fungsi dummy untuk simulasi pengiriman data form
  Future<void> submitDummyData() async {
    // Validasi form sama seperti submitForm
    if (nikController.text.isEmpty) {
      _showError('NIK tidak boleh kosong');
      return;
    }

    if (kkController.text.isEmpty) {
      _showError('No KK tidak boleh kosong');
      return;
    }

    if (ktpImage.value == null) {
      _showError('Foto KTP belum diunggah');
      return;
    }

    if (kkImage.value == null) {
      _showError('Foto KK belum diunggah');
      return;
    }

    if (selectedDesa.value == null) {
      _showError('Pilih desa terlebih dahulu');
      return;
    }

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      await AppDialog.success(
        title: 'Berhasil',
        message: 'Akun berhasil ditautkan ke desa ${selectedDesa.value!.namaDesa}',
        buttonText: 'OK',
        onConfirm: () {
          Get.back();
        },
      );
      
    } catch (e) {
      print(e);
      AppDialog.error(
        title: 'Gagal',
        message: 'Terjadi kesalahan saat menautkan akun: ${e.toString()}',
        buttonText: 'Tutup',
      );
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchDummyDesa() async {
    try {
      isLoading.value = true;
      
      // Delay sebentar untuk mensimulasikan panggilan API
      await Future.delayed(Duration(milliseconds: 800));
      
      // Menggunakan list langsung untuk data dummy
      desaList.value = [
        AkunDesaModel(
          id: 1,
          username: 'desa_pringsurat',
          status: 'active',
          createdAt: DateTime.parse('2023-09-15T08:30:00Z'),
          updatedAt: DateTime.parse('2023-12-20T14:45:00Z'),
          profilDesa: ProfilDesaModel(
            id: 1,
            namaDesa: 'Pringsurat',
            kodeDesa: '33.22.07.2001',
            alamat: 'Jl. Raya Pringsurat No. 10',
            provinsi: ProvinsiModel(id: 33, name: 'Jawa Tengah'),
            kabupaten: KabupatenModel(id: 22, name: 'Temanggung'),
            kecamatan: KecamatanModel(id: 7, name: 'Pringsurat'),
          ),
        )
      ];
      
    } catch (e) {
      print(e);
      _showError('Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }


  // Fungsi untuk memuat data desa dari API
  Future<void> fetchDesa() async {
    try {
      isLoading.value = true;
      final response = await _dio.get(ApiConstant.getAllDesa);

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final Map<String, dynamic> data = response.data;

        if (data.containsKey('data') && data['data'] is List) {
          final List<dynamic> desaData = data['data'];
          desaList.value =
              desaData.map((json) => AkunDesaModel.fromJson(json)).toList();
        } else {
          _showError('Format data tidak valid');
        }
      } else {
        _showError('Gagal memuat data desa');
      }
    } catch (e) {
      print(e);
      _showError('Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk memilih foto KTP
  Future<void> pickKtpImage() async {
    bool hasPermission =
        await PermissionHelper.checkAndRequestGalleryPermissions();
    if (!hasPermission) return;

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        final File file = File(pickedFile.path);
        final int fileSize = await file.length();

        if (fileSize > 2 * 1024 * 1024) {
          _showError('Ukuran file KTP melebihi batas 2MB');
          return;
        }

        final String fileName = pickedFile.name.toLowerCase();
        if (!fileName.endsWith('.jpg') &&
            !fileName.endsWith('.jpeg') &&
            !fileName.endsWith('.png')) {
          _showError('Format file KTP tidak didukung. Gunakan JPG atau PNG');
          return;
        }

        ktpImage.value = file;
        ktpFileName.value = pickedFile.name;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil foto KTP: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Fungsi untuk memilih foto KTP dari kamera
  Future<void> captureKtpImage() async {
    bool hasPermission =
        await PermissionHelper.checkAndRequestCameraPermissions();
    if (!hasPermission) return;

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        final File file = File(pickedFile.path);
        final int fileSize = await file.length();

        if (fileSize > 2 * 1024 * 1024) {
          _showError('Ukuran file KTP melebihi batas 2MB');
          return;
        }

        ktpImage.value = file;
        ktpFileName.value = "ktp_photo.jpg";
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil foto KTP: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Fungsi untuk memilih foto KK
  Future<void> pickKkImage() async {
    bool hasPermission =
        await PermissionHelper.checkAndRequestGalleryPermissions();
    if (!hasPermission) return;

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        final File file = File(pickedFile.path);
        final int fileSize = await file.length();

        if (fileSize > 2 * 1024 * 1024) {
          _showError('Ukuran file KK melebihi batas 2MB');
          return;
        }

        final String fileName = pickedFile.name.toLowerCase();
        if (!fileName.endsWith('.jpg') &&
            !fileName.endsWith('.jpeg') &&
            !fileName.endsWith('.png')) {
          _showError('Format file KK tidak didukung. Gunakan JPG atau PNG');
          return;
        }

        kkImage.value = file;
        kkFileName.value = pickedFile.name;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil foto KK: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> captureKkImage() async {
    bool hasPermission =
        await PermissionHelper.checkAndRequestCameraPermissions();
    if (!hasPermission) return;

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        final File file = File(pickedFile.path);
        final int fileSize = await file.length();

        if (fileSize > 2 * 1024 * 1024) {
          _showError('Ukuran file KK melebihi batas 2MB');
          return;
        }

        kkImage.value = file;
        kkFileName.value = "kk_photo.jpg";
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil foto KK: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Fungsi untuk memilih source image (kamera atau galeri)
  void showImageSourceDialog(bool isKtp) {
    Get.dialog(
      AlertDialog(
        title: Text('Pilih Sumber Gambar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Galeri'),
              onTap: () {
                Get.back();
                if (isKtp) {
                  pickKtpImage();
                } else {
                  pickKkImage();
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Kamera'),
              onTap: () {
                Get.back();
                if (isKtp) {
                  captureKtpImage();
                } else {
                  captureKkImage();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menghapus foto KTP yang dipilih
  void clearKtpImage() {
    ktpImage.value = null;
    ktpFileName.value = '';
  }

  // Fungsi untuk menghapus foto KK yang dipilih
  void clearKkImage() {
    kkImage.value = null;
    kkFileName.value = '';
  }

  Future<void> submitForm() async {
    // Validasi form
    if (nikController.text.isEmpty) {
      _showError('NIK tidak boleh kosong');
      return;
    }

    if (kkController.text.isEmpty) {
      _showError('No KK tidak boleh kosong');
      return;
    }

    if (ktpImage.value == null) {
      _showError('Foto KTP belum diunggah');
      return;
    }

    if (kkImage.value == null) {
      _showError('Foto KK belum diunggah');
      return;
    }

    if (selectedDesa.value == null) {
      _showError('Pilih desa terlebih dahulu');
      return;
    }

    try {
      // Buat FormData untuk mengirim file dan data
      final formData = dio.FormData.fromMap({
        'desa_id': selectedDesa.value!.id,
        'nik': nikController.text,
        'nomor_kk': kkController.text,
        'foto_wajah': await dio.MultipartFile.fromFile(
          ktpImage.value!.path,
          filename: ktpFileName.value,
        ),
        'foto_ktp': await dio.MultipartFile.fromFile(
          ktpImage.value!.path,
          filename: ktpFileName.value,
        ),
        'foto_kk': await dio.MultipartFile.fromFile(
          kkImage.value!.path,
          filename: kkFileName.value,
        ),
      });

      // Kirim data ke API
      final response = await _dio.post(
        ApiConstant.tautkanAkunKeDesa,
        data: formData,
      );

      if (response.statusCode == 201) {
        Get.snackbar(
          'Sukses',
          'Akun berhasil ditautkan ke desa',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.back();
      } else {
        _showError('Gagal menautkan akun: ${response.data['message']}');
      }
    } catch (e) {
      print(e);
      _showError('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Helper function untuk menampilkan error
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
