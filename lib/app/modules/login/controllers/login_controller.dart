import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/UserModel.dart';
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
        'email': emailController.text,
        'password': passwordController.text,
      },
    );

    if (response.data != null) {
      final responseData = response.data as Map<String, dynamic>;

      if (response.statusCode == 200 && responseData['success'] == true) {
        final user = UserModel.fromJson(responseData['user']);
        final token = responseData['token']?.toString() ?? '';
        
        await StorageService.saveUserData(user, token);

        Get.snackbar(
          'Berhasil',
          responseData['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed(Routes.MAIN);
      } else {
        Get.snackbar(
          'Error',
          responseData['message'] ?? 'Unknown error occurred',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Error',
        'Gagal menerima data dari server',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } on dio.DioException catch (e) {
    String errorMessage = 'Terjadi kesalahan';

    if (e.response != null) {
      if (e.response!.statusCode == 422) {
        final errors = e.response!.data['errors'];
        errorMessage = errors.values.first[0] ?? 'Validasi gagal';
      } else if (e.response!.statusCode == 401) {
        errorMessage = 'Username atau password salah';
      } else {
        errorMessage = e.response!.data['message'] ?? 'Gagal terhubung ke server';
      }
    }

    Get.snackbar(
      'Error',
      errorMessage,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } catch (e, stackTrace) {
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

    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      signInOption: SignInOption.standard,
    );

    final isSignedIn = await _googleSignIn.isSignedIn();
    
    if (isSignedIn) {
      await _googleSignIn.signOut();
    }

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    
    if (googleUser == null) {
      Get.snackbar(
        'Info',
        'Login dibatalkan',
        backgroundColor: AppColors.warning,
        colorText: AppColors.white,
      );
      return;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final Map<String, dynamic> userData = {
      'email': googleUser.email,
      'name': googleUser.displayName,
      'google_id': googleUser.id,
      'avatar': googleUser.photoUrl,
      'access_token': googleAuth.accessToken,
      'desa_id': ApiConstant.desaId
    };

    final response = await DioService.instance.post(
      ApiConstant.googleLogin,
      data: userData,
      options: dio.Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    if (response.statusCode == 200) {
      final token = response.data['token'];
      final user = UserModel.fromJson(response.data['user']);
      await StorageService.saveToken(token);
      await StorageService.saveUser(user);

      Get.offAllNamed(Routes.MAIN);
      Get.snackbar(
        'Berhasil',
        'Login dengan Google berhasil',
        backgroundColor: AppColors.success,
        colorText: AppColors.white,
      );
    }
  } catch (e) {
    String errorMessage = 'Gagal login dengan Google';
    if (e is PlatformException) {
      errorMessage += '\nDetail: ${e.message}';
    }

    Get.snackbar(
      'Error',
      errorMessage,
      backgroundColor: AppColors.danger,
      colorText: AppColors.white,
      duration: const Duration(seconds: 5),
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
