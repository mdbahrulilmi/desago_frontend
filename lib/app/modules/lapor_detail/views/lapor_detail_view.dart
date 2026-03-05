import 'package:desago/app/helpers/time_helper.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lapor_detail_controller.dart';

class LaporDetailView extends GetView<LaporDetailController> {
  const LaporDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Detail Pengaduan',
          style: AppText.h5(color: AppColors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: Get.back,
        ),
      ),
      body: Obx(() {
        /// 🔥 LOADING STATE
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final laporan = controller.laporan.value;

        /// 🔥 DATA NULL STATE
        if (laporan == null) {
          return const Center(
            child: Text("Data tidak ditemukan"),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: AppResponsive.padding(horizontal: 5, vertical: 2),
            child: Column(
              children: [
                Card(
                  color: AppColors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔥 GAMBAR (SAFE)
                      if ((laporan.gambar ?? "").isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            "https://backend.desagodigital.id/uploads/lapor/${laporan.gambar}",
                            width: double.infinity,
                            height: AppResponsive.h(24),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const SizedBox(),
                          ),
                        ),

                      Padding(
                        padding: AppResponsive.padding(
                            vertical: 2, horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// JUDUL
                            Text(
                              laporan.judul ?? "-",
                              style: AppText.h6(color: AppColors.text),
                            ),

                            _space(),

                            /// STATUS
                            _label("Status"),
                            Text(
                              laporan.status ?? "-",
                              style: AppText.bodyMedium(
                                color: AppColors.textSecondary,
                              ),
                            ),

                            _space(),

                            /// DITUJUKAN
                            _label("Ditujukan ke"),
                            Text(
                              laporan.ditujukan ?? "-",
                              style: AppText.bodyMedium(
                                color: AppColors.textSecondary,
                              ),
                            ),

                            _space(),

                            /// KATEGORI (SAFE NULL)
                            _label("Kategori"),
                            Text(
                              laporan.kategori?.nama ??
                                  "Tidak ada kategori",
                              style: AppText.bodyMedium(
                                color: AppColors.textSecondary,
                              ),
                            ),

                            _space(),

                            /// WAKTU
                            _label("Waktu"),
Text(
  laporan.created_at != null
      ? TimeHelper.formatJamDateTime(laporan.created_at)
      : "-",
  style: AppText.bodyMedium(
    color: AppColors.textSecondary,
  ),
),

_space(),

_label("Tanggal"),
Text(
  laporan.created_at != null
      ? TimeHelper.formatTanggalDate(laporan.created_at)
      : "-",
  style: AppText.bodyMedium(
    color: AppColors.textSecondary,
  ),
),
                            _space(),

                            /// DESKRIPSI
                            _label("Deskripsi"),
                            Text(
                              laporan.deskripsi ?? "-",
                              style: AppText.bodyMedium(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.justify,
                            ),

                            _space(),

                            /// TANGGAPAN (SAFE NULL)
                            _label("Tanggapan"),
                            Text(
                              (laporan.tanggapan ?? "").isNotEmpty
                                  ? laporan.tanggapan!
                                  : "Belum ada tanggapan",
                              style: AppText.bodyMedium(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppResponsive.h(2)),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  height: AppResponsive.h(6),
                  child: ElevatedButton(
                    onPressed: Get.back,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Selesai',
                      style: AppText.button(color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: AppText.bodyMediumBold(color: AppColors.text),
    );
  }

  Widget _space() => SizedBox(height: AppResponsive.h(1));
}