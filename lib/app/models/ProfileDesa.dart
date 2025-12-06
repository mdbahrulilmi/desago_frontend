import 'package:desago/app/models/KabupatenMode.dart';
import 'package:desago/app/models/KecamatanModel.dart';
import 'package:desago/app/models/ProvinsiModel.dart';

class ProfilDesaModel {
  final int? id;
  final int? akunDesaId;
  final String? namaDesa;
  final String? kodeDesa;
  final String? provinsiId;
  final String? kabupatenId;
  final String? kecamatanId;
  final String? alamat;
  final String? email;
  final String? telepon;
  final String? website;
  final String? kepalaDesa;
  final String? visi;
  final String? misi;
  final String? logo;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ProvinsiModel? provinsi;
  final KabupatenModel? kabupaten;
  final KecamatanModel? kecamatan;

  ProfilDesaModel({
    this.id,
    this.akunDesaId,
    this.namaDesa,
    this.kodeDesa,
    this.provinsiId,
    this.kabupatenId,
    this.kecamatanId,
    this.alamat,
    this.email,
    this.telepon,
    this.website,
    this.kepalaDesa,
    this.visi,
    this.misi,
    this.logo,
    this.createdAt,
    this.updatedAt,
    this.provinsi,
    this.kabupaten,
    this.kecamatan,
  });

  factory ProfilDesaModel.fromJson(Map<String, dynamic> json) {
    ProvinsiModel? provinsi;
    KabupatenModel? kabupaten;
    KecamatanModel? kecamatan;

    if (json['provinsi'] != null) {
      provinsi = ProvinsiModel.fromJson(json['provinsi']);
    }

    if (json['kabupaten'] != null) {
      kabupaten = KabupatenModel.fromJson(json['kabupaten']);
    }

    if (json['kecamatan'] != null) {
      kecamatan = KecamatanModel.fromJson(json['kecamatan']);
    }

    return ProfilDesaModel(
      id: json['id'],
      akunDesaId: json['akun_desa_id'],
      namaDesa: json['nama_desa'],
      kodeDesa: json['kode_desa'],
      provinsiId: json['provinsi_id'], 
      kabupatenId: json['kabupaten_id'], 
      kecamatanId: json['kecamatan_id'], 
      alamat: json['alamat'],
      email: json['email'],
      telepon: json['telepon'],
      website: json['website'],
      kepalaDesa: json['kepala_desa'],
      visi: json['visi'],
      misi: json['misi'],
      logo: json['logo'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      provinsi: provinsi,
      kabupaten: kabupaten,
      kecamatan: kecamatan,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'akun_desa_id': akunDesaId,
      'nama_desa': namaDesa,
      'kode_desa': kodeDesa,
      'provinsi_id': provinsiId,
      'kabupaten_id': kabupatenId,
      'kecamatan_id': kecamatanId,
      'alamat': alamat,
      'email': email,
      'telepon': telepon,
      'website': website,
      'kepala_desa': kepalaDesa,
      'visi': visi,
      'misi': misi,
      'logo': logo,
    };
  }
}