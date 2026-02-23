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
        title: Obx((){
          final desa = controller.desa.value;
          if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          return Text(
          "Profil Desa ${desa?.nama ?? '' }",
          style: AppText.h5(color: AppColors.white),
        );
        }),        
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
                RefreshIndicator(
                    onRefresh: controller.refreshProfile,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        _buildProfilTab(context),
                      ],
                    ),
                  ),

                  // ===== TAB PERANGKAT =====
                  RefreshIndicator(
                    onRefresh: controller.refreshProfile,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        _buildPerangkatTab(context),
                      ],
                    ),
                  ),
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
                return const Center(child: CircularProgressIndicator());
              }

              final desa = controller.desa.value;
              if (desa == null) return const SizedBox();
             final raw = desa.misi ?? '';

final misiList = (desa.misi ?? '')
    .replaceAll('\r', '')
    .replaceAll('\n', ' ')
    .trim()
    .split('.')
    .map((e) => e.replaceAll(RegExp(r'\s+'), ' ').trim())
    .where((e) => e.isNotEmpty)
    .toList();

              return Column(
                children: [
                  Text(
                    '',
                    style: AppText.h5(color: AppColors.dark),
                  ),
                  const SizedBox(height: 12),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: (desa.kepalaDesa?.gambar != null && desa.kepalaDesa!.gambar!.isNotEmpty)
                      ? Image.network(
                          desa.kepalaDesa!.gambar!,
                          width: 147,
                          height: 203,
                          fit: BoxFit.cover,
                        )
                        : null
                  ),
                  const SizedBox(height: 18),

                  Text(
                    desa.kepalaDesa?.nama ?? '',
                    style: AppText.h4(color: AppColors.text),
                  ),
                  SizedBox(height: AppResponsive.h(4)),
                  Html(
                    data: desa.sambutan,
                    style: {
                      "body": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        fontSize: FontSize(16),
                        textAlign: TextAlign.justify,
                        color: AppColors.text,
                      ),
                    },
                  ),
                  SizedBox(height: AppResponsive.h(2)),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Informasi Desa', style: AppText.h5(color: AppColors.dark)),
                      SizedBox(height: AppResponsive.h(1)),
                      _buildInfoItem('Nama Desa', desa.nama ?? ''),
                      _buildInfoItem('Kecamatan', desa.kecamatan ?? ''),
                      _buildInfoItem('Kabupaten', desa.kabupaten ?? ''),
                      _buildInfoItem('Provinsi', desa.provinsi ?? ''),
                      _buildInfoItem('Kode Pos', desa.kodePos ?? ''),
                      _buildInfoItem('Luas Wilayah', desa.luasWilayah ?? ''),
                      _buildInfoItem('Jumlah Penduduk', desa.jumlahPenduduk?.toString() ?? ''),
                      _buildInfoItem('Jumlah KK', desa.jumlahKk?.toString() ?? ''),
                      _buildInfoItem('Batas Utara', desa.batasUtara ?? ''),
                      _buildInfoItem('Batas Selatan', desa.batasSelatan ?? ''),
                      _buildInfoItem('Batas Timur', desa.batasTimur ?? ''),
                      _buildInfoItem('Batas Barat', desa.batasBarat ?? ''),
                    ],
                  ),

                  SizedBox(height: AppResponsive.h(2)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Visi & Misi', style: AppText.h5(color: AppColors.dark)),
                      SizedBox(height: AppResponsive.h(1)),

                      Text('Visi', style: AppText.h6(color: AppColors.text)),
                      const SizedBox(height: 8),
                      Text(
                        desa.visi ?? '-',
                        style: AppText.bodyMedium(color: AppColors.text),
                        textAlign: TextAlign.justify,
                      ),

                      SizedBox(height: AppResponsive.h(1)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Misi',
                                style: AppText.h6(color: AppColors.text),
                              ),
                              const SizedBox(height: 8),

                              if (misiList.length > 1)
                                ...List.generate(misiList.length, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${index + 1}. ',
                                          style: AppText.bodyMedium(color: AppColors.text),
                                        ),
                                        Expanded(
                                          child: Text(
                                            misiList[index],
                                            style: AppText.bodyMedium(color: AppColors.text),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                              else
                                Text(
                                  desa.misi ?? '-',
                                  style: AppText.bodyMedium(color: AppColors.text),
                                  textAlign: TextAlign.justify,
                                ),
                            ],
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
    return Obx(() {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
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
                SizedBox(height: AppResponsive.h(1)),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.perangkatDesa.length,
                  itemBuilder: (context, index) {
                    final item = controller.perangkatDesa[index];
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
                                backgroundImage: item.gambar != null && item.gambar!.isNotEmpty
                                  ? NetworkImage(item.gambar!)
                                  : const AssetImage('assets/img/kepala_desa.jpg') as ImageProvider,
                                onBackgroundImageError: (exception, stackTrace) {},
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

          SizedBox(height: AppResponsive.h(1)),

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
                SizedBox(height: AppResponsive.h(1)),

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
                          child: CircleAvatar(
                                radius: 30,
                                backgroundColor: AppColors.muted,
                                backgroundImage: item.gambar != null && item.gambar!.isNotEmpty
                                  ? NetworkImage(item.gambar!)
                                  : const AssetImage('assets/img/kepala_desa.jpg') as ImageProvider,
                                onBackgroundImageError: (exception, stackTrace) {},
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
    });
  }

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
            style: AppText.bodyMediumBold(color: AppColors.text),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildMisiItem(String e, {required int index}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$index. ', style: AppText.bodyMedium(color: AppColors.text)),
          Expanded(
            child: Text(
              e ?? '-',
              style: AppText.bodyMedium(color: AppColors.text),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
