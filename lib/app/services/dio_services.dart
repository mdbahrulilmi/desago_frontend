// lib/app/services/dio_service.dart
import 'package:desago/app/constant/api_constant.dart';
import 'package:dio/dio.dart' hide FormData, MultipartFile, Response;
import 'package:dio/dio.dart' as dio show FormData, MultipartFile, Response;
import 'package:get/get.dart';
import 'storage_services.dart';

import 'dart:io';
import 'package:dio/io.dart';

class DioService {
  static Dio? _dio;

  static Dio get instance {
    if (_dio == null) {
      _dio = createDio();
      _setupInterceptors();
    }
    return _dio!;
  }

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstant.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 10),
        validateStatus: (status) => status != null && status < 500,
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    // FIX SSL NGROK
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    return dio;
  }

  static void _setupInterceptors() {
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final noAuthPaths = [
            '/login',
            '/register',
            '/forgot-password',
            '/new-password',
          ];

          final String path = options.path.toLowerCase();

          bool needAuth = !noAuthPaths.any((p) => path.contains(p));

          // tambahkan token hanya jika BUKAN login/regis
          if (needAuth) {
            final token = StorageService.getToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          if (options.data is! dio.FormData) {
            options.contentType = 'application/json';
          }

          return handler.next(options);
        },

        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            StorageService.clearStorage();
            Get.offAllNamed('/login');
          }
          return handler.next(error);
        },
      ),
    );

    // _dio!.interceptors.add(
    //   LogInterceptor(
    //     requestBody: true,
    //     responseBody: true,
    //   ),
    // );
  }
}
