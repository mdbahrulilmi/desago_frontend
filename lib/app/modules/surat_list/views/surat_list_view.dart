import 'package:desago/app/modules/surat_list/controllers/surat_list_controller.dart';
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
        leading: Navigator.canPop(Get.context!)
      ? IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.secondary),
          onPressed: () => Get.back(),
        )
      : null,
        title: Text(
          'Jenis Surat',
          style: AppText.h5(color: AppColors.secondary),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: AppResponsive.margin(horizontal: 4),
              height: AppResponsive.h(14.2),
              width: double.infinity,
              padding: AppResponsive.padding(vertical: 1),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.warningCard,
                  border: Border.all(color: AppColors.strokeWarningCard)
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
                        'Pastikan data diri Anda di menu Biodata sudah lengkap sebelum mengajukan surat. Proses verifikasi memakan waktu 1-3 hari kerja.',
                        style: AppText.small(color: AppColors.text),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.w(4),
              vertical: AppResponsive.h(1),
            ),
            child: TextField(
              // controller: controller.searchController,
              // onChanged: (value) => controller.filterProducts(value),
              decoration: InputDecoration(
                hintText: 'Cari umkm...',
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
           _buildJenisSuratList(controller),
          ],
        ),
      ),
    );
  }

 Widget _buildJenisSuratList(SuratListController controller) {
  return Obx(() {
    if (controller.isLoading.value) {
      return Padding(
        padding: EdgeInsets.only(top: AppResponsive.h(4)),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (controller.jenisSuratList.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: AppResponsive.h(4)),
        child: const Center(child: Text('Data jenis surat kosong')),
      );
    }

    return ListView.builder(
      padding: AppResponsive.padding(horizontal: 4, top: 1),
      itemCount: controller.jenisSuratList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.dark,
                  ),
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
