import 'package:get/get.dart';

import '../controllers/surat_riwayat_pengajuan_controller.dart';

class SuratRiwayatPengajuanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuratRiwayatPengajuanController>(
      () => SuratRiwayatPengajuanController(),
    );
  }
}
