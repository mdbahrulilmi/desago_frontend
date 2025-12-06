import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8000/api';
  static String get appName => dotenv.env['APP_NAME'] ?? 'DesaGo';
}