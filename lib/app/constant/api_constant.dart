class ApiConstant {
  // Base URL
  static const String baseUrl = 'https://backend.desago.id/api/';
  static const String pictureUrl = 'https://www.desatinggo.id/upload/picture/';

  // Desa
  static const String desa = 'desatinggo.id';
  static const String carouselDesa = "/desa/${desa}/carousel";
  static const String profilDesa = "/desa/${desa}/profil";
  static const String beritaDesa = "/desa/${desa}/berita";
  static const String beritaDesaCarousel = "/desa/${desa}/berita/carousel";
  static const String danaDesa = "/desa/${desa}/dana";
  static const String agendaDesa = "/desa/${desa}/agenda";
  static const String produkDesa = "/desa/${desa}/umkm";
  static const String produkDesaCarousel = "/desa/${desa}/umkm/carousel";
  static const String nomorDarurat = "/desa/${desa}/no-darurat";
  static const String lapor = "/desa/${desa}/lapor";
  static const String laporKategori = "/desa/${desa}/lapor/kategori";
  static const String laporCreate = "/desa/${desa}/lapor/create";

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
  static const String updateAvatar = '/user/avatar';
  static const String editProfile = '/edit/profile';
}
