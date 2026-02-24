class BiodataModel {
  final int id;
  final String desaId;
  final String username;
  final String email;
  final String nik;
  final String namaLengkap;
  final String jenisKelamin;
  final String berlakuHingga;
  final String kewarganegaraan;
  final String pekerjaan;
  final String statusPerkawinan;
  final String agama;
  final String alamat;
  final String golonganDarah;
  final String tempatLahir;
  final String tanggalLahir;
  final String noKk;
  final String verification;
  final String noTelepon;
  final String avatar;
  final String ktpFile;
  final String kkFile;
  final String createdAt;
  final String updatedAt;

  BiodataModel({
    required this.id,
    required this.desaId,
    required this.username,
    required this.email,
    required this.nik,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.berlakuHingga,
    required this.kewarganegaraan,
    required this.pekerjaan,
    required this.statusPerkawinan,
    required this.agama,
    required this.alamat,
    required this.golonganDarah,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.noKk,
    required this.verification,
    required this.noTelepon,
    required this.avatar,
    required this.ktpFile,
    required this.kkFile,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BiodataModel.fromJson(Map<String, dynamic> json) {
    return BiodataModel(
      id: json['id'] ?? 0,
      desaId: json['desa_id'],
      username: json['username'],
      email: json['email'],
      nik: json['nik'],
      namaLengkap: json['nama_lengkap'],
      jenisKelamin: json['jenis_kelamin'],
      berlakuHingga: json['berlaku_hingga'],
      kewarganegaraan: json['kewarganegaraan'] ?? 'WNI',
      pekerjaan: json['pekerjaan'],
      statusPerkawinan: json['status_perkawinan'],
      agama: json['agama'],
      alamat: json['alamat'],
      golonganDarah: json['golongan_darah'],
      tempatLahir: json['tempat_lahir'],
      tanggalLahir: json['tanggal_lahir'],
      noKk: json['no_kk'],
      verification: json['verification'],
      noTelepon: json['no_telepon'],
      avatar: json['avatar'],
      ktpFile: json['ktp_file'],
      kkFile: json['kk_file'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "desa_id": desaId,
      "username": username,
      "email": email,
      "nik": nik,
      "nama_lengkap": namaLengkap,
      "jenis_kelamin": jenisKelamin,
      "berlaku_hingga": berlakuHingga,
      "kewarganegaraan": kewarganegaraan,
      "pekerjaan": pekerjaan,
      "status_perkawinan": statusPerkawinan,
      "agama": agama,
      "alamat": alamat,
      "golongan_darah": golonganDarah,
      "tempat_lahir": tempatLahir,
      "tanggal_lahir": tanggalLahir,
      "no_kk": noKk,
      "verification": verification,
      "no_telepon": noTelepon,
      "avatar": avatar,
      "ktp_file": ktpFile,
      "kk_file": kkFile,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

  bool get isVerified => verification == "verified";
  bool get isPending => verification == "pending";
}
