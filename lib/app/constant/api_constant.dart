class ApiConstant {
  // Base URL
  static const String baseUrl = 'https://backend.desagodigital.id/api/';
  static const String pictureUrl = 'https://www.desatinggo.id/upload/picture/';

  static const String desaId = 'DESA_1';

  // Desa
  static const String carouselDesa = '/desa/${desaId}/carousel';
  static const String profilDesa = '/desa/${desaId}/profil';
  static const String beritaDesa = '/desa/${desaId}/berita';
  static const String beritaDesaCarousel = '/desa/${desaId}/berita/carousel';
  static const String anggaran = '/desa/${desaId}/anggaran';
  static const String anggaranKategori = '/desa/${desaId}/anggaran/kategori';
  static const String agendaDesa = '/desa/${desaId}/agenda';
  static const String produkDesa = '/desa/${desaId}/umkm';
  static const String produkDesaCarousel = '/desa/${desaId}/umkm/carousel';
  static const String nomorDarurat = '/desa/${desaId}/no-darurat';
  static const String lapor = '/desa/${desaId}/lapor';
  static const String laporKategori = '/lapor/kategori';
  static const String laporCreate = '/desa/${desaId}/lapor/create';
  static const String jenisSurat = '/surat';
  static const String tambahSurat = '/desa/${desaId}/surat/create';
  static const String suratRiwayat = '/desa/${desaId}/surat';
  static const String aktivitas = '/desa/${desaId}/aktivitas';

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
  static const String tokenExpired = '/token-expired';
  static const String verification = '/verification';
  static const String isOauth = '/isoauth';
  static const String biodataStore = '/biodata/store';

  static const String getAllDesa = '/desa';
  static const String tautkanAkunKeDesa = '/tautkan-akun';

  // Akun Endpoints
  static const String updateAvatar = '/profile/avatar';
  static const String editProfile = '/profile/edit';
}
