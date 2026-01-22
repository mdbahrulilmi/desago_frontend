import 'package:desago/app/constant/api_constant.dart';
import 'package:desago/app/models/PerangkatModel.dart';
import 'package:desago/app/services/dio_services.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class ProfilDesaController extends GetxController with GetSingleTickerProviderStateMixin {
  // Controller untuk TabBar
  late TabController tabController;
  var isLoading = true.obs;
  final profile = <String, dynamic>{}.obs;
  // List perangkat desa
  final List<PerangkatModel> perangkatDesaList = [
    PerangkatModel(
      nama: 'Nailil Fitri.',
      jabatan: 'Kepala Desa',
      foto: 'assets/img/kepala_desa.jpg',
      periode: '2020 - 2025',
      pendidikan: 'S1 Pendidikan',
      alamat: 'Jl. Desa No. 1, RT 01/RW 01',
      noTelp: '08123456789',
    ),
    PerangkatModel(
      nama: 'Ahmad Fauzi',
      jabatan: 'Sekretaris Desa',
      foto: 'https://via.placeholder.com/150',
      periode: '2020 - 2025',
      pendidikan: 'D3 Administrasi Pemerintahan',
      alamat: 'Jl. Desa No. 5, RT 02/RW 01',
      noTelp: '08123456790',
    ),
    PerangkatModel(
      nama: 'Siti Aminah, S.E.',
      jabatan: 'Kepala Urusan Keuangan',
      foto: 'https://via.placeholder.com/150',
      periode: '2020 - 2025',
      pendidikan: 'S1 Ekonomi',
      alamat: 'Jl. Desa No. 8, RT 03/RW 02',
      noTelp: '08123456791',
    ),
    PerangkatModel(
      nama: 'Budi Santoso',
      jabatan: 'Kepala Urusan Umum',
      foto: 'https://via.placeholder.com/150',
      periode: '2020 - 2025',
      pendidikan: 'SMA',
      alamat: 'Jl. Desa No. 12, RT 04/RW 02',
      noTelp: '08123456792',
    ),
    PerangkatModel(
      nama: 'Dedi Supriadi',
      jabatan: 'Kepala Seksi Pemerintahan',
      foto: 'https://via.placeholder.com/150',
      periode: '2020 - 2025',
      pendidikan: 'D3 Administrasi Publik',
      alamat: 'Jl. Desa No. 15, RT 05/RW 03',
      noTelp: '08123456793',
    ),
    PerangkatModel(
      nama: 'Rina Wati',
      jabatan: 'Kepala Seksi Kesejahteraan',
      foto: 'https://via.placeholder.com/150',
      periode: '2020 - 2025',
      pendidikan: 'S1 Sosiologi',
      alamat: 'Jl. Desa No. 18, RT 06/RW 03',
      noTelp: '08123456794',
    ),
    PerangkatModel(
      nama: 'Hendra Gunawan',
      jabatan: 'Kepala Seksi Pelayanan',
      foto: 'https://via.placeholder.com/150',
      periode: '2020 - 2025',
      pendidikan: 'D3 Manajemen',
      alamat: 'Jl. Desa No. 21, RT 07/RW 04',
      noTelp: '08123456795',
    ),
    PerangkatModel(
      nama: 'Agus Setiawan',
      jabatan: 'Kepala Dusun 1',
      foto: 'https://via.placeholder.com/150',
      periode: '2020 - 2025',
      pendidikan: 'SMA',
      alamat: 'Jl. Dusun 1 No. 5, RT 08/RW 05',
      noTelp: '08123456796',
    ),
    PerangkatModel(
      nama: 'Joko Susilo',
      jabatan: 'Kepala Dusun 2',
      foto: 'https://via.placeholder.com/150',
      periode: '2020 - 2025',
      pendidikan: 'SMA',
      alamat: 'Jl. Dusun 2 No. 3, RT 10/RW 06',
      noTelp: '08123456797',
    ),
  ];
  
  // List BPD
  final List<PerangkatModel> bpdList = [
    PerangkatModel(
      nama: 'H. Mansur, S.H.',
      jabatan: 'Ketua BPD',
      foto: 'https://via.placeholder.com/150',
      periode: '2020 - 2025',
      pendidikan: 'S1 Hukum',
      alamat: 'Jl. Desa No. 25, RT 01/RW 01',
      noTelp: '08123456798',
    ),
    PerangkatModel(
      nama: 'Hj. Fatimah, S.Pd.',
      jabatan: 'Wakil Ketua BPD',
      foto: 'https://via.placeholder.com/150',
      periode: '2020 - 2025',
      pendidikan: 'S1 Pendidikan',
      alamat: 'Jl. Desa No. 30, RT 02/RW 01',
      noTelp: '08123456799',
    ),
    PerangkatModel(
      nama: 'Rahmat Hidayat',
      jabatan: 'Sekretaris BPD',
      foto: 'https://via.placeholder.com/150',
      periode: '2020 - 2025',
      pendidikan: 'D3 Administrasi',
      alamat: 'Jl. Desa No. 35, RT 03/RW 02',
      noTelp: '08123456800',
    ),
    PerangkatModel(
      nama: 'Dewi Lestari',
      jabatan: 'Anggota BPD',
      foto: 'https://via.placeholder.com/150',
      periode: '2020 - 2025',
      pendidikan: 'SMA',
      alamat: 'Jl. Desa No. 40, RT 04/RW 02',
      noTelp: '08123456801',
    ),
    PerangkatModel(
      nama: 'Sugeng Riyadi',
      jabatan: 'Anggota BPD',
      foto: 'https://via.placeholder.com/150',
      periode: '2020 - 2025',
      pendidikan: 'SMA',
      alamat: 'Jl. Desa No. 45, RT 05/RW 03',
      noTelp: '08123456802',
    ),
  ];

  @override
  void onInit() {
    fetchprofile();
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onClose() {
    // Dispose TabController
    tabController.dispose();
    super.onClose();
  }

  Future<void> fetchprofile() async{
    try{
      final res = await DioService.instance.get(
        ApiConstant.profilDesa,
      );

     profile.value = Map<String, dynamic>.from(res.data);
      } catch (e) {
        return;
    } finally{
      isLoading.value = false;
    }
  }
  
  void showPerangkatDetail(PerangkatModel perangkat) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Foto
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.muted,
                    backgroundImage: AssetImage("assets/img/kepala_desa.jpg"),
                    onBackgroundImageError: (exception, stackTrace) {},
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          perangkat.nama,
                          style: AppText.h6(color: AppColors.dark),
                        ),
                        Text(
                          perangkat.jabatan,
                          style: AppText.bodyMedium(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Informasi Detail
              _buildDetailItem('Periode', perangkat.periode),
              _buildDetailItem('Pendidikan', perangkat.pendidikan),
              _buildDetailItem('Alamat', perangkat.alamat),
              _buildDetailItem('No. Telp', perangkat.noTelp),
              
              const SizedBox(height: 10),
              
              SizedBox(
                child: Row(
                  spacing: 10.0,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Icon(Icons.call)
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.bottonGreen,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Icon(Remix.whatsapp_line)
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 10.0, right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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
}