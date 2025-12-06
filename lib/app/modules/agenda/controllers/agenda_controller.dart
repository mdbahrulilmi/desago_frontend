import 'package:desago/app/utils/app_colors.dart';
import 'package:get/get.dart';

class AgendaController extends GetxController {
  // Data agenda
  final agendaList = <Map<String, dynamic>>[].obs;
  final filteredAgendaList = <Map<String, dynamic>>[].obs;
  
  // State
  final isLoading = false.obs;
  final selectedDate = Rx<DateTime?>(null);
  final selectedCategory = 'Semua'.obs;
  final selectedStatus = 'Semua Status'.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchAgendaList();
  }
  
  @override
  void onReady() {
    super.onReady();
  }
  
  @override
  void onClose() {
    super.onClose();
  }
  
  // Fungsi untuk mengambil data agenda
  Future<void> fetchAgendaList() async {
    isLoading.value = true;
    
    try {
      // Simulasi delay jaringan
      await Future.delayed(const Duration(seconds: 1));
      
      // Data agenda dummy
      agendaList.value = [
        {
          'id': '1',
          'judul': 'Rapat Pembahasan Anggaran Desa',
          'deskripsi': 'Rapat untuk membahas alokasi anggaran desa tahun 2025 dan evaluasi program yang telah berjalan.',
          'tanggal': '2025-03-15',
          'jam_mulai': '09:00',
          'jam_selesai': '12:00',
          'lokasi': 'Balai Desa Sukamaju',
          'kategori': 'Rapat Desa',
          'status': 'aktif',
          'gambar': 'https://img.freepik.com/free-vector/business-people-analyzing-explaining-finance-charts-reports_74855-14016.jpg',
          'peserta': [
            {'id': '1', 'nama': 'Budi Santoso', 'avatar': 'https://randomuser.me/api/portraits/men/1.jpg'},
            {'id': '2', 'nama': 'Siti Aminah', 'avatar': 'https://randomuser.me/api/portraits/women/2.jpg'},
            {'id': '3', 'nama': 'Joko Widodo', 'avatar': 'https://randomuser.me/api/portraits/men/3.jpg'},
            {'id': '4', 'nama': 'Ani Yudhoyono', 'avatar': 'https://randomuser.me/api/portraits/women/4.jpg'},
          ],
        },
        {
          'id': '2',
          'judul': 'Gotong Royong Pembersihan Saluran Irigasi',
          'deskripsi': 'Kegiatan gotong royong untuk membersihkan saluran irigasi di area persawahan desa untuk persiapan musim tanam.',
          'tanggal': '2025-03-16',
          'jam_mulai': '07:00',
          'jam_selesai': '11:00',
          'lokasi': 'Persawahan Desa Sukamaju',
          'kategori': 'Gotong Royong',
          'status': 'aktif',
          'gambar': 'https://img.freepik.com/free-photo/people-cleaning-together_23-2149155348.jpg',
          'peserta': [
            {'id': '5', 'nama': 'Ahmad Dahlan', 'avatar': 'https://randomuser.me/api/portraits/men/5.jpg'},
            {'id': '6', 'nama': 'Dewi Kartika', 'avatar': 'https://randomuser.me/api/portraits/women/6.jpg'},
            {'id': '7', 'nama': 'Hadi Santoso', 'avatar': 'https://randomuser.me/api/portraits/men/7.jpg'},
            {'id': '8', 'nama': 'Rina Marlina', 'avatar': 'https://randomuser.me/api/portraits/women/8.jpg'},
            {'id': '9', 'nama': 'Bambang Sutejo', 'avatar': 'https://randomuser.me/api/portraits/men/9.jpg'},
          ],
        },
        {
          'id': '3',
          'judul': 'Penyuluhan Kesehatan dan Vaksinasi',
          'deskripsi': 'Kegiatan penyuluhan kesehatan dan vaksinasi untuk warga desa bekerjasama dengan Puskesmas Kecamatan.',
          'tanggal': '2025-03-18',
          'jam_mulai': '08:00',
          'jam_selesai': '14:00',
          'lokasi': 'Posyandu Desa Sukamaju',
          'kategori': 'Penyuluhan',
          'status': 'aktif',
          'gambar': 'https://img.freepik.com/free-photo/medical-workers-senior-man-taking-vaccine_23-2149050521.jpg',
          'peserta': [
            {'id': '10', 'nama': 'Dr. Ratna Sari', 'avatar': 'https://randomuser.me/api/portraits/women/10.jpg'},
            {'id': '11', 'nama': 'Andi Saputra', 'avatar': 'https://randomuser.me/api/portraits/men/11.jpg'},
            {'id': '12', 'nama': 'Wati Susanti', 'avatar': 'https://randomuser.me/api/portraits/women/12.jpg'},
          ],
        },
        {
          'id': '4',
          'judul': 'Perayaan Hari Kemerdekaan',
          'deskripsi': 'Rangkaian acara memperingati Hari Kemerdekaan Indonesia dengan lomba dan penampilan kesenian daerah.',
          'tanggal': '2025-03-20',
          'jam_mulai': '08:00',
          'jam_selesai': '17:00',
          'lokasi': 'Lapangan Desa Sukamaju',
          'kategori': 'Perayaan',
          'status': 'aktif',
          'gambar': 'https://img.freepik.com/free-vector/indonesia-independence-day-celebration_23-2149037431.jpg',
          'peserta': [
            {'id': '13', 'nama': 'Slamet Riyadi', 'avatar': 'https://randomuser.me/api/portraits/men/13.jpg'},
            {'id': '14', 'nama': 'Nia Ramadhani', 'avatar': 'https://randomuser.me/api/portraits/women/14.jpg'},
            {'id': '15', 'nama': 'Ridwan Kamil', 'avatar': 'https://randomuser.me/api/portraits/men/15.jpg'},
          ],
        },
        {
          'id': '5',
          'judul': 'Pembangunan Jembatan Desa',
          'deskripsi': 'Pelaksanaan pembangunan jembatan penghubung antar dusun untuk meningkatkan akses transportasi warga.',
          'tanggal': '2025-03-25',
          'jam_mulai': '07:30',
          'jam_selesai': '16:00',
          'lokasi': 'Dusun Kemuning',
          'kategori': 'Pembangunan',
          'status': 'tertunda',
          'gambar': 'https://img.freepik.com/free-photo/construction-worker-site_23-2147663643.jpg',
          'peserta': [
            {'id': '16', 'nama': 'Agus Pranoto', 'avatar': 'https://randomuser.me/api/portraits/men/16.jpg'},
            {'id': '17', 'nama': 'Tuti Winarti', 'avatar': 'https://randomuser.me/api/portraits/women/17.jpg'},
          ],
        },
        {
          'id': '6',
          'judul': 'Pelatihan Digital Marketing untuk UMKM Desa',
          'deskripsi': 'Pelatihan cara memasarkan produk UMKM secara digital untuk meningkatkan jangkauan pasar.',
          'tanggal': '2025-03-15',
          'jam_mulai': '13:00',
          'jam_selesai': '16:00',
          'lokasi': 'Balai Desa Sukamaju',
          'kategori': 'Penyuluhan',
          'status': 'aktif',
          'gambar': 'https://img.freepik.com/free-photo/people-meeting-digital-marketing_23-2149007186.jpg',
          'peserta': [
            {'id': '18', 'nama': 'Deni Cagur', 'avatar': 'https://randomuser.me/api/portraits/men/18.jpg'},
            {'id': '19', 'nama': 'Rini Mariani', 'avatar': 'https://randomuser.me/api/portraits/women/19.jpg'},
            {'id': '20', 'nama': 'Joko Susilo', 'avatar': 'https://randomuser.me/api/portraits/men/20.jpg'},
          ],
        },
        {
          'id': '7',
          'judul': 'Rapat Koordinasi Pengurus BUMDes',
          'deskripsi': 'Rapat koordinasi bulanan pengurus BUMDes untuk evaluasi kinerja dan perencanaan program.',
          'tanggal': '2025-03-22',
          'jam_mulai': '10:00',
          'jam_selesai': '12:00',
          'lokasi': 'Kantor BUMDes',
          'kategori': 'Rapat Desa',
          'status': 'aktif',
          'gambar': 'https://img.freepik.com/free-photo/group-business-people-having-meeting_23-2149921614.jpg',
          'peserta': [
            {'id': '21', 'nama': 'Hendra Setiawan', 'avatar': 'https://randomuser.me/api/portraits/men/21.jpg'},
            {'id': '22', 'nama': 'Susi Pudjiastuti', 'avatar': 'https://randomuser.me/api/portraits/women/22.jpg'},
          ],
        },
        {
          'id': '8',
          'judul': 'Sosialisasi Program Keluarga Harapan',
          'deskripsi': 'Sosialisasi bantuan sosial dari pemerintah pusat untuk keluarga kurang mampu di desa.',
          'tanggal': '2025-03-28',
          'jam_mulai': '09:00',
          'jam_selesai': '11:30',
          'lokasi': 'Balai Desa Sukamaju',
          'kategori': 'Penyuluhan',
          'status': 'aktif',
          'gambar': 'https://img.freepik.com/free-photo/group-people-seminar_23-2149310079.jpg',
          'peserta': [
            {'id': '23', 'nama': 'Dimas Kanjeng', 'avatar': 'https://randomuser.me/api/portraits/men/23.jpg'},
            {'id': '24', 'nama': 'Sri Mulyani', 'avatar': 'https://randomuser.me/api/portraits/women/24.jpg'},
          ],
        },
      ];
      
      // Set juga ke filtered list
      filteredAgendaList.value = List.from(agendaList);
    } catch (e) {
      print('Error fetching agenda: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Refresh data
  Future<void> refreshAgendaList() async {
    await fetchAgendaList();
  }
  
  // Filter berdasarkan kategori
  void filterByCategory(String category) {
    selectedCategory.value = category;
    _applyFilters();
  }
  
  // Filter berdasarkan status
  void filterByStatus(String status) {
    selectedStatus.value = status;
    _applyFilters();
  }
  
  // Pilih tanggal
  void selectDate(DateTime date) {
    selectedDate.value = date;
    _applyFilters();
  }
  
  // Reset filter
  void resetFilters() {
    selectedCategory.value = 'Semua';
    selectedStatus.value = 'Semua Status';
    selectedDate.value = null;
    filteredAgendaList.value = List.from(agendaList);
  }
  
  // Cari agenda
  void searchAgenda(String keyword) {
    if (keyword.isEmpty) {
      _applyFilters();
      return;
    }
    
    final lowercaseKeyword = keyword.toLowerCase();
    filteredAgendaList.value = agendaList.where((agenda) {
      final judul = agenda['judul']?.toLowerCase() ?? '';
      final deskripsi = agenda['deskripsi']?.toLowerCase() ?? '';
      final lokasi = agenda['lokasi']?.toLowerCase() ?? '';
      final kategori = agenda['kategori']?.toLowerCase() ?? '';
      
      return judul.contains(lowercaseKeyword) ||
             deskripsi.contains(lowercaseKeyword) ||
             lokasi.contains(lowercaseKeyword) ||
             kategori.contains(lowercaseKeyword);
    }).toList();
  }
  
  // Gabung ke agenda
  void joinAgenda(String agendaId) {
    // Implementasi logika untuk bergabung/mendaftar ke agenda
    Get.snackbar(
      'Berhasil',
      'Anda telah terdaftar dalam agenda ini',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.success,
      colorText: AppColors.white,
      duration: const Duration(seconds: 2),
    );
  }
  
  // Lihat semua agenda dalam satu bulan
  void viewAllMonthlyAgenda() {
    selectedDate.value = null;
    _applyFilters();
    
    Get.snackbar(
      'Info',
      'Menampilkan semua agenda bulan ini',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.info,
      colorText: AppColors.white,
      duration: const Duration(seconds: 2),
    );
  }
  
  // Periksa apakah ada agenda pada tanggal tertentu
  bool hasAgendaOnDate(DateTime date) {
    final formattedDate = _formatDateToString(date);
    return agendaList.any((agenda) => agenda['tanggal'] == formattedDate);
  }
  
  // Helper method untuk menerapkan semua filter
  void _applyFilters() {
    filteredAgendaList.value = agendaList.where((agenda) {
      // Filter berdasarkan kategori
      bool categoryMatch = selectedCategory.value == 'Semua' || 
                           agenda['kategori'] == selectedCategory.value;
      
      // Filter berdasarkan status
      bool statusMatch = selectedStatus.value == 'Semua Status' || 
                         agenda['status'].toLowerCase() == selectedStatus.value.toLowerCase();
      
      // Filter berdasarkan tanggal
      bool dateMatch = true;
      if (selectedDate.value != null) {
        final agendaDate = agenda['tanggal'];
        final selectedDateStr = _formatDateToString(selectedDate.value!);
        dateMatch = agendaDate == selectedDateStr;
      }
      
      return categoryMatch && statusMatch && dateMatch;
    }).toList();
  }
  
  // Helper method untuk format tanggal ke string
  String _formatDateToString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}