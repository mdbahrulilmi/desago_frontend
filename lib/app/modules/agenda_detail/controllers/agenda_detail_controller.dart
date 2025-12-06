import 'package:desago/app/utils/app_colors.dart';
import 'package:get/get.dart';

class AgendaDetailController extends GetxController {
  // Fungsi untuk bergabung ke agenda
  void joinAgenda(String agendaId) {
    // Implementasi logika untuk bergabung/mendaftar ke agenda
    Get.snackbar(
      'Berhasil',
      'Anda telah terdaftar dalam agenda ini',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.success,
      colorText: AppColors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // Fungsi untuk membagikan agenda
  void shareAgenda(Map<String, dynamic> agenda) {
    // Implementasi logika untuk membagikan agenda
    Get.snackbar(
      'Berhasil',
      'Agenda berhasil dibagikan',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.info,
      colorText: AppColors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // Fungsi untuk melihat profil peserta
  void viewParticipantProfile(String participantId) {
    // Navigasi ke halaman profil peserta
    Get.toNamed('/participant/$participantId');
  }
}