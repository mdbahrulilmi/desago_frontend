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
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      desaId: json['desa_id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      nik: json['nik']?.toString() ?? '',
      namaLengkap: json['nama_lengkap']?.toString() ?? '',
      jenisKelamin: json['jenis_kelamin']?.toString() ?? '',
      berlakuHingga: json['berlaku_hingga']?.toString() ?? '',
      kewarganegaraan: json['kewarganegaraan']?.toString() ?? 'WNI',
      pekerjaan: json['pekerjaan']?.toString() ?? '',
      statusPerkawinan: json['status_perkawinan']?.toString() ?? '',
      agama: json['agama']?.toString() ?? '',
      alamat: json['alamat']?.toString() ?? '',
      golonganDarah: json['golongan_darah']?.toString() ?? '',
      tempatLahir: json['tempat_lahir']?.toString() ?? '',
      tanggalLahir: json['tanggal_lahir']?.toString() ?? '',
      noKk: json['no_kk']?.toString() ?? '',
      verification: json['verification'] ?? false,
      noTelepon: json['no_telepon']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '',
      ktpFile: json['ktp_file']?.toString() ?? '',
      kkFile: json['kk_file']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
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
