class AnggaranKategoriModel {
  final int id;
  final String nama;
  final int? parentId;
  final String tipe;
  final int? urutan;

  AnggaranKategoriModel({
    required this.id,
    required this.nama,
    this.parentId,
    required this.tipe,
    this.urutan,
  });

  factory AnggaranKategoriModel.fromJson(Map<String, dynamic> json) {
    return AnggaranKategoriModel(
      id: json['id'],
      nama: json['nama'],
      parentId: json['parent_id'],
      tipe: json['tipe'],
      urutan: json['urutan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'parent_id': parentId,
      'tipe': tipe,
      'urutan': urutan,
    };
  }
}
