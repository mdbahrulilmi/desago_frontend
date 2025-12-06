
import 'package:desago/app/models/ProfileDesa.dart';

class BiodataUserModel {
  final int? id;
  final int? userId;
  final int? desaId;
  final String? nomorKk;
  final String? nik;
  final String? namaLengkap;
  final String? jenisKelamin;
  final String? tempatLahir;
  final DateTime? tanggalLahir;
  final String? golonganDarah;
  final String? agama;
  final String? statusPerkawinan;
  final String? statusHubunganDalamKeluarga;
  final String? cacatFisikMental;
  final String? pendidikanTerakhir;
  final String? jenisPekerjaan;
  final String? nikIbu;
  final String? namaIbuKandung;
  final String? nikAyah;
  final String? namaAyah;
  final String? alamatSebelumnya;
  final String? alamatSekarang;
  final bool? memilikiAktaKelahiran;
  final String? nomorAktaKelahiran;
  final bool? memilikiAktaPerkawinan;
  final String? nomorAktaPerkawinan;
  final DateTime? tanggalPerkawinan;
  final bool? memilikiAktaPerceraian;
  final String? nomorAktaPerceraian;
  final String? sidikJari;
  final String? irisMata;
  final String? tandaTangan;
  final String? fotoWajah;
  final String? fotoKtp;
  final String? fotoKk;
  final ProfilDesaModel? profilDesa;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BiodataUserModel({
    this.id,
    this.userId,
    this.desaId,
    this.nomorKk,
    this.nik,
    this.namaLengkap,
    this.jenisKelamin,
    this.tempatLahir,
    this.tanggalLahir,
    this.golonganDarah,
    this.agama,
    this.statusPerkawinan,
    this.statusHubunganDalamKeluarga,
    this.cacatFisikMental,
    this.pendidikanTerakhir,
    this.jenisPekerjaan,
    this.nikIbu,
    this.namaIbuKandung,
    this.nikAyah,
    this.namaAyah,
    this.alamatSebelumnya,
    this.alamatSekarang,
    this.memilikiAktaKelahiran,
    this.nomorAktaKelahiran,
    this.memilikiAktaPerkawinan,
    this.nomorAktaPerkawinan,
    this.tanggalPerkawinan,
    this.memilikiAktaPerceraian,
    this.nomorAktaPerceraian,
    this.sidikJari,
    this.irisMata,
    this.tandaTangan,
    this.fotoWajah,
    this.fotoKtp,
    this.fotoKk,
    this.profilDesa,
    this.createdAt,
    this.updatedAt,
  });

  factory BiodataUserModel.fromJson(Map<String, dynamic> json) {
    ProfilDesaModel? profilDesa;
    if (json['desa'] != null && json['desa']['profil'] != null) {
      profilDesa = ProfilDesaModel.fromJson(json['desa']['profil']);
    }

    return BiodataUserModel(
      id: json['id'],
      userId: json['user_id'],
      desaId: json['desa_id'],
      nomorKk: json['nomor_kk'],
      nik: json['nik'],
      namaLengkap: json['nama_lengkap'],
      jenisKelamin: json['jenis_kelamin'],
      tempatLahir: json['tempat_lahir'],
      tanggalLahir: json['tanggal_lahir'] != null 
          ? DateTime.parse(json['tanggal_lahir']) 
          : null,
      golonganDarah: json['golongan_darah'],
      agama: json['agama'],
      statusPerkawinan: json['status_perkawinan'],
      statusHubunganDalamKeluarga: json['status_hubungan_dalam_keluarga'],
      cacatFisikMental: json['cacat_fisik_mental'],
      pendidikanTerakhir: json['pendidikan_terakhir'],
      jenisPekerjaan: json['jenis_pekerjaan'],
      nikIbu: json['nik_ibu'],
      namaIbuKandung: json['nama_ibu_kandung'],
      nikAyah: json['nik_ayah'],
      namaAyah: json['nama_ayah'],
      alamatSebelumnya: json['alamat_sebelumnya'],
      alamatSekarang: json['alamat_sekarang'],
      memilikiAktaKelahiran: json['memiliki_akta_kelahiran'] == 1,
      nomorAktaKelahiran: json['nomor_akta_kelahiran'],
      memilikiAktaPerkawinan: json['memiliki_akta_perkawinan'] == 1,
      nomorAktaPerkawinan: json['nomor_akta_perkawinan'],
      tanggalPerkawinan: json['tanggal_perkawinan'] != null
          ? DateTime.parse(json['tanggal_perkawinan'])
          : null,
      memilikiAktaPerceraian: json['memiliki_akta_perceraian'] == 1,
      nomorAktaPerceraian: json['nomor_akta_perceraian'],
      sidikJari: json['sidik_jari'],
      irisMata: json['iris_mata'],
      tandaTangan: json['tanda_tangan'],
      fotoWajah: json['foto_wajah'],
      fotoKtp: json['foto_ktp'],
      fotoKk: json['foto_kk'],
      profilDesa: profilDesa,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'desa_id': desaId,
      'nomor_kk': nomorKk,
      'nik': nik,
      'nama_lengkap': namaLengkap,
      'jenis_kelamin': jenisKelamin,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': tanggalLahir?.toIso8601String(),
      'golongan_darah': golonganDarah,
      'agama': agama,
      'status_perkawinan': statusPerkawinan,
      'status_hubungan_dalam_keluarga': statusHubunganDalamKeluarga,
      'cacat_fisik_mental': cacatFisikMental,
      'pendidikan_terakhir': pendidikanTerakhir,
      'jenis_pekerjaan': jenisPekerjaan,
      'nik_ibu': nikIbu,
      'nama_ibu_kandung': namaIbuKandung,
      'nik_ayah': nikAyah,
      'nama_ayah': namaAyah,
      'alamat_sebelumnya': alamatSebelumnya,
      'alamat_sekarang': alamatSekarang,
      'memiliki_akta_kelahiran': memilikiAktaKelahiran,
      'nomor_akta_kelahiran': nomorAktaKelahiran,
      'memiliki_akta_perkawinan': memilikiAktaPerkawinan,
      'nomor_akta_perkawinan': nomorAktaPerkawinan,
      'tanggal_perkawinan': tanggalPerkawinan?.toIso8601String(),
      'memiliki_akta_perceraian': memilikiAktaPerceraian,
      'nomor_akta_perceraian': nomorAktaPerceraian,
      'sidik_jari': sidikJari,
      'iris_mata': irisMata,
      'tanda_tangan': tandaTangan,
      'foto_wajah': fotoWajah,
      'foto_ktp': fotoKtp,
      'foto_kk': fotoKk,
    };
  }
}