import 'package:desago/app/models/ProdukKategoriModel.dart';

class ProdukModel {
  final int id;
  final String desaId;
  final int kategoriId;
  final String judul;
  final int hargaMin;
  final int hargaMax;
  final String jamBuka;
  final String jamTutup;
  final String deskripsi;
  final String gambar;
  final String lokasi;
  final String lokasiGmaps;
  final String noTelepon;
  final String notelpFix;
  final ProdukKategoriModel? kategori;

  ProdukModel({
    required this.id,
    required this.desaId,
    required this.kategoriId,
    required this.judul,
    required this.hargaMin,
    required this.hargaMax,
    required this.jamBuka,
    required this.jamTutup,
    required this.deskripsi,
    required this.gambar,
    required this.lokasi,
    required this.lokasiGmaps,
    required this.noTelepon,
    required this.notelpFix,
    this.kategori,
  });

  factory ProdukModel.fromJson(Map<String, dynamic> json) {
    return ProdukModel(
      id: json['id'],
      desaId: json['desa_id'],
      kategoriId: json['kategori_id'],
      judul: json['judul'] ?? '',
      hargaMin: json['harga_min'] ?? 0,
      hargaMax: json['harga_max'] ?? 0,
      jamBuka: json['jam_buka'] ?? '',
      jamTutup: json['jam_tutup'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      gambar: json['gambar'] ?? '',
      lokasi: json['lokasi'] ?? '',
      lokasiGmaps: json['lokasi_gmaps'] ?? '',
      noTelepon: json['no_telepon'] ?? '',
      notelpFix: json['notelp_fix'] ?? '',
      kategori: json['kategori'] != null
          ? ProdukKategoriModel.fromJson(json['kategori'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'desa_id': desaId,
      'kategori_id': kategoriId,
      'judul': judul,
      'harga_min': hargaMin,
      'harga_max': hargaMax,
      'jam_buka': jamBuka,
      'jam_tutup': jamTutup,
      'deskripsi': deskripsi,
      'gambar': gambar,
      'lokasi': lokasi,
      'lokasi_gmaps': lokasiGmaps,
      'no_telepon': noTelepon,
      'notelp_fix': notelpFix,
      'kategori': kategori?.toJson(),
    };
  }
}

extension ProdukExt on ProdukModel {
  String get hargaLabel =>
      hargaMin == hargaMax
          ? 'Rp $hargaMin'
          : 'Rp $hargaMin - Rp $hargaMax';

  bool get isBuka => jamBuka.isNotEmpty && jamTutup.isNotEmpty;
}

