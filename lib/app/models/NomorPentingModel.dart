class NomorPentingModel {
  final int no;
  final String subdomain;
  final String name;
  final String phone;
  final String? image;

  NomorPentingModel({
    required this.no,
    required this.subdomain,
    required this.name,
    required this.phone,
    this.image,
  });

  factory NomorPentingModel.fromJson(Map<String, dynamic> json) {
    return NomorPentingModel(
      no: json['no'],
      subdomain: json['subdomain'],
      name: json['name'],
      phone: json['phone'],
      image: json['image'],
    );
  }
}
