class ProvinsiModel {
  final int? id;
  final String? name;

  ProvinsiModel({this.id, this.name});

  factory ProvinsiModel.fromJson(Map<String, dynamic> json) {
    return ProvinsiModel(
      id: json['id'],
      name: json['name'],
    );
  }
}