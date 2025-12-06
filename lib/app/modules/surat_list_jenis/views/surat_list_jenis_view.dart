import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/surat_list_jenis_controller.dart';

class SuratListJenisView extends GetView<SuratListJenisController> {
  const SuratListJenisView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize responsive sizing
    AppResponsive().init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Obx(() => Text(
              controller.kategoriTitle.value,
              style: AppText.h5(color: AppColors.dark),
            )),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.dark),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : _buildJenisSuratList()),
    );
  }

  Widget _buildJenisSuratList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: controller.jenisSuratList.length,
      itemBuilder: (context, index) {
        final item = controller.jenisSuratList[index];
        return // Widget item list surat menggunakan BoxDecoration dengan border
            Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.dark.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: () => controller.navigateToDetail(item),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] ?? 'Jenis Surat',
                          style: AppText.h6(color: AppColors.dark),
                        ),
                        SizedBox(height: 4),
                        Text(
                          item['description'] ?? 'Deskripsi jenis surat',
                          style: AppText.bodyMedium(
                              color: AppColors.textSecondary),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Icon chevron
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
  }
}
