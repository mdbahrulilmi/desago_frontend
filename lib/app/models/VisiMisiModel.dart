class VisiMisiModel {
  final int? id;
  final String? desaId;
  final bool? isVisi;
  final String? content;

  VisiMisiModel({
    this.id,
    this.desaId,
    this.isVisi,
    this.content,
  });

  factory VisiMisiModel.fromJson(Map<String, dynamic> json) {
    return VisiMisiModel(
      id: json['id'],
      desaId: json['desa_id'],
      isVisi: json['isVisi'] == 1 || json['isVisi'] == true,
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'desa_id': desaId,
      'isVisi': isVisi == true ? 1 : 0,
      'content': content,
    };
  }
}
