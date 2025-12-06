import 'package:get/get.dart';

import '../controllers/surat_riwayat_pengajuan_detail_controller.dart';

class SuratRiwayatPengajuanDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuratRiwayatPengajuanDetailController>(
      () => SuratRiwayatPengajuanDetailController(),
    );
  }
}
