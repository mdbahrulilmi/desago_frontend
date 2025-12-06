class KabupatenModel {
  final int? id;
  final String? name;

  KabupatenModel({this.id, this.name});

  factory KabupatenModel.fromJson(Map<String, dynamic> json) {
    return KabupatenModel(
      id: json['id'],
      name: json['name'],
    );
  }
}