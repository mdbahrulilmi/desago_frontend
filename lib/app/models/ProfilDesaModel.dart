import 'package:desago/app/models/PemdesAparaturModel.dart';
import 'package:desago/app/models/VisiMisiModel.dart';

class ProfilDesaModel {
  final String? id;
  final String? subdomain;
  final String? nama;
  final String? sambutan;
  final String? kabupaten;
  final String? kecamatan;
  final String? provinsi;
  final String? kodePos;
  final String? batasSelatan;
  final String? batasTimur;
  final String? batasUtara;
  final String? batasBarat;
  final int? jumlahKk;
  final int? jumlahPenduduk;
  final String? luasWilayah;
  final PemdesAparaturModel? kepalaDesa;
  final VisiMisiModel? visi;
  final List<VisiMisiModel>? misi;
  final List<PemdesAparaturModel>? perangkatDesa;
  final List<PemdesAparaturModel>? bpd;



  ProfilDesaModel({
    this.id,
    this.subdomain,
    this.nama,
    this.sambutan,
    this.kabupaten,
    this.kecamatan,
    this.provinsi,
    this.kodePos,
    this.batasSelatan,
    this.batasTimur,
    this.batasUtara,
    this.batasBarat,
    this.jumlahKk,
    this.jumlahPenduduk,
    this.luasWilayah,
    this.kepalaDesa,
    this.visi,
    this.misi,
    this.perangkatDesa,
    this.bpd,
  });

  factory ProfilDesaModel.fromJson(Map<String, dynamic> json) {
     final List<VisiMisiModel> visiMisiList =
      json['visi_misi'] != null
          ? (json['visi_misi'] as List)
              .map((e) => VisiMisiModel.fromJson(e))
              .toList()
          : [];
    final List<PemdesAparaturModel> aparaturList =
      json['pemdes_aparatur'] != null
          ? (json['pemdes_aparatur'] as List)
              .map((e) => PemdesAparaturModel.fromJson(e))
              .toList()
          : [];

    final PemdesAparaturModel? kepalaDesaAparatur =
    aparaturList.where((e) =>
        e.isPemdes &&
        e.jabatan.toLowerCase().contains('kepala')).isNotEmpty
        ? aparaturList.firstWhere((e) =>
            e.isPemdes &&
            e.jabatan.toLowerCase().contains('kepala'))
        : null;

    return ProfilDesaModel(
      id: json['id'] as String?,
      subdomain: json['subdomain'] as String?,
      nama: json['nama'] as String?,
      sambutan: json['sambutan'] as String?,
      kabupaten: json['kabupaten'] as String?,
      kecamatan: json['kecamatan'] as String?,
      provinsi: json['provinsi'] as String?,
      kodePos: json['kode_pos'] as String?,
      batasSelatan: json['batas_selatan'] as String?,
      batasTimur: json['batas_timur'] as String?,
      batasUtara: json['batas_utara'] as String?,
      batasBarat: json['batas_barat'] as String?,
      jumlahKk: json['jumlah_kk'] != null ? int.tryParse(json['jumlah_kk'].toString()) : null,
      jumlahPenduduk: json['jumlah_penduduk'] != null ? int.tryParse(json['jumlah_penduduk'].toString()) : null,
      luasWilayah: json['luas_wilayah'] as String?,
      kepalaDesa: kepalaDesaAparatur,
      visi: visiMisiList.where((e) => e.isVisi == true).isNotEmpty
        ? visiMisiList.firstWhere((e) => e.isVisi == true)
        : null,
      misi: visiMisiList.where((e) => e.isVisi == false).toList(),
      perangkatDesa: aparaturList.where((e) => e.isPemdes).toList(),
      bpd: aparaturList.where((e) => e.isBpdMember).toList(), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subdomain': subdomain,
      'nama': nama,
      'sambutan': sambutan,
      'kabupaten': kabupaten,
      'kecamatan': kecamatan,
      'provinsi': provinsi,
      'kode_pos': kodePos,
      'batas_selatan': batasSelatan,
      'batas_timur': batasTimur,
      'batas_utara': batasUtara,
      'batas_barat': batasBarat,
      'jumlah_kk': jumlahKk,
      'jumlah_penduduk': jumlahPenduduk,
      'luas_wilayah': luasWilayah,
      'kepala_desa' : kepalaDesa?.toJson(),
      'visi_misi': [
      if (visi != null) visi!.toJson(),
      ...?misi?.map((e) => e.toJson()),
    ],
    'pemdes_aparatur': [
      ...?perangkatDesa?.map((e) => e.toJson()),
      ...?bpd?.map((e) => e.toJson()),
    ],
    };
  }
}
