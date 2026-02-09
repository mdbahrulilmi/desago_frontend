import 'package:desago/app/models/AgendaKategoriModel.dart';

class AgendaModel {
  final int id;
  final String desaId;
  final int kategoriId;
  final String judul;
  final DateTime tanggal;
  final String waktuMulai;
  final String waktuSelesai;
  final String lokasi;
  final AgendaKategori kategori;

  AgendaModel({
    required this.id,
    required this.desaId,
    required this.kategoriId,
    required this.judul,
    required this.tanggal,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.lokasi,
    required this.kategori,
  });

  factory AgendaModel.fromJson(Map<String, dynamic> json) {
    return AgendaModel(
      id: json['id'],
      desaId: json['desa_id'],
      kategoriId: json['kategori_id'],
      judul: json['judul'],
      tanggal: DateTime.parse(json['tanggal']),
      waktuMulai: json['waktu_mulai'],
      waktuSelesai: json['waktu_selesai'],
      lokasi: json['lokasi'],
      kategori: AgendaKategori.fromJson(json['kategori']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'desa_id': desaId,
      'kategori_id': kategoriId,
      'judul': judul,
      'tanggal': tanggal.toIso8601String().split('T').first,
      'waktu_mulai': waktuMulai,
      'waktu_selesai': waktuSelesai,
      'lokasi': lokasi,
      'kategori': kategori.toJson(),
    };
  }
}
