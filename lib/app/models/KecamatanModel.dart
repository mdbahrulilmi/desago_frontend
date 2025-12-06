class KecamatanModel {
  final int? id;
  final String? name;

  KecamatanModel({this.id, this.name});

  factory KecamatanModel.fromJson(Map<String, dynamic> json) {
    return KecamatanModel(
      id: json['id'],
      name: json['name'],
    );
  }
}