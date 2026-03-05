import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> saveFcmTokenToBackend(String apiToken) async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  String? token = await messaging.getToken();
  print("FCM Token: $token");

  if (token == null) return;

  try {
    final dio = Dio();
    final response = await DioService.instance.post(
      ApiConstant.FcmTokenSave,
      data: {'token': token},
      options: Options(
        headers: {
          'Authorization': 'Bearer $apiToken',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      print('Token berhasil dikirim ke backend');
    } else {
      print('Gagal kirim token: ${response.statusCode}');
    }
  } catch (e) {
    print('Error kirim token: $e');
  }
}