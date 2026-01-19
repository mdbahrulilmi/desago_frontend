import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuratListView extends StatelessWidget {
  const SuratListView({super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsive().init(context);

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
      body: _buildJenisSuratList(),
    );
  }

  /// DATA STATIK
  final List<Map<String, String>> jenisSuratList = const [
    {
      'title': 'Surat Keterangan Domisili',
      'description': 'Digunakan untuk keperluan administrasi domisili.'
    },
    {
      'title': 'Surat Keterangan Usaha',
      'description': 'Digunakan untuk pengajuan usaha atau UMKM.'
    },
    {
      'title': 'Surat Pengantar',
      'description': 'Digunakan sebagai surat pengantar resmi.'
    },
    {
      'title': 'Surat Keterangan Tidak Mampu',
      'description': 'Digunakan untuk bantuan atau keperluan sosial.'
    },
  ];

  Widget _buildJenisSuratList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jenisSuratList.length,
      itemBuilder: (context, index) {
        final item = jenisSuratList[index];

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
            onTap: () {
              // STATIK → sementara kosong / snackbar
              Get.snackbar(
                'Info',
                item['title'] ?? '',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
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
                          item['title'] ?? 'Jenis Surat',
                          style: AppText.h6(color: AppColors.dark),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['description'] ?? '-',
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
  }
}
