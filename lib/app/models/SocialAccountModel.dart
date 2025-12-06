class SocialAccountModel {
  final int? id;
  final int? userId;
  final String? provider;
  final String? providerId;
  final String? providerToken;
  final String? avatar;
  final String? createdAt;
  final String? updatedAt;

  SocialAccountModel({
    this.id,
    this.userId,
    this.provider,
    this.providerId,
    this.providerToken,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  factory SocialAccountModel.fromJson(Map<String, dynamic> json) {
    return SocialAccountModel(
      id: json['id'],
      userId: json['user_id'],
      provider: json['provider'],
      providerId: json['provider_id'],
      providerToken: json['provider_token'],
      avatar: json['avatar'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'provider': provider,
      'provider_id': providerId,
      'provider_token': providerToken,
      'avatar': avatar,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}