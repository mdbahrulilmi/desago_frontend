import 'package:desago/app/components/alert.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:get/get.dart';

class AkunBiodataController extends GetxController {
  // Data pengguna
  final RxString nik = "3322071234567890".obs;
  final RxString nama = "Joko Susilo".obs;
  final RxString tempatLahir = "Temanggung".obs;
  final RxString tanggalLahir = "15-05-1990".obs;
  final RxString jenisKelamin = "Laki-laki".obs;
  final RxString golonganDarah = "O".obs;
  final RxString alamat = "Jl. Raya Pringsurat No. 10, Dusun Krajan, RT 03/RW 02".obs;
  final RxString agama = "Islam".obs;
  final RxString statusPerkawinan = "Kawin".obs;
  final RxString pekerjaan = "Petani".obs;
  final RxString kewarganegaraan = "WNI".obs;
  final RxString berlakuHingga = "Seumur Hidup".obs;
  
  // Status verifikasi
  final RxBool isVerified = true.obs;
  
  // Status loading
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Di implementasi nyata, load data dari API
    fetchUserData();
  }
  
  // Fungsi untuk memuat data pengguna dari API
  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;
      // Simulasi API call
      await Future.delayed(Duration(seconds: 1));
      
      // Di implementasi nyata, data akan diambil dari respons API
      // Dan di-assign ke reactive variables di atas
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Fungsi untuk meminta verifikasi data
  Future<void> requestVerification() async {
    try {
      isLoading.value = true;
      
      // Simulasi API call
      await Future.delayed(Duration(seconds: 2));
      
      // Tampilkan dialog sukses
      await AppDialog.success(
        title: 'Berhasil',
        message: 'Permintaan verifikasi data telah dikirim. Admin desa akan memverifikasi data Anda dalam waktu 1x24 jam.',
        buttonText: 'OK',
      );
      
    } catch (e) {
      AppDialog.error(
        title: 'Gagal',
        message: 'Gagal mengirim permintaan verifikasi: ${e.toString()}',
        buttonText: 'Tutup',
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Fungsi untuk edit data
  void editData() {
    Get.toNamed('/edit-biodata');
  }
}
