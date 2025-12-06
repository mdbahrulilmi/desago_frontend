class LokerDesa {
  final String id;
  final String judul;
  final String instansi;
  final String deskripsi;
  final String batasPendaftaran;
  final String persyaratan;
  final String gambar_loker; 

  LokerDesa({
    required this.id,
    required this.judul,
    required this.instansi,
    required this.deskripsi,
    required this.batasPendaftaran,
    required this.persyaratan,
    this.gambar_loker = '',
  });
}