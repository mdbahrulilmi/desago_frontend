class BeritaModel {
  final int id;
  final String judul;
  final String link;
  final String content;
  final String gambar;
  final String author;
  final String kategori;
  final int jumlahDilihat;
  final DateTime timestamp;

  BeritaModel({
    required this.id,
    required this.judul,
    required this.link,
    required this.content,
    required this.gambar,
    required this.author,
    required this.kategori,
    required this.jumlahDilihat,
    required this.timestamp,
  });

  factory BeritaModel.fromJson(Map<String, dynamic> json) {
    return BeritaModel(
      id: json['id'],
      judul: json['judul'] ?? '',
      link: json['link'] ?? '',
      content: json['content'] ?? '',
      gambar: json['gambar'] ?? '',
      author: json['author'] ?? '',
      kategori: json['kategori'] is Map
          ? json['kategori']['nama'] ?? ''
          : json['kategori'] ?? '',
      jumlahDilihat: json['jumlah_dilihat'] ?? 0,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'link': link,
      'content': content,
      'gambar': gambar,
      'author': author,
      'kategori': kategori,
      'jumlah_dilihat': jumlahDilihat,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  String get excerpt {
    final cleanText = content.replaceAll(RegExp(r'<[^>]*>'), '');
    return cleanText.length > 100
        ? '${cleanText.substring(0, 100)}...'
        : cleanText;
  }
}
