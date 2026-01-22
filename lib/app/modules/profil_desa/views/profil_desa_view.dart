import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profil_desa_controller.dart';
import 'package:flutter_html/flutter_html.dart';


class ProfilDesaView extends GetView<ProfilDesaController> {
  const ProfilDesaView({super.key});

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
          'Profil Desa Sukamakmur',
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
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: controller.tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelStyle: AppText.button(),
              unselectedLabelStyle: AppText.button(),
              tabs: const [
                Tab(text: 'Profil'),
                Tab(text: 'Perangkat'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                // Tab Profil
                _buildProfilTab(context),

                // Tab Perangkat
                _buildPerangkatTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk Tab Profil
  Widget _buildProfilTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Obx(() {
              
              if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
              final html = controller.profile['isi'];
              final List misiList = controller.profile["informasi_desa"]?["misi"] ?? [];
              return Column(
                children: [
                  Text(
                    controller.profile["profile"] ?? "",
                    style: 
                    AppText.h5(color: AppColors.dark),
                  ),
                  const SizedBox(height: 12),
                    ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network("${ApiConstant.pictureUrl}${controller.profile['gambar']}" ?? "",
                            width: 147,
                              height: 203,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 120,
                                  height: 160,
                                  color: AppColors.muted,
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                    color: AppColors.textSecondary,
                                  ),
                                );})
                          ),
                          const SizedBox(height: 18),
                          Text(
                                  controller.profile['kepala_desa']?['nama'] ?? '',
                                  style: AppText.h4(color: AppColors.text),
                                ),
                          const SizedBox(height: 18),
                               Html(
                                  data: html,
                                  style: {
                                    "body": Style(
                                      margin: Margins.zero,
                                      padding: HtmlPaddings.zero,
                                      fontSize: FontSize(14),
                                      textAlign: TextAlign.justify,
                                      color: AppColors.text,
                                    ),
                                    "p": Style(
                                      margin: Margins.only(bottom: 12),
                                    ),
                                  },
                                ),
                                 const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Informasi Desa',
                              style: AppText.h5(color: AppColors.dark),
                            ),
                            const SizedBox(height: 16),
                      
                            _buildInfoItem('Nama Desa', 'Desa ${controller.profile["informasi_desa"]?["nama"]}'),
                            _buildInfoItem('Kecamatan', controller.profile["informasi_desa"]?["kecamatan"]),
                            _buildInfoItem('Kabupaten', controller.profile["informasi_desa"]?["kabupaten"]),
                            _buildInfoItem('Provinsi', controller.profile["informasi_desa"]?["provinsi"]),
                            _buildInfoItem('Kode Pos', controller.profile["informasi_desa"]?["kodepos"]),
                            _buildInfoItem('Luas Wilayah', controller.profile["informasi_desa"]?["luas_wilayah"]),
                            _buildInfoItem('Jumlah Penduduk', controller.profile["informasi_desa"]?["jumlah_penduduk"]),
                            _buildInfoItem('Jumlah KK', controller.profile["informasi_desa"]?["jumlah_kk"]),
                            _buildInfoItem('Batas Utara', controller.profile["informasi_desa"]?["batas_utara"]),
                            _buildInfoItem('Batas Selatan', controller.profile["informasi_desa"]?["batas_selatan"]),
                            _buildInfoItem('Batas Timur', controller.profile["informasi_desa"]?["batas_timur"]),
                            _buildInfoItem('Batas Barat', controller.profile["informasi_desa"]?["batas_barat"]),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Visi & Misi',
                              style: AppText.h5(color: AppColors.dark),
                            ),
                            const SizedBox(height: 16),
                        
                            // Visi
                            Text(
                              'Visi',
                              style: AppText.h6(color: AppColors.text),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              controller.profile["informasi_desa"]?["visi"],
                              style: AppText.bodyMedium(color: AppColors.text),
                              textAlign: TextAlign.justify,
                            ),
                        
                            const SizedBox(height: 16),
                        
                            // Misi
                            Text(
                              'Misi',
                              style: AppText.h6(color: AppColors.text),
                            ),
                            const SizedBox(height: 8),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: misiList
                                  .map((e) => _buildMisiItem(e))
                                  .toList(),
                            )

                          ],
                        ),
                            
                        ],
                      );
            }),
          ),
          ],
      ),
    );
  }

  // Widget untuk Tab Perangkat
  Widget _buildPerangkatTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Struktur Perangkat Desa',
                  style: AppText.h5(color: AppColors.dark),
                ),
                const SizedBox(height: 16),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.perangkatDesaList.length,
                  itemBuilder: (context, index) {
                    final item = controller.perangkatDesaList[index];
                    return Card(
                      color: AppColors.white,
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: 
                            CircleAvatar(
                                radius: 30,
                                backgroundColor: AppColors.muted,
                                backgroundImage: AssetImage("assets/img/kepala_desa.jpg"),
                                onBackgroundImageError: (exception, stackTrace) {},
                                // child: Icon(
                                //   Icons.person,
                                //   size: 30,
                                //   color: AppColors.white,
                                // ),
                              ),
                          // Text(
                          //   item.nama.substring(0, 1),
                          //   style: AppText.h6(color: AppColors.primary),
                          // ),
                        ),
                        title: Text(
                          item.nama,
                          style: AppText.h6(color: AppColors.dark),
                        ),
                        subtitle: Text(
                          item.jabatan,
                          style:
                              AppText.bodySmall(color: AppColors.textSecondary),
                        ),
                        trailing: Icon(
                          Icons.info_outline,
                          color: AppColors.info,
                        ),
                        onTap: () {
                          controller.showPerangkatDetail(item);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Card BPD
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Badan Permusyawaratan Desa (BPD)',
                  style: AppText.h5(color: AppColors.dark),
                ),
                const SizedBox(height: 16),

                // List anggota BPD
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.bpdList.length,
                  itemBuilder: (context, index) {
                    final item = controller.bpdList[index];
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.info.withOpacity(0.1),
                          child: Text(
                            item.nama.substring(0, 1),
                            style: AppText.h6(color: AppColors.info),
                          ),
                        ),
                        title: Text(
                          item.nama,
                          style: AppText.h6(color: AppColors.dark),
                        ),
                        subtitle: Text(
                          item.jabatan,
                          style:
                              AppText.bodySmall(color: AppColors.textSecondary),
                        ),
                        trailing: Icon(
                          Icons.info_outline,
                          color: AppColors.info,
                        ),
                        onTap: () {
                          controller.showPerangkatDetail(item);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk item informasi desa
  Widget _buildInfoItem(String label, dynamic value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: AppText.bodyMedium(color: AppColors.textSecondary),
          ),
        ),
        Text(': ', style: AppText.bodyMedium(color: AppColors.text)),
        Expanded(
          child: Text(
            value?.toString() ?? '-',
            style: AppText.bodyMedium(color: AppColors.text),
          ),
        ),
      ],
    ),
  );
}


  // Widget untuk item misi
  Widget _buildMisiItem(dynamic text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: AppText.h6(color: AppColors.text)),
          Expanded(
            child: Text(
              text,
              style: AppText.bodyMedium(color: AppColors.text),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
