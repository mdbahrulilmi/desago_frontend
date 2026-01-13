import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profil_desa_controller.dart';

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
            child: Column(
              children: [
                Text(
                  'Sambutan Kepala Desa',
                  style: 
                  AppText.h5(color: AppColors.dark),
                ),
                const SizedBox(height: 12),
                  ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset('assets/img/kepala_desa.jpg',
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
                                'Nailil Fitri',
                                style: AppText.h4(color: AppColors.text),
                              ),
                        const SizedBox(height: 18),
                        Text(
                          'Selamat datang di Profil Desa Banjaranayar.Desa kami merupakan desa yang terus berkomitmen untuk berkembang, menghadirkan pelayanan terbaik bagi masyarakat, serta mendorong berbagai potensi lokal agar dapat memberikan manfaat seluas-luasnya bagi warga. Melalui halaman profil ini, kami berharap masyarakat dapat mengenal lebih dekat sejarah, visi misi, layanan, serta berbagai program pembangunan yang sedang dan akan dijalankan. Kami juga berterima kasih atas dukungan seluruh warga dalam menjaga kekompakan, gotong royong, dan partisipasi aktif demi kemajuan Desa Banjaranayar. Semoga informasi yang kami sajikan dapat menjadi sumber pengetahuan dan membuka peluang kolaborasi untuk mewujudkan desa yang lebih maju, mandiri, dan sejahtera.',
                          textAlign: TextAlign.justify,
                        )
                      ],
                    ),
          ),

          const SizedBox(height: 16),

          // Card Informasi Desa
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informasi Desa',
                style: AppText.h5(color: AppColors.dark),
              ),
              const SizedBox(height: 16),
          
              // Daftar informasi desa
              _buildInfoItem('Nama Desa', 'Desa Sukamakmur'),
              _buildInfoItem('Kecamatan', 'Ciomas'),
              _buildInfoItem('Kabupaten', 'Bogor'),
              _buildInfoItem('Provinsi', 'Jawa Barat'),
              _buildInfoItem('Kode Pos', '16610'),
              _buildInfoItem('Luas Wilayah', '5.2 km²'),
              _buildInfoItem('Jumlah Penduduk', '8.750 jiwa'),
              _buildInfoItem('Jumlah KK', '2.160 KK'),
              _buildInfoItem('Batas Utara', 'Desa Sukajaya'),
              _buildInfoItem('Batas Selatan', 'Desa Sukatani'),
              _buildInfoItem('Batas Timur', 'Desa Sukamaju'),
              _buildInfoItem('Batas Barat', 'Desa Sukaraja'),
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
                'Terwujudnya Desa Sukamakmur yang maju, mandiri, sejahtera, dan bermartabat dengan berlandaskan iman dan takwa.',
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
              _buildMisiItem(
                  'Meningkatkan pelayanan publik yang profesional dan berkualitas'),
              _buildMisiItem(
                  'Memperkuat ekonomi kerakyatan melalui pengembangan potensi lokal'),
              _buildMisiItem(
                  'Meningkatkan kualitas pendidikan dan kesehatan masyarakat'),
              _buildMisiItem(
                  'Melestarikan nilai-nilai budaya dan kearifan lokal'),
              _buildMisiItem(
                  'Membangun infrastruktur desa yang memadai dan berkelanjutan'),
              _buildMisiItem(
                  'Menjaga keamanan, ketertiban, dan kerukunan warga'),
            ],
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
  Widget _buildInfoItem(String label, String value) {
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
              value,
              style: AppText.bodyMedium(color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk item misi
  Widget _buildMisiItem(String text) {
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
