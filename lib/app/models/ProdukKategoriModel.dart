class ProdukKategoriModel {
  final int id;
  final String nama;

  ProdukKategoriModel({
    required this.id,
    required this.nama,
  });

  factory ProdukKategoriModel.fromJson(Map<String, dynamic> json) {
    return ProdukKategoriModel(
      id: json['id'],
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

