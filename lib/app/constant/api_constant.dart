class ApiConstant {
  // Base URL
  static const String baseUrl = 'http://192.168.1.7:8000/api';

  // Auth Endpoints
  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/logout';
  static const String profile = '/user';
  static const String sendLinkPassword = '/forgot-password';
  static const String googleLogin = '/loginGoogle';
  static const String sendLinkWa = '/sendSMS';

  static const String getAllDesa = '/desa';
  static const String tautkanAkunKeDesa = '/tautkan-akun';

  // Akun Endpoints
  static const String updateAvatar = '$baseUrl/user/avatar';
}
