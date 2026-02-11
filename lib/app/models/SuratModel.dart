import 'dart:convert';

class SuratModel{
  int? id;
  String desaId;
  int jenisSuratId;
  Map<String, dynamic> dataForm;
  String status;
  String? catatanAdmin;
  String? fileSurat;
  int createdBy;
  int? updatedBy;
  DateTime? createdAt;
  DateTime? verificationAt;
  DateTime? signAt;
  DateTime? completedAt;
  DateTime? rejectedAt;
  String? rejectedReason;

  SuratModel({
    this.id,
    required this.desaId,
    required this.jenisSuratId,
    required this.dataForm,
    required this.status,
    this.catatanAdmin,
    this.fileSurat,
    required this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.verificationAt,
    this.signAt,
    this.completedAt,
    this.rejectedAt,
    this.rejectedReason,
  });

  // Dari JSON (misal response API)
  factory SuratModel.fromJson(Map<String, dynamic> json) => SuratModel(
        id: json['id'],
        desaId: json['desa_id'],
        jenisSuratId: json['jenis_surat_id'],
        dataForm: json['data_form'] is String
            ? jsonDecode(json['data_form'])
            : Map<String, dynamic>.from(json['data_form']),
        status: json['status'],
        catatanAdmin: json['catatan_admin'],
        fileSurat: json['file_surat'],
        createdBy: json['created_by'],
        updatedBy: json['updated_by'],
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
        verificationAt: json['verification_at'] != null ? DateTime.parse(json['verification_at']) : null,
        signAt: json['sign_at'] != null ? DateTime.parse(json['sign_at']) : null,
        completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
        rejectedAt: json['rejected_at'] != null ? DateTime.parse(json['rejected_at']) : null,
        rejectedReason: json['rejected_reason'],
      );

  // Ke JSON (misal untuk POST/PUT API)
  Map<String, dynamic> toJson() => {
        'desa_id': desaId,
        'jenis_surat_id': jenisSuratId,
        'data_form': jsonEncode(dataForm),
        'status': status,
        'catatan_admin': catatanAdmin,
        'file_surat': fileSurat,
        'created_by': createdBy,
        'updated_by': updatedBy,
        'created_at': createdAt?.toIso8601String(),
        'verification_at': verificationAt?.toIso8601String(),
        'sign_at': signAt?.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
        'rejected_at': rejectedAt?.toIso8601String(),
        'rejected_reason': rejectedReason,
      };
}
