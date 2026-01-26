class PerangkatModel {
  final String nama;
  final String jabatan;
  final String periode;
  final String pendidikan;
  final String alamat;
  final String noTelp;
  final String? image;

  PerangkatModel({
    required this.nama,
    required this.jabatan,
    required this.periode,
    required this.pendidikan,
    required this.alamat,
    required this.noTelp,
    this.image,
  });

  factory PerangkatModel.fromJson(Map<String, dynamic> json) {
    return PerangkatModel(
      nama: json['nama'] ?? '',
      jabatan: json['jabatan'] ?? '',
      periode: json['periode'] ?? '',
      pendidikan: json['pendidikan'] ?? '',
      alamat: json['alamat'] ?? '',
      noTelp: json['notelp'] ?? '',
      image: json['image'],
    );
  }
}
