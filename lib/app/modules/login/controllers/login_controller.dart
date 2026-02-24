import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/controllers/auth_controller.dart';
import 'package:desago/app/models/UserModel.dart';
import 'package:desago/app/modules/home/controllers/home_controller.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/services/storage_services.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final rememberMe = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

 Future<void> onLogin() async {
  try {
    isLoading.value = true;

    final response = await DioService.instance.post(
      ApiConstant.login,
      data: {
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      },
    );

    if (response.data == null) {
      Get.snackbar(
        'Error',
        'Gagal menerima data dari server',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final responseData = response.data as Map<String, dynamic>;

    if (response.statusCode == 200 && responseData['success'] == true) {
      final user = UserModel.fromJson(responseData['user']);
      final token = responseData['token']?.toString() ?? '';

      await StorageService.saveUserData(user, token);

      final auth = Get.find<AuthController>();
      await auth.loadUser();

      Get.snackbar(
        'Berhasil',
        responseData['message'] ?? 'Login berhasil',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAllNamed(Routes.MAIN);
      return;
    }

    Get.snackbar(
      'Error',
      responseData['message'] ?? 'Login gagal',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );

  } on dio.DioException catch (e) {
    String errorMessage = 'Terjadi kesalahan';

    if (e.response != null) {
      final statusCode = e.response!.statusCode;

      if (statusCode == 422) {
        final errors = e.response!.data['errors'];
        if (errors != null && errors is Map) {
          errorMessage = errors.values.first[0] ?? 'Validasi gagal';
        }
      } else if (statusCode == 401) {
        errorMessage = 'Username atau password salah';
      } else {
        errorMessage =
            e.response!.data['message'] ?? 'Gagal terhubung ke server';
      }
    }

    Get.snackbar(
      'Error',
      errorMessage,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );

  } catch (e) {
    Get.snackbar(
      'Error',
      e.toString(),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false;
  }
}

Future<void> handleGoogleSignIn() async {
  try {
    isLoading.value = true;

    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      signInOption: SignInOption.standard,
    );

    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }

    final GoogleSignInAccount? googleUser =
        await googleSignIn.signIn();

    if (googleUser == null) {
      Get.snackbar(
        'Info',
        'Login dibatalkan',
        backgroundColor: AppColors.warning,
        colorText: AppColors.white,
      );
      return;
    }

    final googleAuth = await googleUser.authentication;

    final userData = {
      'email': googleUser.email,
      'name': googleUser.displayName,
      'google_id': googleUser.id,
      'avatar': googleUser.photoUrl,
      'access_token': googleAuth.accessToken,
      'desa_id': ApiConstant.desaId,
    };

    final response = await DioService.instance.post(
      ApiConstant.googleLogin,
      data: userData,
      options: dio.Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => status! < 500,
      ),
    );

    if (response.data == null) {
      Get.snackbar(
        'Error',
        'Gagal menerima data dari server',
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
      );
      return;
    }

    final responseData = response.data as Map<String, dynamic>;

    if (response.statusCode == 200) {

      final token = responseData['token']?.toString() ?? '';
      final user = UserModel.fromJson(responseData['user']);

      await StorageService.saveUserData(user, token);

      final auth = Get.find<AuthController>();
      await auth.loadUser();

      Get.snackbar(
        'Berhasil',
        'Login dengan Google berhasil',
        backgroundColor: AppColors.success,
        colorText: AppColors.white,
      );

      Get.offAllNamed(Routes.MAIN);
      return;
    }

    Get.snackbar(
      'Error',
      responseData['message'] ?? 'Login Google gagal',
      backgroundColor: AppColors.danger,
      colorText: AppColors.white,
    );

  } catch (e, stack) {

    Get.snackbar(
      'Error',
      'Terjadi kesalahan saat login Google',
      backgroundColor: AppColors.danger,
      colorText: AppColors.white,
    );
  } finally {
    isLoading.value = false;
  }
}
  void onForgotPassword() {
    Get.toNamed(Routes.LUPA_PASSWORD);
  }

  void onCreateAccount() {
    Get.toNamed(Routes.REGISTER);
  }

  void toHome(){
    Get.toNamed(Routes.MAIN);
  }
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
