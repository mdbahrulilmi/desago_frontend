class LaporKategoriModel {
  final int id;
  final String nama;

  LaporKategoriModel({
    required this.id,
    required this.nama,
  });

  factory LaporKategoriModel.fromJson(Map<String, dynamic> json) {
    return LaporKategoriModel(
      id: json['id'] as int,
      nama: json['nama'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
    };
  }
}
