import 'package:desago/app/routes/app_pages.dart';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_responsive.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '../controllers/agenda_controller.dart';

class AgendaView extends GetView<AgendaController> {
  const AgendaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Agenda Desa',
          style: AppText.h5(color: AppColors.dark),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.dark),
            onPressed: () {
              // Tampilkan dialog pencarian
              _showSearchDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.dark),
            onPressed: () {
              // Tampilkan filter agenda
              _showFilterOptions(context);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          // Refresh data agenda
          await controller.refreshAgendaList();
        },
        child: Column(
          children: [
            // Header kalender mini
            _buildCalendarHeader(),

            // Filter chips untuk kategori
            _buildCategoryFilter(),

            // Daftar agenda
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (controller.agendaList.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildAgendaList();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    final currentDate = DateTime.now();
    final currentMonth = _getIndonesianMonth(currentDate.month);

    return Container(
      padding: AppResponsive.padding(all: 2, vertical: 1),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppResponsive.padding(horizontal: 2, vertical: 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$currentMonth ${currentDate.year}",
                  style: AppText.h6(color: AppColors.dark),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.calendar_today, size: 20),
                      onPressed: () {
                        // Tampilkan kalender lengkap
                        _showFullCalendar(currentDate);
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        // Tampilkan semua agenda dalam satu bulan
                        controller.viewAllMonthlyAgenda();
                      },
                      child: Text(
                        'Lihat Semua',
                        style: AppText.button(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 14, // Tampilkan 2 minggu ke depan
              itemBuilder: (context, index) {
                final day = currentDate.add(Duration(days: index));
                final isToday = day.day == currentDate.day &&
                    day.month == currentDate.month &&
                    day.year == currentDate.year;
                final hasEvent = controller.hasAgendaOnDate(day);

                return GestureDetector(
                  onTap: () {
                    // Filter agenda berdasarkan tanggal yang dipilih
                    controller.selectDate(day);
                  },
                  child: Container(
                    width: 45,
                    margin: AppResponsive.margin(horizontal: 0.5),
                    decoration: BoxDecoration(
                      color: isToday
                          ? AppColors.primary
                          : hasEvent
                              ? AppColors.skyBlue
                              : AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isToday
                            ? AppColors.primary
                            : hasEvent
                                ? AppColors.lightBlue
                                : AppColors.muted,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getIndonesianDayShort(day.weekday),
                          style: AppText.small(
                            color: isToday
                                ? AppColors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isToday ? AppColors.white : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              day.day.toString(),
                              style: AppText.bodyMedium(
                                color: isToday
                                    ? AppColors.primary
                                    : hasEvent
                                        ? AppColors.primary
                                        : AppColors.dark,
                              ),
                            ),
                          ),
                        ),
                        if (hasEvent)
                          Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      padding: AppResponsive.padding(all: 2),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kategori',
            style: AppText.bodyMedium(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 35,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('Semua', isSelected: true),
                _buildFilterChip('Rapat Desa'),
                _buildFilterChip('Gotong Royong'),
                _buildFilterChip('Penyuluhan'),
                _buildFilterChip('Perayaan'),
                _buildFilterChip('Pembangunan'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        // Filter berdasarkan kategori
        controller.filterByCategory(label);
      },
      child: Container(
        margin: AppResponsive.margin(right: 1),
        padding: AppResponsive.padding(horizontal: 2, vertical: 0.5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.muted,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppText.small(
              color: isSelected ? AppColors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAgendaList() {
    return ListView.builder(
      padding: AppResponsive.padding(all: 2),
      itemCount: controller.agendaList.length,
      itemBuilder: (context, index) {
        final agenda = controller.agendaList[index];

        // Tampilkan header tanggal jika berbeda dengan item sebelumnya
        bool showDateHeader = index == 0 ||
            _formatDate(agenda['tanggal']) !=
                _formatDate(controller.agendaList[index - 1]['tanggal']);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDateHeader) ...[
              Padding(
                padding: AppResponsive.padding(vertical: 1),
                child: Text(
                  _formatDate(agenda['tanggal']),
                  style: AppText.h6(color: AppColors.dark),
                ),
              ),
              const Divider(color: AppColors.muted),
            ],
            _buildAgendaCard(agenda),
          ],
        );
      },
    );
  }

  Widget _buildAgendaCard(Map<String, dynamic> agenda) {
    return Card(
      color: AppColors.white,
      margin: AppResponsive.margin(bottom: 1.5),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () {
          // Tampilkan detail agenda
          Get.toNamed(Routes.AGENDA_DETAIL, arguments: agenda);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: AppResponsive.padding(all: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge kategori
                  Container(
                    padding:
                        AppResponsive.padding(horizontal: 1, vertical: 0.5),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(agenda['kategori'])
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      agenda['kategori'] ?? 'Umum',
                      style: AppText.small(
                          color: _getCategoryColor(agenda['kategori'])),
                    ),
                  ),
                  const Spacer(),
                  // Status agenda
                  _buildStatusBadge(agenda['status']),
                ],
              ),
              const SizedBox(height: 10),
              // Judul agenda
              Text(
                agenda['judul'] ?? 'Tanpa Judul',
                style: AppText.h6(color: AppColors.dark),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // Waktu dan lokasi
              Row(
                children: [
                  const Icon(Icons.access_time,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(agenda['jam_mulai'], agenda['jam_selesai']),
                    style: AppText.small(color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.location_on,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      agenda['lokasi'] ?? 'Belum ditentukan',
                      style: AppText.small(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Gambar jika ada
              if (agenda['gambar'] != null && agenda['gambar'].isNotEmpty)
                Container(
                  height: 150,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      agenda['gambar'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 150,
                          width: double.infinity,
                          color: AppColors.muted,
                          child: const Icon(Icons.image_not_supported,
                              color: AppColors.textSecondary),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              // Deskripsi singkat
              Text(
                agenda['deskripsi'] ?? 'Tidak ada deskripsi',
                style: AppText.bodySmall(color: AppColors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Footer dengan peserta dan tombol aksi
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Perbaikan layout
                children: [
                  // Avatar stack untuk peserta
                  if ((agenda['peserta'] as List<dynamic>?)?.isNotEmpty ??
                      false)
                    _buildParticipantAvatars(
                        agenda['peserta'] as List<dynamic>),
                  // Tombol daftar/gabung
                  TextButton.icon(
                    onPressed: () {
                      // Daftar atau gabung ke agenda
                      controller.joinAgenda(agenda['id']);
                    },
                    icon: Icon(Remix.checkbox_circle_line, color: AppColors.dark,),
                    label: Text('Daftar', style: AppText.pSmall(),),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding:
                          AppResponsive.padding(horizontal: 1, vertical: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget yang diperbaiki untuk menampilkan avatar peserta
  Widget _buildParticipantAvatars(List<dynamic> participants) {
    final displayCount = participants.length > 3 ? 3 : participants.length;

    return Row(
      children: [
        Container(
          width: 80,
          height: 30,
          child: Stack(
            children: List.generate(
              displayCount,
              (index) => Positioned(
                left: index * 20.0,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                    image: DecorationImage(
                      image: NetworkImage(
                        participants[index]['avatar'] ??
                            'https://ui-avatars.com/api/?name=User',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (participants.length > 3)
          Text(
            '+${participants.length - 3} lainnya',
            style: AppText.small(color: AppColors.textSecondary),
          ),
      ],
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status?.toLowerCase()) {
      case 'aktif':
        bgColor = AppColors.success.withOpacity(0.2);
        textColor = AppColors.success;
        label = 'Aktif';
        break;
      case 'selesai':
        bgColor = AppColors.info.withOpacity(0.2);
        textColor = AppColors.info;
        label = 'Selesai';
        break;
      case 'dibatalkan':
        bgColor = AppColors.danger.withOpacity(0.2);
        textColor = AppColors.danger;
        label = 'Dibatalkan';
        break;
      case 'tertunda':
        bgColor = AppColors.warning.withOpacity(0.2);
        textColor = AppColors.warning;
        label = 'Tertunda';
        break;
      default:
        bgColor = AppColors.muted.withOpacity(0.2);
        textColor = AppColors.textSecondary;
        label = 'Direncanakan';
    }

    return Container(
      padding: AppResponsive.padding(horizontal: 1, vertical: 0.5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppText.small(color: textColor),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: Image.network(
              'https://img.freepik.com/free-vector/calendar-concept-illustration_114360-1289.jpg',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Belum Ada Agenda',
            style: AppText.h5(color: AppColors.dark),
          ),
          const SizedBox(height: 8),
          Text(
            'Belum ada agenda yang tersedia saat ini',
            style: AppText.bodyMedium(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              // Refresh data
              controller.refreshAgendaList();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Muat Ulang'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: AppResponsive.padding(horizontal: 3, vertical: 1),
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cari Agenda',
          style: AppText.h6(color: AppColors.dark),
        ),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Masukkan kata kunci...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            // Pencarian real-time
            controller.searchAgenda(value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Batal',
              style: AppText.button(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Lakukan pencarian
              Navigator.pop(context);
            },
            child: const Text('Cari'),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: AppResponsive.padding(all: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: AppResponsive.margin(bottom: 2),
                decoration: BoxDecoration(
                  color: AppColors.muted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Filter Agenda',
              style: AppText.h5(color: AppColors.dark),
            ),
            const SizedBox(height: 20),
            // Filter berdasarkan status
            Text(
              'Status',
              style: AppText.h6(color: AppColors.dark),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChip('Semua Status', isSelected: true),
                _buildFilterChip('Aktif'),
                _buildFilterChip('Selesai'),
                _buildFilterChip('Tertunda'),
                _buildFilterChip('Dibatalkan'),
              ],
            ),
            const SizedBox(height: 16),
            // Filter berdasarkan rentang waktu
            Text(
              'Rentang Waktu',
              style: AppText.h6(color: AppColors.dark),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChip('Hari Ini'),
                _buildFilterChip('Minggu Ini', isSelected: true),
                _buildFilterChip('Bulan Ini'),
                _buildFilterChip('Kustom'),
              ],
            ),
            const SizedBox(height: 20),
            // Tombol aksi
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Reset filter
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: BorderSide(
                          color: AppColors.muted.withOpacity(0.5), width: 1.5),
                      padding: AppResponsive.padding(vertical: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      'Reset',
                      style: AppText.button(color: AppColors.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Terapkan filter
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: AppResponsive.padding(vertical: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      shadowColor: AppColors.primary.withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Terapkan',
                          style: AppText.button(color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showFullCalendar(DateTime initialDate) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Kalender Agenda',
          style: AppText.h6(color: AppColors.dark),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: CalendarDatePicker(
            initialDate: initialDate,
            firstDate: DateTime(DateTime.now().year - 1),
            lastDate: DateTime(DateTime.now().year + 1),
            onDateChanged: (date) {
              // Set tanggal yang dipilih
              controller.selectDate(date);
              Get.back();
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Tutup',
              style: AppText.button(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods untuk format tanggal dan waktu
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

  String _getIndonesianDayShort(int weekday) {
    switch (weekday) {
      case 1:
        return 'Sen';
      case 2:
        return 'Sel';
      case 3:
        return 'Rab';
      case 4:
        return 'Kam';
      case 5:
        return 'Jum';
      case 6:
        return 'Sab';
      case 7:
        return 'Min';
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
}
