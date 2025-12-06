// lib/app/services/dio_service.dart
import 'package:desago/app/constant/api_constant.dart';
import 'package:dio/dio.dart' hide FormData, MultipartFile, Response; // Sembunyikan kelas dari dio
import 'package:dio/dio.dart' as dio show FormData, MultipartFile, Response; // Impor dengan prefix
import 'package:get/get.dart';
import 'storage_services.dart';

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
    return Dio(
      BaseOptions(
        baseUrl: ApiConstant.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 10),
        validateStatus: (status) {
          return status! < 500;
        },
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  }

  static void _setupInterceptors() {
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.data is! dio.FormData) {
            options.contentType = 'application/json';
          }
          
          final token = StorageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
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

    // Log untuk development
    _dio!.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
}