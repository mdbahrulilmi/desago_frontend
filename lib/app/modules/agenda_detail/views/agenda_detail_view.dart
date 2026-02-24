import 'package:desago/app/utils/app_responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/agenda_detail_controller.dart';

class AgendaDetailView extends GetView<AgendaDetailController> {
  const AgendaDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final agenda = Get.arguments as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Detail Agenda',
          style: AppText.h5(color: AppColors.dark),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.dark),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              agenda['judul'] ?? 'Tanpa Judul',
              style: AppText.h4(color: AppColors.dark),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        _getCategoryColor(agenda['kategori']).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    agenda['kategori'] ?? 'Umum',
                    style: AppText.small(
                        color: _getCategoryColor(agenda['kategori'])),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(agenda['status']).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    agenda['status'] ?? 'Direncanakan',
                    style:
                        AppText.small(color: _getStatusColor(agenda['status'])),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildDetailItem(
              icon: Remix.calendar_check_line,
              title: 'Tanggal',
              value: _formatDate(agenda['tanggal']),
            ),
            _buildDetailItem(
              icon: Remix.time_line,
              title: 'Waktu',
              value: _formatTime(agenda['jam_mulai'], agenda['jam_selesai']),
            ),
            _buildDetailItem(
              icon: Remix.map_pin_3_line,
              title: 'Lokasi',
              value: agenda['lokasi'] ?? 'Belum ditentukan',
            ),
            const SizedBox(height: 16),

            if (agenda['gambar'] != null && agenda['gambar'].isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  agenda['gambar'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: AppColors.muted,
                      child: const Icon(Icons.image_not_supported,
                          color: AppColors.textSecondary),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),

            Text(
              'Deskripsi',
              style: AppText.h6(color: AppColors.dark),
            ),
            const SizedBox(height: 8),
            Text(
              agenda['deskripsi'] ?? 'Tidak ada deskripsi',
              style: AppText.bodyMedium(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),

            Text(
              'Peserta',
              style: AppText.h6(color: AppColors.dark),
            ),
            const SizedBox(height: 8),
            _buildParticipantList(agenda['peserta']),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.joinAgenda(agenda['id']);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Daftar',
                      style: AppText.button(color: AppColors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child:  ElevatedButton(
                    onPressed: () {
                     
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Remix.share_line, color: AppColors.light),
                        SizedBox(width: AppResponsive.w(2)),
                        Text(
                          'Bagikan Agenda',
                          style: AppText.button(color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppText.small(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppText.bodyMedium(color: AppColors.dark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantList(List<dynamic>? participants) {
    if (participants == null || participants.isEmpty) {
      return Text(
        'Belum ada peserta yang terdaftar',
        style: AppText.bodyMedium(color: AppColors.textSecondary),
      );
    }

    return Column(
      children: participants.map((participant) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              participant['avatar'] ??
                  'https://ui-avatars.com/api/?name=${participant['nama']}',
            ),
          ),
          title: Text(
            participant['nama'],
            style: AppText.bodyMedium(color: AppColors.dark),
          ),
          trailing:
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          onTap: () {
            controller.viewParticipantProfile(participant['id']);
          },
        );
      }).toList(),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Tanggal Tidak Diketahui';

    try {
      final date = DateTime.parse(dateStr);
      final day = date.day.toString().padLeft(2, '0');
      final month = _getIndonesianMonth(date.month);
      final year = date.year;
      final weekday = _getIndonesianDay(date.weekday);

      return '$weekday, $day $month $year';
    } catch (e) {
      return dateStr;
    }
  }

  String _formatTime(String? startTime, String? endTime) {
    if (startTime == null) return 'Waktu tidak ditentukan';

    if (endTime == null) {
      return startTime;
    }

    return '$startTime - $endTime';
  }

  String _getIndonesianDay(int weekday) {
    switch (weekday) {
      case 1:
        return 'Senin';
      case 2:
        return 'Selasa';
      case 3:
        return 'Rabu';
      case 4:
        return 'Kamis';
      case 5:
        return 'Jumat';
      case 6:
        return 'Sabtu';
      case 7:
        return 'Minggu';
      default:
        return '';
    }
  }

  String _getIndonesianMonth(int month) {
    switch (month) {
      case 1:
        return 'Januari';
      case 2:
        return 'Februari';
      case 3:
        return 'Maret';
      case 4:
        return 'April';
      case 5:
        return 'Mei';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'Agustus';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'Desember';
      default:
        return '';
    }
  }

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'rapat desa':
        return AppColors.primary;
      case 'gotong royong':
        return AppColors.success;
      case 'penyuluhan':
        return AppColors.info;
      case 'perayaan':
        return AppColors.warning;
      case 'pembangunan':
        return AppColors.purple;
      default:
        return AppColors.tertiary;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'aktif':
        return AppColors.success;
      case 'selesai':
        return AppColors.info;
      case 'dibatalkan':
        return AppColors.danger;
      case 'tertunda':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }
}
