class AgendaKategori {
  final int id;
  final String nama;

  AgendaKategori({
    required this.id,
    required this.nama,
  });

  factory AgendaKategori.fromJson(Map<String, dynamic> json) {
    return AgendaKategori(
      id: json['id'],
      nama: json['nama'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
    };
  }
}
