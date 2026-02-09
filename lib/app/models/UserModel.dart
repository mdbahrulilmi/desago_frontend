import 'package:desago/app/models/OAuthAccountsModel.dart';

class UserModel {
  final String? id;
  final String? username;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? verified;
   final List<OAuthAccountsModel>? oAuthAccounts;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.phone,
    this.avatar,
    this.verified,
    this.oAuthAccounts,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<OAuthAccountsModel> oAuthAccounts = [];
    if (json['oauth_accounts'] != null) {
      oAuthAccounts = List<OAuthAccountsModel>.from(
        json['oauth_accounts'].map((x) => OAuthAccountsModel.fromJson(x)),
      );
    }
    return UserModel(
      id: json['id']?.toString(),
      username: json['username'],
      email: json['email'],
      phone: json['no_telepon'],
      avatar: json['avatar'],
      verified: json['verified'],
      oAuthAccounts: oAuthAccounts,
    );
  }

   String? get getAvatar {
    if (avatar != null && avatar!.isNotEmpty) {
      return avatar;
    }
    else if (oAuthAccounts != null && oAuthAccounts!.isNotEmpty) {
      return oAuthAccounts!.first.avatar;
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'no_telepon': phone,
      'avatar': avatar,
      'verified': verified,
      'oauth_accounts': oAuthAccounts?.map((x) => x.toJson()).toList(), 
    };
  }

  UserModel copyWith({
    String? email,
    String? phone,
    String? username,
    String? avatar,
    String? verified
  }) {
    return UserModel(
      email: email ?? this.email,
      phone: phone ?? this.phone,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      verified: verified ?? this.verified,
    );
  }
}