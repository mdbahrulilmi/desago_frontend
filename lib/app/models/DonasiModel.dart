class Donasi {
  final String id;
  final String judul;
  final String organisasi;
  final String deskripsi;
  final String tanggalBerakhir;
  final String targetDonasi;
  final String terkumpul;
  final String gambar_donasi;

  Donasi({
    required this.id,
    required this.judul,
    required this.organisasi,
    required this.deskripsi,
    required this.tanggalBerakhir,
    required this.targetDonasi,
    required this.terkumpul,
    this.gambar_donasi = '',
  });
}