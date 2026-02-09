  import 'package:carousel_slider/carousel_controller.dart';
  import 'package:desago/app/constant/api_constant.dart';
  import 'package:desago/app/models/BeritaModel.dart';
  import 'package:desago/app/models/CarouselModel.dart';
import 'package:desago/app/models/ProdukModel.dart';
  import 'package:desago/app/models/UserModel.dart';
  import 'package:desago/app/routes/app_pages.dart';
  import 'package:desago/app/services/dio_services.dart';
  import 'package:desago/app/services/storage_services.dart';
  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:url_launcher/url_launcher.dart';
  import 'package:intl/intl.dart';
  import 'package:get_storage/get_storage.dart';

  class HomeController extends GetxController {
    final Rxn<UserModel> user = Rxn<UserModel>();
    
    final CarouselSliderController carouselController = CarouselSliderController();
    final RxList<BeritaModel> beritas = <BeritaModel>[].obs;
    final RxList<ProdukModel> products = <ProdukModel>[].obs;
    final RxList<Carousel> carousel = <Carousel>[].obs;
    final RxInt currentIndex = 0.obs;
    var isLoadingCarousel = true.obs;
    var isLoadingBerita = true.obs;
    var isLoadingProduk = true.obs;

    final box = GetStorage();

    @override
    void onInit() {
    user.value = StorageService.getUser();

    _loadCarouselCache();
    fetchCarousel();
    fetchBerita();
    fetchProduct();
  }

    void _loadCarouselCache() {
      final cached = box.read('carousel');
      if (cached != null) {
        carousel.assignAll(
          (cached as List).map((e) => Carousel.fromJson(e)).toList(),
        );
        print('🟢 Carousel loaded from cache (${carousel.length})');
      }
    }
  
    Future<void> fetchCarousel() async {
    try {
      isLoadingCarousel.value = true;

      final res = await DioService.instance.get(ApiConstant.carouselDesa);

      if (res.data == null) {
        carousel.clear();
        return;
      }

      final List listData = res.data is List ? res.data : res.data['data'] ?? [];

      if (listData.isEmpty) {
        carousel.clear();
        print('⚠️ listData KOSONG');
        return;
      }

      carousel.value = listData.map((e) => Carousel.fromJson(e)).toList();

      box.write('carousel', listData);

    } catch (e, stack) {
      print('ERROR fetchCarousel: $e');
      print(stack);
    } finally {
      isLoadingCarousel.value = false;
    }
  }


    Future<void> fetchBerita() async {
      try {
        isLoadingBerita.value = true;

        final res =
            await DioService.instance.get(ApiConstant.beritaDesaCarousel);

        final List listData =
            res.data is List ? res.data : res.data['data'] ?? [];

        beritas.value = listData
            .map((e) => BeritaModel.fromJson(e))
            .toList();

        print('Berita loaded: ${beritas.length}');
      } catch (e, stack) {
        print('ERROR fetchBerita: $e');
        print(stack);
      } finally {
        isLoadingBerita.value = false;
      }
    }

    void bacaBeritaLengkap(BeritaModel berita) {
      Get.toNamed(Routes.BERITA_DETAIL, arguments: berita);
    }

    String formatTanggal(DateTime date) {
      return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(date);
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
      fetchCarousel();
      fetchBerita();
      fetchProduct();
    } 

    // Data produk
      void changeSlide(int index) {
      currentIndex.value = index;
    }

    Future<void> openWhatsApp({
    required String phone,
    required String product,
    String? message,
  }) async {
    final text = message ??
        '''Halo kak 😊
  Aku lihat $product, mau nanya detailnya dong.
  ''';

    final url = Uri.parse(
      'https://wa.me/$phone?text=${Uri.encodeComponent(text)}',
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

    Future<void> fetchProduct() async {
      try {
        isLoadingProduk.value = true;

        final res = await DioService.instance.get(ApiConstant.produkDesaCarousel);

        final List listData =
            res.data is List
                ? res.data
                : res.data['data'] ?? [];

        products.value =
            listData.map((e) => ProdukModel.fromJson(e)).toList();

        print('Produk loaded: ${products.length}');
      } catch (e) {
        products.clear();
        return;
      } finally {
        isLoadingProduk.value = false;
      }
    }

  }
