import 'package:desago/app/models/LaporKategoriModel.dart';

class LaporModel {
  final int id;
  final String desaId;
  final int kategoriId;
  final LaporKategoriModel? kategori;
  final int userId;
  final String judul;
  final String ditujukan;
  final String deskripsi;
  final String? gambar;
  final String status;
  final String tanggapan;
  final DateTime created_at;
  final DateTime updated_at;

  LaporModel({
    required this.id,
    required this.desaId,
    required this.kategoriId,
    this.kategori,
    required this.userId,
    required this.judul,
    required this.ditujukan,
    required this.deskripsi,
    this.gambar,
    required this.status,
    required this.tanggapan,
    required this.created_at,
    required this.updated_at,
  });

  factory LaporModel.fromJson(Map<String, dynamic> json) {
    return LaporModel(
      id: json['id'] ?? 0,
      desaId: json['desa_id'] ?? '',
      kategoriId: json['kategori_id'] ?? 0,
      kategori: json['kategori'] != null
          ? LaporKategoriModel.fromJson(json['kategori'])
          : null,
      userId: json['user_id'] ?? 0,
      judul: json['judul'] ?? '',
      ditujukan: json['ditujukan'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      gambar: json['gambar'],
      status: (json['status'] ?? '').toString(),
      tanggapan: (json['tanggapan'] ?? '').toString(),
      created_at:
          DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updated_at:
          DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}
