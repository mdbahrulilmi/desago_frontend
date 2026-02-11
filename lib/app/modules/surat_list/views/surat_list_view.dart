import 'package:desago/app/helpers/empty_helper.dart';
import 'package:desago/app/modules/surat_list/controllers/surat_list_controller.dart';
import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class SuratListView extends StatelessWidget {
  const SuratListView({super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);
    final controller = Get.put(SuratListController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColors.secondary),
                onPressed: () => Get.back(),
              )
            : null,
        title: Text(
          'Layanan Surat',
          style: AppText.h5(color: AppColors.secondary),
        ),
        actions: [
          Padding(
            padding: AppResponsive.padding(right: 4),
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.SURAT_RIWAYAT_PENGAJUAN);
              },
              style: ElevatedButton.styleFrom(
                padding: AppResponsive.padding(horizontal: 2, vertical: 0.5),
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                elevation: 0,
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.history),
                  SizedBox(width: AppResponsive.w(1)),
                  Text(
                    "Riwayat",
                    style: AppText.bodyMedium(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),

      // 🔥 BODY FIXED
      body: Column(
        children: [
          _buildHeader(controller),

          /// 🔥 INI KUNCI KESELAMATAN
          Expanded(
            child: _buildJenisSuratList(controller),
          ),

          if (!Navigator.canPop(context))
            SizedBox(height: AppResponsive.h(15)),
        ],
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildHeader(SuratListController controller) {
    return Column(
      children: [
        SizedBox(height: AppResponsive.h(2)),
        Container(
          margin: AppResponsive.margin(horizontal: 4),
          width: double.infinity,
          padding: AppResponsive.padding(vertical: 1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.warningCard,
            border: Border.all(color: AppColors.strokeWarningCard),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informasi Penting',
                  style: AppText.bodyMediumBold(color: AppColors.text),
                ),
                SizedBox(height: AppResponsive.h(0.5)),
                Text(
                  'Pastikan data diri Anda di menu Biodata sudah lengkap sebelum mengajukan surat. Proses verifikasi memakan waktu 1–3 hari kerja.',
                  style: AppText.small(color: AppColors.text),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.w(4),
            vertical: AppResponsive.h(1),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari surat...',
              hintStyle: AppText.bodyMedium(color: AppColors.textSecondary),
              prefixIcon: Icon(Remix.search_line, color: AppColors.iconGrey),
              fillColor: AppColors.grey.withOpacity(0.1),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildJenisSuratList(SuratListController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.jenisSuratList.isEmpty) {
        return const EmptyStateWidget(
          title: "Tidak ada surat",
          message: "Saat ini tidak ada surat yang tersedia",
        );
      }

      return ListView.builder(
        padding: AppResponsive.padding(horizontal: 4, top: 1),
        itemCount: controller.jenisSuratList.length,
        itemBuilder: (context, index) {
          final item = controller.jenisSuratList[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.dark.withOpacity(0.2),
              ),
            ),
            child: InkWell(
              onTap: () => controller.navigateToDetail(item),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['nama'] ?? 'Jenis Surat',
                            style: AppText.h6(color: AppColors.dark),
                          ),
                          const SizedBox(height: 6),
                          Text( 
                            item['deskripsi'] ?? '-',
                            style: AppText.bodyMedium(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
