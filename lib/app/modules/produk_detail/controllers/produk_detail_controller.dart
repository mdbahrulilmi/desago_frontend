import 'package:get/get.dart';

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
  
  void share() {
    // Implement share functionality
    Get.snackbar(
      'Share',
      'Sharing ${product['name']}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void buyNow() {
    // Implement buy now functionality
    Get.snackbar(
      'Buy Now',
      'Buying ${quantity.value} ${product['name']}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
