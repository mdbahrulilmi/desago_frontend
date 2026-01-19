import 'package:auto_size_text/auto_size_text.dart';
import 'package:desago/app/components/bottom_sheet.dart';
import 'package:desago/app/models/NomorPentingModel.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/nomor_penting_controller.dart';

class NomorPentingView extends GetView<NomorPentingController> {
  const NomorPentingView({super.key});

  @override 
  Widget build(BuildContext context) {
    // Inisialisasi AppResponsive
    final AppResponsive responsive = AppResponsive();
    responsive.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'No Darurat',
          style: AppText.h5(color: AppColors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Daftar Nomor Telp Penting',
                  style: AppText.h5(color: AppColors.dark),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Silahkan gunakan layanan nomor telp untuk keadaan darurat dan gunakan dengan bijak',
                  style: AppText.bodyLarge(color: AppColors.dark),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                // Search Field
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.light,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
  controller: controller.searchController,
  onChanged: controller.filterNomorPenting,
  decoration: InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 12),
    hintText: 'Cari nomor penting...',
    hintStyle: AppText.bodyMedium(color: AppColors.textSecondary),
    prefixIcon: Icon(Remix.search_line, color: AppColors.iconGrey),

    suffixIcon: ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller.searchController,
      builder: (context, value, child) {
        if (value.text.isEmpty) return const SizedBox();
        return IconButton(
          icon: Icon(Remix.close_line, color: AppColors.primary),
          onPressed: () {
            controller.searchController.clear();
            controller.filterNomorPenting('');
          },
        );
      },
    ),

    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
  ),
),

                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() => controller.filteredNomorPentingList.isEmpty
                ? Center(
                    child: Text(
                      'Nomor tidak ditemukan',
                      style: AppText.bodyLarge(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.filteredNomorPentingList.length,
                    itemBuilder: (context, index) {
                      final item = controller.filteredNomorPentingList[index];
                      return Card(
                        color: AppColors.white,
                        margin: EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () => _showDetailBottomSheet(context, item),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: AppColors.muted,
                                  backgroundImage: AssetImage("assets/img/kepala_desa.jpg"),
                                  onBackgroundImageError: (exception, stackTrace) {},
                                ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        item.nama,
                                        style:
                                            AppText.h6(color: AppColors.dark),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            item.nomor,
                                            style: AppText.bodyMedium(
                                                color: AppColors.textSecondary),
                                          ),
                                          SizedBox(width: 8),
                                          InkWell(
                                            onTap: () {
                                              controller
                                                  .copyToClipboard(item.nomor);
                                            },
                                            child: Icon(
                                              Remix.file_copy_line,
                                              size: 16,
                                              color: AppColors.info,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.info_outline,
                                  color: AppColors.info,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )),
          ),
        ],
      ),
    );
  }

  // Method untuk menampilkan bottom sheet detail
  void _showDetailBottomSheet(BuildContext context, NomorPentingModel item) {
    AppBottomSheet.show(
      title: 'Detail Kontak',
      content: [
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                item.nama.substring(0, 1).toUpperCase(),
                style: AppText.h2(color: AppColors.primary),
              ),
            ),
          ),
        ),
        SizedBox(height: AppResponsive.h(2)),

        Center(
          child: Text(
            item.nama,
            style: AppText.h5(color: AppColors.dark),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: AppResponsive.h(0.5)),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.nomor,
              style: AppText.h6(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(width: 8),
            InkWell(
              onTap: () {
                controller.copyToClipboard(item.nomor);
              },
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Remix.file_copy_line,
                  size: 20,
                  color: AppColors.info,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppResponsive.h(3)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Get.back();
                controller.callNumber(item.nomor);
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: AppResponsive.w(40),
                padding: AppResponsive.padding(vertical: 1.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Remix.phone_line, color: AppColors.white),
                    SizedBox(width: 8),
                    Text(
                      'Telepon',
                      style: AppText.button(color: AppColors.white),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.back();
                controller.openWhatsApp(item.nomor);
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: AppResponsive.w(40),
                padding: AppResponsive.padding(vertical: 1.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.bottonGreen,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Remix.whatsapp_line, color: AppColors.white),
                    SizedBox(width: 8),
                    Text(
                      'WhatsApp',
                      style: AppText.button(color: AppColors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
