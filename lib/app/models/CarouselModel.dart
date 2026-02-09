class Carousel {
  final int id;
  final String desaId;
  final String judul;
  final String deskripsi;
  final String gambar;

  Carousel({
    required this.id,
    required this.desaId,
    required this.judul,
    required this.deskripsi,
    required this.gambar,
  });

  factory Carousel.fromJson(Map<String, dynamic> json) {
    return Carousel(
      id: json['id'] ?? 0,
      desaId: json['desa_id'] ?? '',
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      gambar: json['gambar'] ?? '',
    );
  }
}
