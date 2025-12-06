import 'dart:io';
import 'package:desago/app/utils/app_colors.dart';
import 'package:desago/app/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

class SuratFormController extends GetxController {
  // State variables
  final isLoading = true.obs;
  final kategoriId = ''.obs;
  final suratId = ''.obs;
  final suratTitle = ''.obs;
  final RxMap suratData = {}.obs;
  
  // Form data containers
  final Map<String, TextEditingController> textControllers = {};
  final Map<String, Rx<String?>> dateValues = {};
  final Map<String, RxString> dropdownValues = {};
  final Map<String, RxBool> checkboxValues = {};
  final Map<String, Rx<File?>> fileValues = {};
  
  // Form fields definition - akan diisi berdasarkan jenis surat
  late List<Map<String, dynamic>> formFields;
  
  @override
  void onInit() {
    super.onInit();
    // Dapatkan parameter dari rute
    if (Get.arguments != null) {
      kategoriId.value = Get.arguments['kategoriId'] ?? '';
      suratId.value = Get.arguments['suratId'] ?? '';
      suratTitle.value = Get.arguments['suratTitle'] ?? 'Form Surat';
      suratData.assignAll(Get.arguments['suratData'] ?? {});
    }
    
    // Setup form fields berdasarkan jenis surat
    setupFormFields();
    isLoading.value = false;
  }
  
  @override
  void onClose() {
    // Bersihkan text controllers untuk menghindari memory leak
    textControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.onClose();
  }
  
  // Setup form fields berdasarkan jenis surat
  void setupFormFields() {
    switch(kategoriId.value) {
      case 'keterangan':
        formFields = _setupFormFieldsSuratKeterangan();
        break;
      case 'pengantar':
        formFields = _setupFormFieldsSuratPengantar();
        break;
      case 'rekomendasi':
        formFields = _setupFormFieldsSuratRekomendasi();
        break;
      case 'lainnya':
        formFields = _setupFormFieldsSuratLainnya();
        break;
      default:
        formFields = _setupDefaultFormFields();
    }
    
    // Inisialisasi controllers & values
    for (var field in formFields) {
      switch(field['type']) {
        case 'text':
        case 'number':
          textControllers[field['key']] = TextEditingController();
          break;
        case 'date':
          dateValues[field['key']] = Rx<String?>(null);
          break;
        case 'dropdown':
          dropdownValues[field['key']] = RxString('');
          break;
        case 'checkbox':
          checkboxValues[field['key']] = false.obs;
          break;
        case 'file':
          fileValues[field['key']] = Rx<File?>(null);
          break;
      }
    }
  }
  
  // Helper untuk mendapatkan TextEditingController
  TextEditingController getTextController(String key) {
    return textControllers[key] ?? TextEditingController();
  }
  
  // Helper untuk date fields
  String? getDateValue(String key) {
    return dateValues[key]?.value;
  }
  
