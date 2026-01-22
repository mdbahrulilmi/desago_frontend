import 'package:carousel_slider/carousel_controller.dart';
import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/UserModel.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/services/storage_services.dart';
import 'package:desago/app/utils/app_colors.dart' show AppColors;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  final Rxn<UserModel> user = Rxn<UserModel>();
  
  final CarouselSliderController carouselController = CarouselSliderController();
  final RxList<Map<String, dynamic>> beritas = <Map<String, dynamic>>[].obs;
  final RxInt currentIndex = 0.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBerita();
    user.value = StorageService.getUser();
  }

  String get userName => user.value?.username ?? 'User';
  String get userEmail => user.value?.email ?? '-';
  String get userPhone => user.value?.phone ?? '-';

  Future<void> fetchBerita() async {
    try {
      isLoading.value = true;
      final res = await DioService.instance.get(ApiConstant.beritaDesaCarousel);

      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(res.data).map((berita) {
          return {
            "image": berita['gambar'] ?? '',
            "title": berita['judul'] ?? '-',
            "excerpt": (berita['isi'] ?? '').replaceAll(RegExp(r'<[^>]*>'), '').substring(0, 100),
            "category": berita['kategori'] ?? 'Umum',
            "date": berita['tgl']?.split(' ')?.first ?? '-',
            "raw": berita,
          };
      }).toList();

      beritas.assignAll(data);

    } catch (e) {
      print("Error fetchBerita: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void bacaBeritaLengkap(Map<String, dynamic> berita) {
    Get.toNamed(Routes.BERITA_DETAIL, arguments: berita['raw']);
  }


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
      'phone' : "+6282226627175"
    },
    {
      'name': 'Kopi Robusta',
      'image': 'assets/img/produk_2.jpg',
      'price': 'Rp 50.000',
      'phone' : "+6282226627175"
    },
    {
      'name': 'Tembakau Gayo',
      'image': 'assets/img/produk_3.jpg',
      'price': 'Rp 75.000',
      'phone' : "+6282226627175"
    },
    {
      'name': 'Kayu Manis',
      'image': 'assets/img/produk_4.jpg',
      'price': 'Rp 40.000',
      'phone' : "+6282226627175"
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

  Future<void> openWhatsApp({
    required String phone,
    String message = '',
  }) async {
    final url = Uri.parse(
      "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Tidak bisa membuka WhatsApp';
    }
  }

}
