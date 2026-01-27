class BeritaModel {
  final String image;
  final String title;
  final String excerpt;
  final String category;
  final String date;
  final Map<String, dynamic> raw;

  BeritaModel({
    required this.image,
    required this.title,
    required this.excerpt,
    required this.category,
    required this.date,
    required this.raw,
  });

  factory BeritaModel.fromJson(Map<String, dynamic> json) {
    final isi = (json['isi'] ?? '')
        .replaceAll(RegExp(r'<[^>]*>'), '');

    return BeritaModel(
      image: json['gambar'] ?? '',
      title: json['judul'] ?? '-',
      excerpt: isi.length > 100 ? isi.substring(0, 100) : isi,
      category: json['kategori'] ?? 'Umum',
      date: json['tgl']?.split(' ').first ?? '-',
      raw: json,
    );
  }
}
