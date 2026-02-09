class PemdesAparaturModel {
  final int id;
  final String desaId;
  final String nama;
  final String nip;
  final String jabatan;
  final String pendidikan;
  final String alamat;
  final String periode;
  final String noTelepon;
  final String gambar;
  final int hiddenTelepon;
  final int isBpd;

  PemdesAparaturModel({
    required this.id,
    required this.desaId,
    required this.nama,
    required this.nip,
    required this.jabatan,
    required this.pendidikan,
    required this.alamat,
    required this.periode,
    required this.noTelepon,
    required this.gambar,
    required this.hiddenTelepon,
    required this.isBpd,
  });

  factory PemdesAparaturModel.fromJson(Map<String, dynamic> json) {
    return PemdesAparaturModel(
      id: json['id'] ?? 0,
      desaId: json['desa_id'] ?? '',
      nama: json['nama'] ?? '',
      nip: json['nip'] ?? '',
      jabatan: json['jabatan'] ?? '',
      pendidikan: json['pendidikan'] ?? '',
      alamat: json['alamat'] ?? '',
      periode: json['periode'] ?? '',
      noTelepon: json['no_telepon'] ?? '',
      gambar: json['gambar'] ?? '',
      hiddenTelepon: json['hidden_telepon'] ?? 0,
      isBpd: json['is_bpd'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'desa_id': desaId,
      'nama': nama,
      'nip': nip,
      'jabatan': jabatan,
      'pendidikan': pendidikan,
      'alamat': alamat,
      'periode': periode,
      'no_telepon': noTelepon,
      'gambar': gambar,
      'hidden_telepon': hiddenTelepon,
      'is_bpd': isBpd,
    };
  }

  bool get isBpdMember => isBpd == 1;

  bool get isPemdes => isBpd == 0;

  bool get canShowPhone => hiddenTelepon == 0;
}
