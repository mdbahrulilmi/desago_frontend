class ApiConstant {
  // Base URL
  static const String baseUrl = 'https://londa-proinsurance-nonsalubriously.ngrok-free.dev/api';

  // Auth Endpoints
  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/logout';
  static const String profile = '/user';
  static const String sendLinkPassword = '/forgot-password';
  static const String newPassword = '/new-password';
  static const String changePassword = '/change-password';
  static const String googleLogin = '/loginGoogle';
  static const String sendLinkWa = '/sendSMS';
  static const String tokenExpired= '/token-expired';

  static const String getAllDesa = '/desa';
  static const String tautkanAkunKeDesa = '/tautkan-akun';

  // Akun Endpoints
  static const String updateAvatar = '$baseUrl/user/avatar';
}