  void selectDate(BuildContext context, String key) async {
  final DateTime? picked = await showDatePicker(
    context: context, // Menggunakan context yang diberikan
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.light(primary: AppColors.primary),
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: child!,
      );
    },
  );
  
  if (picked != null) {
    dateValues[key]?.value = DateFormat('dd/MM/yyyy').format(picked);
  }
}
  
  // Helper untuk dropdown fields
  String? getDropdownValue(String key) {
    return dropdownValues[key]?.value.isEmpty == true ? null : dropdownValues[key]?.value;
  }
  
  void setDropdownValue(String key, String? value) {
    if (value != null) {
      dropdownValues[key]?.value = value;
    }
  }
  
  // Helper untuk checkbox fields
  bool getCheckboxValue(String key) {
    return checkboxValues[key]?.value ?? false;
  }
  
  void setCheckboxValue(String key, bool value) {
    checkboxValues[key]?.value = value;
  }
  
  // Helper untuk file fields
  File? getFileValue(String key) {
    return fileValues[key]?.value;
  }
  
  void pickFile(String key) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    
    if (result != null) {
      fileValues[key]?.value = File(result.files.single.path!);
    }
  }
  
  void removeFile(String key) {
    fileValues[key]?.value = null;
  }
  
  // Submit form
  void submitForm() {
    if (!validateForm()) {
      Get.snackbar(
        'Validasi Gagal',
        'Mohon lengkapi semua field yang wajib diisi',
        backgroundColor: AppColors.danger.withOpacity(0.9),
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    // Menampilkan loading
    Get.dialog(
      Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: 20),
              Text('Mengajukan surat...', style: AppText.bodyMedium(color: AppColors.dark)),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
    
    // Simulasi network delay
    Future.delayed(Duration(seconds: 2), () {
      Get.back();
      
      // Tampilkan sukses
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 60,
                ),
                SizedBox(height: 16),
                Text(
                  'Pengajuan Berhasil',
                  style: AppText.h5(color: AppColors.dark),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Pengajuan ${suratTitle.value} Anda berhasil dikirim. Silahkan tunggu untuk diproses oleh petugas.',
                  style: AppText.bodyMedium(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); 
                    Get.back(); // Kembali ke halaman sebelumnya
                    Get.back(); // Kembali ke halaman utama
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(double.infinity, 45),
                  ),
                  child: Text(
                    'Kembali ke Beranda',
                    style: AppText.button(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    });
  }
  
  // Validasi form
  bool validateForm() {
    bool isValid = true;
    
    for (var field in formFields) {
      if (field['required'] == true) {
        switch(field['type']) {
          case 'text':
          case 'number':
            if (textControllers[field['key']]?.text.isEmpty ?? true) {
              isValid = false;
            }
            break;
          case 'date':
            if (dateValues[field['key']]?.value == null) {
              isValid = false;
            }
            break;
          case 'dropdown':
            if (dropdownValues[field['key']]?.value.isEmpty ?? true) {
              isValid = false;
            }
            break;
          case 'file':
            if (fileValues[field['key']]?.value == null) {
              isValid = false;
            }
            break;
        }
      }
    }
    
    return isValid;
  }
  
  // Default form fields
  List<Map<String, dynamic>> _setupDefaultFormFields() {
    return [
      {
        'key': 'nama',
        'type': 'text',
        'label': 'Nama Lengkap',
        'hint': 'Masukkan nama lengkap',
        'required': true,
      },
      {
        'key': 'nik',
        'type': 'text',
        'label': 'NIK',
        'hint': 'Masukkan NIK 16 digit',
        'required': true,
      },
      {
        'key': 'alamat',
        'type': 'text',
        'label': 'Alamat',
        'hint': 'Masukkan alamat lengkap',
        'required': true,
        'multiline': true,
      },
      {
        'key': 'telepon',
        'type': 'text',
        'label': 'Nomor Telepon',
        'hint': 'Masukkan nomor telepon',
        'required': true,
      },
      {
        'key': 'email',
        'type': 'text',
        'label': 'Email',
        'hint': 'Masukkan alamat email',
        'required': false,
      },
      {
        'key': 'ktp',
        'type': 'file',
        'label': 'Unggah KTP',
        'required': true,
      },
      {
        'key': 'persetujuan',
        'type': 'checkbox',
        'label': 'Saya menyatakan bahwa data yang saya isi adalah benar',
      },
    ];
  }
  
  // Setup form fields untuk Surat Keterangan
  List<Map<String, dynamic>> _setupFormFieldsSuratKeterangan() {
    List<Map<String, dynamic>> baseFields = [
      {
        'key': 'nama',
        'type': 'text',
        'label': 'Nama Lengkap',
        'hint': 'Masukkan nama lengkap',
        'required': true,
      },
      {
        'key': 'nik',
        'type': 'text',
        'label': 'NIK',
        'hint': 'Masukkan NIK 16 digit',
        'required': true,
      },
      {
        'key': 'tempat_lahir',
        'type': 'text',
        'label': 'Tempat Lahir',
        'hint': 'Masukkan tempat lahir',
        'required': true,
      },
      {
        'key': 'tanggal_lahir',
        'type': 'date',
        'label': 'Tanggal Lahir',
        'hint': 'Pilih tanggal lahir',
        'required': true,
      },
      {
        'key': 'jenis_kelamin',
        'type': 'dropdown',
        'label': 'Jenis Kelamin',
        'hint': 'Pilih jenis kelamin',
        'required': true,
        'options': [
          {'value': 'L', 'label': 'Laki-laki'},
          {'value': 'P', 'label': 'Perempuan'},
        ],
      },
      {
        'key': 'agama',
        'type': 'dropdown',
        'label': 'Agama',
        'hint': 'Pilih agama',
        'required': true,
        'options': [
          {'value': 'islam', 'label': 'Islam'},
          {'value': 'kristen', 'label': 'Kristen'},
          {'value': 'katolik', 'label': 'Katolik'},
          {'value': 'hindu', 'label': 'Hindu'},
          {'value': 'buddha', 'label': 'Buddha'},
          {'value': 'konghucu', 'label': 'Konghucu'},
          {'value': 'lainnya', 'label': 'Lainnya'},
        ],
      },
      {
        'key': 'alamat',
        'type': 'text',
        'label': 'Alamat',
        'hint': 'Masukkan alamat lengkap',
        'required': true,
        'multiline': true,
      },
      {
        'key': 'telepon',
        'type': 'text',
        'label': 'Nomor Telepon',
        'hint': 'Masukkan nomor telepon',
        'required': true,
      },
      {
        'key': 'ktp',
        'type': 'file',
        'label': 'Unggah KTP',
        'required': true,
      },
      {
        'key': 'kk',
        'type': 'file',
        'label': 'Unggah Kartu Keluarga',
        'required': true,
      },
    ];
    
    // Tambahkan fields spesifik berdasarkan jenis surat keterangan
    switch(suratId.value) {
      case 'k1': // Surat Keterangan Format Bebas
        baseFields.addAll([
          {
            'key': 'section_tujuan',
            'type': 'section',
            'label': 'Informasi Tujuan Surat',
          },
          {
            'key': 'tujuan',
            'type': 'text',
            'label': 'Tujuan Pembuatan Surat',
            'hint': 'Contoh: Untuk keperluan administrasi kantor',
            'required': true,
            'multiline': true,
          },
          {
            'key': 'keterangan',
            'type': 'text',
            'label': 'Keterangan Tambahan',
            'hint': 'Masukkan keterangan tambahan jika ada',
            'required': false,
            'multiline': true,
          },
        ]);
        break;
        
      case 'k4': // Surat Keterangan Domisili
        baseFields.addAll([
          {
            'key': 'section_domisili',
            'type': 'section',
            'label': 'Informasi Domisili',
          },
          {
            'key': 'lama_tinggal',
            'type': 'text',
            'label': 'Lama Tinggal (tahun)',
            'hint': 'Contoh: 5',
            'required': true,
          },
          {
            'key': 'status_tempat_tinggal',
            'type': 'dropdown',
            'label': 'Status Tempat Tinggal',
            'hint': 'Pilih status',
            'required': true,
            'options': [
              {'value': 'milik_sendiri', 'label': 'Milik Sendiri'},
              {'value': 'sewa', 'label': 'Sewa/Kontrak'},
              {'value': 'milik_orang_tua', 'label': 'Milik Orang Tua'},
              {'value': 'rumah_dinas', 'label': 'Rumah Dinas'},
              {'value': 'lainnya', 'label': 'Lainnya'},
            ],
          },
          {
            'key': 'foto_rumah',
            'type': 'file',
            'label': 'Unggah Foto Rumah (tampak depan)',
            'required': false,
          },
        ]);
        break;
        
      case 'k5': // Surat Keterangan Penghasilan
        baseFields.addAll([
          {
            'key': 'section_penghasilan',
            'type': 'section',
            'label': 'Informasi Penghasilan',
          },
          {
            'key': 'pekerjaan',
            'type': 'text',
            'label': 'Pekerjaan',
            'hint': 'Masukkan pekerjaan',
            'required': true,
          },
          {
            'key': 'penghasilan_per_bulan',
            'type': 'number',
            'label': 'Penghasilan Per Bulan (Rp)',
            'hint': 'Contoh: 5000000',
            'required': true,
          },
          {
            'key': 'bukti_penghasilan',
            'type': 'file',
            'label': 'Unggah Bukti Penghasilan (Slip Gaji/Bukti Transaksi)',
            'required': false,
          },
          {
            'key': 'pernyataan_penghasilan',
            'type': 'checkbox',
            'label': 'Saya menyatakan bahwa penghasilan yang saya cantumkan adalah benar',
          },
        ]);
        break;
        
      case 'k6': // Surat Keterangan Usaha
        baseFields.addAll([
          {
            'key': 'section_usaha',
            'type': 'section',
            'label': 'Informasi Usaha',
          },
          {
            'key': 'nama_usaha',
            'type': 'text',
            'label': 'Nama Usaha',
            'hint': 'Masukkan nama usaha',
            'required': true,
          },
          {
            'key': 'jenis_usaha',
            'type': 'text',
            'label': 'Jenis Usaha',
            'hint': 'Contoh: Warung Makan, Toko Kelontong, dll',
            'required': true,
          },
          {
            'key': 'alamat_usaha',
            'type': 'text',
            'label': 'Alamat Usaha',
            'hint': 'Masukkan alamat lengkap usaha',
            'required': true,
            'multiline': true,
          },
          {
            'key': 'tahun_mulai',
            'type': 'number',
            'label': 'Tahun Mulai Usaha',
            'hint': 'Contoh: 2018',
            'required': true,
          },
          {
            'key': 'foto_usaha',
            'type': 'file',
            'label': 'Unggah Foto Tempat Usaha',
            'required': true,
          },
          {
            'key': 'npwp',
            'type': 'file',
            'label': 'Unggah NPWP (jika ada)',
            'required': false,
          },
        ]);
        break;
        
      case 'k9': // Surat Keterangan Belum Menikah
        baseFields.addAll([
          {
            'key': 'section_pernikahan',
            'type': 'section',
            'label': 'Informasi Status Perkawinan',
          },
          {
            'key': 'pernyataan_belum_menikah',
            'type': 'checkbox',
            'label': 'Saya menyatakan bahwa saya belum pernah menikah secara agama maupun catatan sipil',
          },
          {
            'key': 'tujuan_surat',
            'type': 'text',
            'label': 'Tujuan Pembuatan Surat',
            'hint': 'Contoh: Untuk keperluan pendaftaran pernikahan',
            'required': true,
          },
        ]);
        break;
        
      case 'k10': // Surat Keterangan Tidak Mampu
        baseFields.addAll([
          {
            'key': 'section_ekonomi',
            'type': 'section',
            'label': 'Informasi Ekonomi',
          },
          {
            'key': 'pekerjaan',
            'type': 'text',
            'label': 'Pekerjaan',
            'hint': 'Masukkan pekerjaan',
            'required': true,
          },
          {
            'key': 'jumlah_anggota_keluarga',
            'type': 'number',
            'label': 'Jumlah Anggota Keluarga',
            'hint': 'Contoh: 4',
            'required': true,
          },
          {
            'key': 'penghasilan_per_bulan',
            'type': 'number',
            'label': 'Penghasilan Per Bulan (Rp)',
            'hint': 'Contoh: 1500000',
            'required': true,
          },
          {
            'key': 'keperluan_surat',
            'type': 'dropdown',
            'label': 'Keperluan Surat',
            'hint': 'Pilih keperluan',
            'required': true,
            'options': [
              {'value': 'pendidikan', 'label': 'Bantuan Pendidikan'},
              {'value': 'kesehatan', 'label': 'Bantuan Kesehatan'},
              {'value': 'sosial', 'label': 'Bantuan Sosial'},
              {'value': 'lainnya', 'label': 'Lainnya'},
            ],
          },
          {
            'key': 'foto_rumah',
            'type': 'file',
            'label': 'Unggah Foto Rumah (tampak depan dan dalam)',
            'required': true,
          },
          {
            'key': 'pernyataan_kebenaran',
            'type': 'checkbox',
            'label': 'Saya menyatakan bahwa informasi yang saya berikan adalah benar',
          },
        ]);
        break;
        
      // Tambahkan kasus lain sesuai kebutuhan
      default:
        // Untuk semua jenis surat keterangan lainnya, gunakan field default
        baseFields.addAll([
          {
            'key': 'section_keperluan',
            'type': 'section',
            'label': 'Informasi Keperluan',
          },
          {
            'key': 'keperluan',
            'type': 'text',
            'label': 'Keperluan Pembuatan Surat',
            'hint': 'Jelaskan keperluan pembuatan surat ini',
            'required': true,
            'multiline': true,
          },
        ]);
    }
    
    // Tambahkan persetujuan di akhir semua jenis surat
    baseFields.add({
      'key': 'persetujuan',
      'type': 'checkbox',
      'label': 'Saya menyatakan bahwa data yang saya isi adalah benar',
    });
    
    return baseFields;
  }
  
  // Setup form fields untuk Surat Pengantar
  List<Map<String, dynamic>> _setupFormFieldsSuratPengantar() {
    // Base fields untuk semua jenis surat pengantar
    List<Map<String, dynamic>> baseFields = [
      {
        'key': 'nama',
        'type': 'text',
        'label': 'Nama Lengkap',
        'hint': 'Masukkan nama lengkap',
        'required': true,
      },
      {
        'key': 'nik',
        'type': 'text',
        'label': 'NIK',
        'hint': 'Masukkan NIK 16 digit',
        'required': true,
      },
      {
        'key': 'alamat',
        'type': 'text',
        'label': 'Alamat',
        'hint': 'Masukkan alamat lengkap',
        'required': true,
        'multiline': true,
      },
      {
        'key': 'telepon',
        'type': 'text',
        'label': 'Nomor Telepon',
        'hint': 'Masukkan nomor telepon',
        'required': true,
      },
      {
        'key': 'ktp',
        'type': 'file',
        'label': 'Unggah KTP',
        'required': true,
      },
      {
        'key': 'kk',
        'type': 'file',
        'label': 'Unggah Kartu Keluarga',
        'required': true,
      },
    ];
    
    // Tambahkan fields spesifik berdasarkan jenis surat pengantar
    switch(suratId.value) {
      case 'p1': // Surat Pengantar Kuasa
        baseFields.addAll([
          {
            'key': 'section_penerima_kuasa',
            'type': 'section',
            'label': 'Informasi Penerima Kuasa',
          },
          {
            'key': 'nama_penerima',
            'type': 'text',
            'label': 'Nama Penerima Kuasa',
            'hint': 'Masukkan nama lengkap penerima kuasa',
            'required': true,
          },
          {
            'key': 'nik_penerima',
            'type': 'text',
            'label': 'NIK Penerima Kuasa',
            'hint': 'Masukkan NIK 16 digit penerima kuasa',
            'required': true,
          },
          {
            'key': 'alamat_penerima',
            'type': 'text',
            'label': 'Alamat Penerima Kuasa',
            'hint': 'Masukkan alamat lengkap penerima kuasa',
            'required': true,
            'multiline': true,
          },
          {
            'key': 'hubungan',
            'type': 'dropdown',
            'label': 'Hubungan dengan Penerima Kuasa',
            'hint': 'Pilih hubungan',
            'required': true,
            'options': [
              {'value': 'keluarga', 'label': 'Keluarga'},
              {'value': 'teman', 'label': 'Teman'},
              {'value': 'rekan_kerja', 'label': 'Rekan Kerja'},
              {'value': 'lainnya', 'label': 'Lainnya'},
            ],
          },
          {
            'key': 'ktp_penerima',
            'type': 'file',
            'label': 'Unggah KTP Penerima Kuasa',
            'required': true,
          },
          {
            'key': 'keperluan_kuasa',
            'type': 'text',
            'label': 'Keperluan Pemberian Kuasa',
            'hint': 'Jelaskan tujuan pemberian kuasa ini',
            'required': true,
            'multiline': true,
          },
        ]);
        break;
        
      case 'p3': // Surat Pengantar Pindah Domisili
        baseFields.addAll([
          {
            'key': 'section_pindah',
            'type': 'section',
            'label': 'Informasi Pindah Domisili',
          },
          {
            'key': 'alasan_pindah',
            'type': 'dropdown',
            'label': 'Alasan Pindah',
            'hint': 'Pilih alasan',
            'required': true,
            'options': [
              {'value': 'pekerjaan', 'label': 'Pekerjaan'},
              {'value': 'pendidikan', 'label': 'Pendidikan'},
              {'value': 'keluarga', 'label': 'Ikut Keluarga'},
              {'value': 'perumahan', 'label': 'Perumahan'},
              {'value': 'lainnya', 'label': 'Lainnya'},
            ],
          },
          {
            'key': 'alamat_tujuan',
            'type': 'text',
            'label': 'Alamat Tujuan Pindah',
            'hint': 'Masukkan alamat tujuan lengkap',
            'required': true,
            'multiline': true,
          },
          {
            'key': 'provinsi_tujuan',
            'type': 'text',
            'label': 'Provinsi Tujuan',
            'hint': 'Masukkan provinsi tujuan',
            'required': true,
          },
          {
            'key': 'kota_tujuan',
            'type': 'text',
            'label': 'Kota/Kabupaten Tujuan',
            'hint': 'Masukkan kota/kabupaten tujuan',
            'required': true,
          },
          {
            'key': 'kecamatan_tujuan',
            'type': 'text',
            'label': 'Kecamatan Tujuan',
            'hint': 'Masukkan kecamatan tujuan',
            'required': true,
          },
          {
            'key': 'desa_tujuan',
            'type': 'text',
            'label': 'Desa/Kelurahan Tujuan',
            'hint': 'Masukkan desa/kelurahan tujuan',
            'required': true,
          },
          {
            'key': 'tanggal_pindah',
            'type': 'date',
            'label': 'Tanggal Rencana Pindah',
            'hint': 'Pilih tanggal',
            'required': true,
          },
          {
            'key': 'anggota_keluarga_pindah',
            'type': 'checkbox',
            'label': 'Pindah bersama anggota keluarga',
          },
        ]);
        break;
        
      case 'p5': // Surat Pengantar Izin Keramaian
        baseFields.addAll([
          {
            'key': 'section_keramaian',
            'type': 'section',
            'label': 'Informasi Kegiatan Keramaian',
          },
          {
            'key': 'jenis_kegiatan',
            'type': 'text',
            'label': 'Jenis Kegiatan',
            'hint': 'Contoh: Pernikahan, Syukuran, Pengajian, dll',
            'required': true,
          },
          {
            'key': 'tempat_kegiatan',
            'type': 'text',
            'label': 'Tempat Kegiatan',
            'hint': 'Masukkan alamat/lokasi kegiatan',
            'required': true,
            'multiline': true,
          },
          {
            'key': 'tanggal_mulai',
            'type': 'date',
            'label': 'Tanggal Mulai Kegiatan',
            'hint': 'Pilih tanggal',
            'required': true,
          },
          {
            'key': 'tanggal_selesai',
            'type': 'date',
            'label': 'Tanggal Selesai Kegiatan',
            'hint': 'Pilih tanggal',
            'required': true,
          },
          {
            'key': 'waktu_mulai',
            'type': 'text',
            'label': 'Waktu Mulai (Jam)',
            'hint': 'Contoh: 08:00',
            'required': true,
          },
          {
            'key': 'waktu_selesai',
            'type': 'text',
            'label': 'Waktu Selesai (Jam)',
            'hint': 'Contoh: 16:00',
            'required': true,
          },
          {
            'key': 'estimasi_peserta',
            'type': 'number',
            'label': 'Estimasi Jumlah Peserta',
            'hint': 'Masukkan jumlah perkiraan peserta',
            'required': true,
          },
          {
            'key': 'penanggungjawab',
            'type': 'text',
            'label': 'Penanggung Jawab Acara',
            'hint': 'Masukkan nama penanggung jawab',
            'required': true,
          },
          {
            'key': 'susunan_acara',
            'type': 'file',
            'label': 'Unggah Susunan Acara (PDF/Dokumen)',
            'required': false,
          },
          {
            'key': 'denah_lokasi',
            'type': 'file',
            'label': 'Unggah Denah Lokasi',
            'required': false,
          },
        ]);
        break;
        
      // Tambahkan kasus lain sesuai kebutuhan
      default:
        // Untuk semua jenis surat pengantar lainnya, gunakan field default
        baseFields.addAll([
          {
            'key': 'section_keperluan',
            'type': 'section',
            'label': 'Informasi Keperluan',
          },
          {
            'key': 'keperluan',
            'type': 'text',
            'label': 'Keperluan Pembuatan Surat',
            'hint': 'Jelaskan keperluan pembuatan surat ini',
            'required': true,
            'multiline': true,
          },
        ]);
    }
    
    // Tambahkan persetujuan di akhir semua jenis surat
    baseFields.add({
      'key': 'persetujuan',
      'type': 'checkbox',
      'label': 'Saya menyatakan bahwa data yang saya isi adalah benar',
    });
    
    return baseFields;
  }
  
  List<Map<String, dynamic>> _setupFormFieldsSuratRekomendasi() {
    return _setupDefaultFormFields();
  }
  
  List<Map<String, dynamic>> _setupFormFieldsSuratLainnya() {
    return _setupDefaultFormFields();
  }
}