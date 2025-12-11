import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'https://londa-proinsurance-nonsalubriously.ngrok-free.dev/api/';
  static String get appName => dotenv.env['APP_NAME'] ?? 'DesaGo';
}