import 'package:desago/app/utils/app_colors.dart';
import 'package:get/get.dart';

class AgendaDetailController extends GetxController {
  void joinAgenda(String agendaId) {
    Get.snackbar(
      'Berhasil',
      'Anda telah terdaftar dalam agenda ini',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.success,
      colorText: AppColors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void shareAgenda(Map<String, dynamic> agenda) {
    Get.snackbar(
      'Berhasil',
      'Agenda berhasil dibagikan',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.info,
      colorText: AppColors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void viewParticipantProfile(String participantId) {
    Get.toNamed('/participant/$participantId');
  }
}