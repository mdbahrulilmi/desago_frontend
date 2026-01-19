import 'package:carousel_slider/carousel_controller.dart';
import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/UserModel.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/services/storage_services.dart';
import 'package:desago/app/utils/app_colors.dart' show AppColors;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final Rxn<UserModel> user = Rxn<UserModel>();
  final CarouselSliderController carouselController = CarouselSliderController();
  final RxInt currentIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
    user.value = StorageService.getUser();
  }

  String get userName => user.value?.username ?? 'User';
  String get userEmail => user.value?.email ?? '-';
  String get userPhone => user.value?.phone ?? '-';

  Future<void> logout() async {
    try {
      final response = await DioService.instance.get(
        ApiConstant.logout,
      );
      if (response.statusCode == 200) {
        await StorageService.clearStorage();
        Get.snackbar(
          'Logout Berhasil',
          'Anda berhasil keluar dari akun.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.snackbar(
          'Error',
          'Gagal logout, coba lagi.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat logout: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void>refreshData()async{
    
  } 

  // Data produk
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Kripik Ikan Meggalodon Khas Jepara',
      'image': 'assets/img/produk_1.jpg',
      'price': 'Rp 25.000',
    },
    {
      'name': 'Kopi Robusta',
      'image': 'assets/img/produk_2.jpg',
      'price': 'Rp 50.000',
    },
    {
      'name': 'Tembakau Gayo',
      'image': 'assets/img/produk_3.jpg',
      'price': 'Rp 75.000',
    },
    {
      'name': 'Kayu Manis',
      'image': 'assets/img/produk_4.jpg',
      'price': 'Rp 40.000',
    },
  ];

    void changeSlide(int index) {
    currentIndex.value = index;
  }

  // Method untuk memesan produk
  void pesanProduk(Map<String, dynamic> produk) {
    // Implementasi logika pemesanan
    Get.snackbar(
      'Pemesanan',
      'Anda memesan ${produk['name']}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary,
      colorText: AppColors.white,
    );
  }


}
