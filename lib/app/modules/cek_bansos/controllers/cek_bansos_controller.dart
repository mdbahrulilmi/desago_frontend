import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CekBansosController extends GetxController {
  // Controller untuk input nama PM
  final namaPMController = TextEditingController();
  
  // Variabel untuk dropdown
  final selectedProvinsi = ''.obs;
  final selectedKabupaten = ''.obs;
  final selectedKecamatan = ''.obs;
  final selectedDesa = ''.obs;
  
  // Daftar pilihan dropdown
  final provinsiList = <String>[
    'JAWA BARAT',
    'JAWA TENGAH',
    'JAWA TIMUR',
    'DKI JAKARTA',
    'BANTEN',
  ].obs;
  
  final kabupatenList = <String>[].obs;
  final kecamatanList = <String>[].obs;
  final desaList = <String>[].obs;
  
  // Data dummy untuk kabupaten berdasarkan provinsi
  final Map<String, List<String>> kabupatenMap = {
    'JAWA BARAT': ['KAB. BANDUNG', 'KAB. BEKASI', 'KAB. BOGOR', 'KAB. CIANJUR', 'KAB. CIREBON'],
    'JAWA TENGAH': ['KAB. SEMARANG', 'KAB. TEMANGGUNG', 'KAB. MAGELANG', 'KAB. PEKALONGAN', 'KAB. TEGAL'],
    'JAWA TIMUR': ['KAB. SURABAYA', 'KAB. MALANG', 'KAB. SIDOARJO', 'KAB. GRESIK', 'KAB. PASURUAN'],
    'DKI JAKARTA': ['JAKARTA PUSAT', 'JAKARTA UTARA', 'JAKARTA BARAT', 'JAKARTA SELATAN', 'JAKARTA TIMUR'],
    'BANTEN': ['KAB. SERANG', 'KAB. TANGERANG', 'KAB. CILEGON', 'KAB. PANDEGLANG', 'KAB. LEBAK'],
  };
  
  // Data dummy untuk kecamatan berdasarkan kabupaten
  final Map<String, List<String>> kecamatanMap = {
    'KAB. BANDUNG': ['DAYEUHKOLOT', 'BANJARAN', 'CILEUNYI', 'BALEENDAH', 'SOREANG'],
    'KAB. TEMANGGUNG': ['KALORAN', 'TEMANGGUNG', 'PRINGSURAT', 'KANDANGAN', 'PARAKAN'],
    'KAB. MAGELANG': ['MUNGKID', 'MUNTILAN', 'MERTOYUDAN', 'SALAMAN', 'BOROBUDUR'],
    // Tambahkan data untuk kabupaten lainnya
  };
  
  // Data dummy untuk desa berdasarkan kecamatan
  final Map<String, List<String>> desaMap = {
    'KALORAN': ['GEBLOG', 'KALORAN', 'KEMLOKO', 'TEPUSEN', 'KALIMANGGIS'],
    'TEMANGGUNG': ['JAMPIROSO', 'TEMANGGUNG', 'JURANG', 'MANDING', 'BUTUH'],
    'MUNGKID': ['MUNGKID', 'PAGER', 'BOJONG', 'RAMBEANAK', 'BLONDO'],
    // Tambahkan data untuk kecamatan lainnya
  };
  
  // Data dummy penerima bansos untuk hasil pencarian
  final dummyData = [
    {
      'nama': 'ANNISA',
      'umur': 24,
      'provinsi': 'JAWA TENGAH',
      'kabupaten': 'KAB. TEMANGGUNG',
      'kecamatan': 'KALORAN',
      'kelurahan': 'GEBLOG',
      'bpnt': {'status': false, 'keterangan': '-', 'periode': '-'},
      'bst': {'status': false, 'keterangan': '-', 'periode': '-'},
      'pkh': {'status': false, 'keterangan': '-', 'periode': '-'},
      'pbi_jk': {'status': false, 'periode': '-'},
      'blt_bbm': {'status': false, 'keterangan': '-', 'periode': '-'},
      'bantuan_yatim_piatu': {'status': false, 'keterangan': '-', 'periode': '-'},
      'rst': {'status': true, 'keterangan': 'YA', 'periode': 'JAN 2025'},
      'permakanan': {'status': false, 'keterangan': 'TIDAK', 'periode': '-'},
      'sembako_adaptif': {'status': false, 'keterangan': 'TIDAK', 'periode': '-'}
    },
    {
      'nama': 'SITI AMINAH',
      'umur': 45,
      'provinsi': 'JAWA TENGAH',
      'kabupaten': 'KAB. TEMANGGUNG',
      'kecamatan': 'KALORAN',
      'kelurahan': 'GEBLOG',
      'bpnt': {'status': true, 'keterangan': 'YA', 'periode': 'JAN-DES 2025'},
      'bst': {'status': true, 'keterangan': 'YA', 'periode': 'JAN-MAR 2025'},
      'pkh': {'status': true, 'keterangan': 'YA', 'periode': 'JAN-DES 2025'},
      'pbi_jk': {'status': true, 'periode': 'JAN-DES 2025'},
      'blt_bbm': {'status': false, 'keterangan': 'TIDAK', 'periode': '-'},
      'bantuan_yatim_piatu': {'status': false, 'keterangan': '-', 'periode': '-'},
      'rst': {'status': false, 'keterangan': '-', 'periode': '-'},
      'permakanan': {'status': false, 'keterangan': '-', 'periode': '-'},
      'sembako_adaptif': {'status': false, 'keterangan': '-', 'periode': '-'}
    }
  ];
  
  @override
  void onInit() {
    super.onInit();
  }
  
  @override
  void onClose() {
    namaPMController.dispose();
    super.onClose();
  }
  
  // Method untuk mengatur provinsi yang dipilih
  void setProvinsi(String provinsi) {
    selectedProvinsi.value = provinsi;
    selectedKabupaten.value = '';
    selectedKecamatan.value = '';
    selectedDesa.value = '';
    
    // Update list kabupaten berdasarkan provinsi yang dipilih
    kabupatenList.clear();
    if (kabupatenMap.containsKey(provinsi)) {
      kabupatenList.addAll(kabupatenMap[provinsi]!);
    }
  }
  
  // Method untuk mengatur kabupaten yang dipilih
  void setKabupaten(String kabupaten) {
    selectedKabupaten.value = kabupaten;
    selectedKecamatan.value = '';
    selectedDesa.value = '';
    
    // Update list kecamatan berdasarkan kabupaten yang dipilih
    kecamatanList.clear();
    if (kecamatanMap.containsKey(kabupaten)) {
      kecamatanList.addAll(kecamatanMap[kabupaten]!);
    }
  }
  
  // Method untuk mengatur kecamatan yang dipilih
  void setKecamatan(String kecamatan) {
    selectedKecamatan.value = kecamatan;
    selectedDesa.value = '';
    
    // Update list desa berdasarkan kecamatan yang dipilih
    desaList.clear();
    if (desaMap.containsKey(kecamatan)) {
      desaList.addAll(desaMap[kecamatan]!);
    }
  }
  
  // Method untuk mengatur desa yang dipilih
  void setDesa(String desa) {
    selectedDesa.value = desa;
  }
  
  // Method untuk melakukan pencarian PM
  void cariPM() {
    // Mendapatkan nama PM
    String namaPM = namaPMController.text.toUpperCase();
    
    // Mencari data penerima bansos berdasarkan kriteria
    List<Map<String, dynamic>> hasilPencarian = [];
    
    for (var data in dummyData) {
      bool match = true;
      
      // Filter berdasarkan nama jika ada
      if (namaPM.isNotEmpty && !data['nama'].toString().contains(namaPM)) {
        match = false;
      }
      
      // Filter berdasarkan wilayah yang dipilih
      if (selectedProvinsi.isNotEmpty && data['provinsi'] != selectedProvinsi.value) {
        match = false;
      }
      
      if (selectedKabupaten.isNotEmpty && data['kabupaten'] != selectedKabupaten.value) {
        match = false;
      }
      
      if (selectedKecamatan.isNotEmpty && data['kecamatan'] != selectedKecamatan.value) {
        match = false;
      }
      
      if (selectedDesa.isNotEmpty && data['kelurahan'] != selectedDesa.value) {
        match = false;
      }
      
      if (match) {
        hasilPencarian.add(data);
      }
    }
    
    // Navigasi ke halaman hasil dengan data hasil pencarian
    if (hasilPencarian.isNotEmpty) {
      Get.toNamed('/cek-bansos-hasil', arguments: {
        'hasil': hasilPencarian,
        'wilayah': {
          'provinsi': selectedProvinsi.value,
          'kabupaten': selectedKabupaten.value,
          'kecamatan': selectedKecamatan.value,
          'kelurahan': selectedDesa.value
        }
      });
    } else {
      Get.snackbar(
        'Tidak Ada Data',
        'Tidak ditemukan data penerima bansos berdasarkan kriteria pencarian',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}