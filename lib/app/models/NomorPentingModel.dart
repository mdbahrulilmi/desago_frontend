class NomorPentingModel {
  final int id;
  final String desaId;
  final String nama;
  final String noTelepon;
  final String? gambar;

  NomorPentingModel({
    required this.id,
    required this.desaId,
    required this.nama,
    required this.noTelepon,
    this.gambar,
  });

  factory NomorPentingModel.fromJson(Map<String, dynamic> json) {
    return NomorPentingModel(
      id: json['id'],
      desaId: json['desa_id'],
      nama: json['nama'],
      noTelepon: json['no_telepon'],
      gambar: json['gambar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'desa_id': desaId,
      'nama': nama,
      'no_telepon': noTelepon,
      'gambar': gambar,
    };
  }
}
