  import 'package:desago/app/models/AnggaranKategoriModel.dart';

  class AnggaranModel {
    final int id;
    final int kategoriId;
    final String desaId;
    final int tahun;
    final int anggaran;
    final AnggaranKategoriModel? kategori;

    AnggaranModel({
      required this.id,
      required this.kategoriId,
      required this.desaId,
      required this.tahun,
      required this.anggaran,
      this.kategori,
    });

    factory AnggaranModel.fromJson(Map<String, dynamic> json) {
      return AnggaranModel(
        id: json['id'],
        kategoriId: json['kategori_id'],
        desaId: json['desa_id'],
        tahun: json['tahun'],
        anggaran: json['anggaran'],
        kategori: json['kategori'] != null
            ? AnggaranKategoriModel.fromJson(json['kategori'])
            : null,
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'id': id,
        'kategori_id': kategoriId,
        'desa_id': desaId,
        'tahun': tahun,
        'anggaran': anggaran,
      };
    }
  }
