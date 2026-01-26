class LaporModel {
  final int no;
  final String subdomain;
  final String ditujukan;
  final String title;
  final String? image;
  final int category;
  final String description;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  LaporModel({
    required this.no,
    required this.subdomain,
    required this.ditujukan,
    required this.title,
    this.image,
    required this.category,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LaporModel.fromJson(Map<String, dynamic> json) {
    return LaporModel(
      no: json['no'],
      subdomain: json['subdomain'],
      ditujukan: json['ditujukan'],
      title: json['title'],
      image: json['image'],
      category: json['category'],
      description: json['description'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
