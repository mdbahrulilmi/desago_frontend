import 'dart:io';

import 'package:desago/app/components/alert.dart';
import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/controllers/auth_controller.dart';
import 'package:desago/app/models/UserModel.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/services/storage_services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class AkunController extends GetxController {
  final user = Rxn<UserModel>();
  final avatar = Rx<File?>(null);

  final isNotificationActive = false.obs;
  final avatarFileName = ''.obs;

  final ImagePicker _picker = ImagePicker();
  final auth = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  /// LOAD USER DATA FROM STORAGE
  Future<void> fetchUserData() async {
    try {
      final userData = StorageService.getUser();

      if (userData != null) {
        user.value = userData;
        isNotificationActive.value = userData.isNotification ?? false;
      }
    } catch (e) {
      print("FETCH USER ERROR: $e");
    }
  }

  /// SWITCH NOTIFICATION
  Future<void> toggleNotification(bool value) async {
    final oldValue = isNotificationActive.value;

    /// update UI sementara
    isNotificationActive.value = value;

    try {
      await actionNotification();
    } catch (e) {
      /// rollback jika gagal
      isNotificationActive.value = oldValue;
      print("TOGGLE ERROR: $e");
    }
  }

  /// CALL API TOGGLE NOTIFICATION
  Future<void> actionNotification() async {
    final token = StorageService.getToken();

    try {
      final response = await DioService.instance.post(
        ApiConstant.actionNotification,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final value = response.data['is_notification'];
        final newStatus = value == 1 || value == true || value.toString() == '1';

        isNotificationActive.value = newStatus;

        user.value = user.value?.copyWith(
          isNotification: newStatus,
        );

        // ✅ update storage biar persist
        if (user.value != null) {
          await StorageService.saveUser(user.value!);
        }

        auth.refreshVerification();
      }
    } catch (e) {
      print("NOTIFICATION ERROR: $e");
      rethrow;
    }
  }

  /// LOGOUT USER
  Future<void> logout() async {
    final bool? confirmed = await AppDialog.ask(
      title: 'Konfirmasi Logout',
      message: 'Apakah Anda yakin ingin keluar dari akun?',
      confirmText: 'Ya, Keluar',
      cancelText: 'Batal',
    );

    if (confirmed != true) return;

    final token = StorageService.getToken();

    try {
      final response = await DioService.instance.post(
        ApiConstant.logout,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        await StorageService.clearStorage();

        await AppDialog.success(
          title: 'Logout Berhasil',
          message: 'Anda berhasil keluar dari akun.',
        );

        await Future.delayed(const Duration(milliseconds: 100));

        Get.offAllNamed(Routes.LOGIN);
      } else {
        AppDialog.error(
          title: 'Gagal Logout',
          message: 'Gagal logout, silakan coba lagi.',
          buttonText: 'Tutup',
        );
      }
    } catch (e) {
      AppDialog.error(
        title: 'Terjadi Kesalahan',
        message: 'Terjadi kesalahan saat logout',
        buttonText: 'Tutup',
      );
    }
  }
}