import 'package:desago/app/models/SocialAccountModel.dart';

class UserModel {
  final String? id;
  final String? name;
  final String? username;
  final String? email;
  final String? phone;
  final String? avatar;
   final List<SocialAccountModel>? socialAccounts;

  UserModel({
    this.id,
    this.name,
    this.username,
    this.email,
    this.phone,
    this.avatar,
     this.socialAccounts,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<SocialAccountModel> socialAccounts = [];
    if (json['social_accounts'] != null) {
      socialAccounts = List<SocialAccountModel>.from(
        json['social_accounts'].map((x) => SocialAccountModel.fromJson(x)),
      );
    }
    return UserModel(
      id: json['id']?.toString(),
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      socialAccounts: socialAccounts,
    );
  }

   String? get getAvatar {
    if (avatar != null && avatar!.isNotEmpty) {
      return avatar;
    }
    else if (socialAccounts != null && socialAccounts!.isNotEmpty) {
      return socialAccounts!.first.avatar;
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'social_accounts': socialAccounts?.map((x) => x.toJson()).toList(), 
    };
  }
}