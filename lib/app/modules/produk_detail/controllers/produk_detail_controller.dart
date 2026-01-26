import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProdukDetailController extends GetxController {
  final RxMap<String, dynamic> product = <String, dynamic>{}.obs;
  final RxInt quantity = 1.obs;
  final RxBool isFavorite = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      product.value = Get.arguments as Map<String, dynamic>;
    }
  }
  
  void incrementQuantity() {
    quantity.value++;
  }
  
  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }
  
  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
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

}
