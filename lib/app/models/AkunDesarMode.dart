import 'package:desago/app/models/ProfileDesa.dart';

class AkunDesaModel {
  final int? id;
  final String? username;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ProfilDesaModel? profilDesa;

  AkunDesaModel({
    this.id,
    this.username,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.profilDesa,
  });

  factory AkunDesaModel.fromJson(Map<String, dynamic> json) {
    return AkunDesaModel(
      id: json['id'],
      username: json['username'],
      status: json['status'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      profilDesa: json['profil_desa'] != null 
          ? ProfilDesaModel.fromJson(json['profil_desa']) 
          : null,
    );
  }

  String get namaDesa => profilDesa?.namaDesa ?? 'N/A';
  String get kodeDesa => profilDesa?.kodeDesa ?? 'N/A';
  String get provinsi => profilDesa?.provinsi?.name ?? 'N/A';
  String get kabupaten => profilDesa?.kabupaten?.name ?? 'N/A';
  String get kecamatan => profilDesa?.kecamatan?.name ?? 'N/A';
}
