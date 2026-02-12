import 'package:desago/app/modules/password_baru/controllers/password_baru_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../modules/agenda/bindings/agenda_binding.dart';
import '../modules/agenda/views/agenda_view.dart';
import '../modules/agenda_detail/bindings/agenda_detail_binding.dart';
import '../modules/agenda_detail/views/agenda_detail_view.dart';
import '../modules/aktivitas/bindings/aktivitas_binding.dart';
import '../modules/aktivitas/views/aktivitas_view.dart';
import '../modules/akun/bindings/akun_binding.dart';
import '../modules/akun/views/akun_view.dart';
import '../modules/akun_biodata/bindings/akun_biodata_binding.dart';
import '../modules/akun_biodata/views/akun_biodata_view.dart';
import '../modules/akun_edit/bindings/akun_edit_binding.dart';
import '../modules/akun_edit/views/akun_edit_view.dart';
import '../modules/akun_pengaturan/bindings/akun_pengaturan_binding.dart';
import '../modules/akun_pengaturan/views/akun_pengaturan_view.dart';
import '../modules/akun_ubah_password/bindings/akun_ubah_password_binding.dart';
import '../modules/akun_ubah_password/views/akun_ubah_password_view.dart';
import '../modules/berita_detail/bindings/berita_detail_binding.dart';
import '../modules/berita_detail/views/berita_detail_view.dart';
import '../modules/berita_list/bindings/berita_list_binding.dart';
import '../modules/berita_list/views/berita_list_view.dart';
import '../modules/cek_bansos/bindings/cek_bansos_binding.dart';
import '../modules/cek_bansos/views/cek_bansos_view.dart';
import '../modules/cek_bansos_hasil/bindings/cek_bansos_hasil_binding.dart';
import '../modules/cek_bansos_hasil/views/cek_bansos_hasil_view.dart';
import '../modules/dana_desa/bindings/dana_desa_binding.dart';
import '../modules/dana_desa/views/dana_desa_view.dart';
import '../modules/donasi/bindings/donasi_binding.dart';
import '../modules/donasi/views/donasi_view.dart';
import '../modules/donasi_detail/bindings/donasi_detail_binding.dart';
import '../modules/donasi_detail/views/donasi_detail_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/lapor/bindings/lapor_binding.dart';
import '../modules/lapor/views/lapor_view.dart';
import '../modules/lapor_detail/bindings/lapor_detail_binding.dart';
import '../modules/lapor_detail/views/lapor_detail_view.dart';
import '../modules/lapor_form/bindings/lapor_form_binding.dart';
import '../modules/lapor_form/views/lapor_form_view.dart';
import '../modules/lapor_riwayat/bindings/lapor_riwayat_binding.dart';
import '../modules/lapor_riwayat/views/lapor_riwayat_view.dart';
import '../modules/layanan/bindings/layanan_binding.dart';
import '../modules/layanan/views/layanan_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/loker_desa/bindings/loker_desa_binding.dart';
import '../modules/loker_desa/views/loker_desa_view.dart';
import '../modules/loker_desa_detail/bindings/loker_desa_detail_binding.dart';
import '../modules/loker_desa_detail/views/loker_desa_detail_view.dart';
import '../modules/lupa_password/bindings/lupa_password_binding.dart';
import '../modules/lupa_password/views/lupa_password_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/nomor_penting/bindings/nomor_penting_binding.dart';
import '../modules/nomor_penting/views/nomor_penting_view.dart';
import '../modules/otp_verifikasi/bindings/otp_verifikasi_binding.dart';
import '../modules/otp_verifikasi/views/otp_verifikasi_view.dart';
import '../modules/password_baru/bindings/password_baru_binding.dart';
import '../modules/password_baru/views/password_baru_view.dart';
import '../modules/produk_detail/bindings/produk_detail_binding.dart';
import '../modules/produk_detail/views/produk_detail_view.dart';
import '../modules/produk_list_semua/bindings/produk_list_semua_binding.dart';
import '../modules/produk_list_semua/views/produk_list_semua_view.dart';
import '../modules/profil_desa/bindings/profil_desa_binding.dart';
import '../modules/profil_desa/views/profil_desa_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/surat_form/bindings/surat_form_binding.dart';
import '../modules/surat_form/views/surat_form_view.dart';
import '../modules/surat_list/bindings/surat_list_binding.dart';
import '../modules/surat_list/views/surat_list_view.dart';
import '../modules/surat_riwayat_pengajuan/bindings/surat_riwayat_pengajuan_binding.dart';
import '../modules/surat_riwayat_pengajuan/views/surat_riwayat_pengajuan_view.dart';
import '../modules/surat_riwayat_pengajuan_detail/bindings/surat_riwayat_pengajuan_detail_binding.dart';
import '../modules/surat_riwayat_pengajuan_detail/views/surat_riwayat_pengajuan_detail_view.dart';
import '../modules/tautkan_akun/bindings/tautkan_akun_binding.dart';
import '../modules/tautkan_akun/views/tautkan_akun_view.dart';
import '../modules/tautkan_akun_form/bindings/tautkan_akun_form_binding.dart';
import '../modules/tautkan_akun_form/views/tautkan_akun_form_view.dart';
import '../modules/ui/sukses_reset_password/bindings/sukses_reset_password_binding.dart';
import '../modules/ui/sukses_reset_password/views/sukses_reset_password_view.dart';
import '../modules/ui/sukses_verifikasi_email/bindings/sukses_verifikasi_email_binding.dart';
import '../modules/ui/sukses_verifikasi_email/views/sukses_verifikasi_email_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;
  static String getInitialRoute() {
    try {
      final box = GetStorage();
      final token = box.read<String>('token');
      if (token != null) {
        return Routes.MAIN;
      }
    } catch (e) {
      print('Error saat memeriksa token: $e');
    }
    return INITIAL;
  }

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.LUPA_PASSWORD,
      page: () => const LupaPasswordView(),
      binding: LupaPasswordBinding(),
    ),
     GetPage(
      name: '/password-baru',
      page: () => PasswordBaruView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<PasswordBaruController>()) {
          Get.lazyPut(() => PasswordBaruController());
        }
      }),
    ),
    GetPage(
      name: _Paths.SUKSES_RESET_PASSWORD,
      page: () => const SuksesResetPasswordView(),
      binding: SuksesResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VERIFIKASI,
      page: () => const OtpVerifikasiView(),
      binding: OtpVerifikasiBinding(),
    ),
    GetPage(
      name: _Paths.SUKSES_VERIFIKASI_EMAIL,
      page: () => const SuksesVerifikasiEmailView(),
      binding: SuksesVerifikasiEmailBinding(),
    ),
    GetPage(
      name: _Paths.AKUN,
      page: () => const AkunView(),
      binding: AkunBinding(),
    ),
    GetPage(
      name: _Paths.LAYANAN,
      page: () => const LayananView(),
      binding: LayananBinding(),
    ),
    GetPage(
      name: _Paths.AKUN_PENGATURAN,
      page: () => const AkunPengaturanView(),
      binding: AkunPengaturanBinding(),
    ),
    GetPage(
      name: _Paths.NOMOR_PENTING,
      page: () => const NomorPentingView(),
      binding: NomorPentingBinding(),
    ),
    GetPage(
      name: _Paths.TAUTKAN_AKUN,
      page: () => const TautkanAkunView(),
      binding: TautkanAkunBinding(),
    ),
    GetPage(
      name: _Paths.TAUTKAN_AKUN_FORM,
      page: () => TautkanAkunFormView(),
      binding: TautkanAkunFormBinding(),
    ),
    GetPage(
      name: _Paths.PROFIL_DESA,
      page: () => const ProfilDesaView(),
      binding: ProfilDesaBinding(),
    ),
    GetPage(
      name: _Paths.LAPOR,
      page: () => const LaporView(),
      binding: LaporBinding(),
    ),
    GetPage(
      name: _Paths.LAPOR_FORM,
      page: () => const LaporFormView(),
      binding: LaporFormBinding(),
    ),
    GetPage(
      name: _Paths.PRODUK_LIST_SEMUA,
      page: () => const ProdukListSemuaView(),
      binding: ProdukListSemuaBinding(),
    ),
    GetPage(
      name: _Paths.PRODUK_DETAIL,
      page: () => const ProdukDetailView(),
      binding: ProdukDetailBinding(),
    ),
    GetPage(
      name: _Paths.AGENDA,
      page: () => const AgendaView(),
      binding: AgendaBinding(),
    ),
    GetPage(
      name: _Paths.AGENDA_DETAIL,
      page: () => const AgendaDetailView(),
      binding: AgendaDetailBinding(),
    ),
    GetPage(
      name: _Paths.BERITA_LIST,
      page: () => const BeritaListView(),
      binding: BeritaListBinding(),
    ),
    GetPage(
      name: _Paths.BERITA_DETAIL,
      page: () => const BeritaDetailView(),
      binding: BeritaDetailBinding(),
    ),
    GetPage(
      name: _Paths.SURAT_FORM,
      page: () => const SuratFormView(),
      binding: SuratFormBinding(),
    ),
    GetPage(
      name: _Paths.LOKER_DESA,
      page: () => const LokerDesaView(),
      binding: LokerDesaBinding(),
    ),
    GetPage(
      name: _Paths.LOKER_DESA_DETAIL,
      page: () => const LokerDesaDetailView(),
      binding: LokerDesaDetailBinding(),
    ),
    GetPage(
      name: _Paths.DANA_DESA,
      page: () => const DanaDesaView(),
      binding: DanaDesaBinding(),
    ),
    GetPage(
      name: _Paths.CEK_BANSOS,
      page: () => const CekBansosView(),
      binding: CekBansosBinding(),
    ),
    GetPage(
      name: _Paths.CEK_BANSOS_HASIL,
      page: () => const CekBansosHasilView(),
      binding: CekBansosHasilBinding(),
    ),
    GetPage(
      name: _Paths.DONASI,
      page: () => const DonasiView(),
      binding: DonasiBinding(),
    ),
    GetPage(
      name: _Paths.DONASI_DETAIL,
      page: () => const DonasiDetailView(),
      binding: DonasiDetailBinding(),
    ),
    GetPage(
      name: _Paths.SURAT_RIWAYAT_PENGAJUAN,
      page: () => const SuratRiwayatPengajuanView(),
      binding: SuratRiwayatPengajuanBinding(),
    ),
    GetPage(
      name: _Paths.SURAT_RIWAYAT_PENGAJUAN_DETAIL,
      page: () => const SuratRiwayatPengajuanDetailView(),
      binding: SuratRiwayatPengajuanDetailBinding(),
    ),
    GetPage(
      name: _Paths.LAPOR_RIWAYAT,
      page: () => const LaporRiwayatView(),
      binding: LaporRiwayatBinding(),
    ),
    GetPage(
      name: _Paths.AKUN_UBAH_PASSWORD,
      page: () => const AkunUbahPasswordView(),
      binding: AkunUbahPasswordBinding(),
    ),
    GetPage(
      name: _Paths.AKUN_BIODATA,
      page: () => const AkunBiodataView(),
      binding: AkunBiodataBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.SURAT_LIST,
      page: () => const SuratListView(),
      binding: SuratListBinding(),
    ),
    GetPage(
      name: _Paths.AKUN_EDIT,
      page: () => const AkunEditView(),
      binding: AkunEditBinding(),
    ),
    GetPage(
      name: _Paths.LAPOR_DETAIL,
      page: () => const LaporDetailView(),
      binding: LaporDetailBinding(),
    ),
    GetPage(
      name: _Paths.AKTIVITAS,
      page: () => const AktivitasView(),
      binding: AktivitasBinding(),
    ),
  ];
}
