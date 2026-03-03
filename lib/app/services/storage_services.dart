import 'package:desago/app/models/UserModel.dart';
import 'package:get_storage/get_storage.dart';

class StorageService {
  static final _storage = GetStorage();

  static const String _tokenKey = 'token';
  static const String _userKey = 'user';
  static const String _verifiedKey = 'verified';

  static Future<void> saveToken(String token) async {
    await _storage.write(_tokenKey, token);
  }

  static String? getToken() {
    return _storage.read(_tokenKey);
  }

  static Future<void> saveUser(UserModel user) async {
    await _storage.write(_userKey, user.toJson());
  }

  static UserModel? getUser() {
    final userData = _storage.read(_userKey);
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  static Future<void> saveUserData(UserModel user, String token) async {
    await saveUser(user);
    await saveToken(token);
  }

  static Future<void> clearStorage() async {
    await _storage.erase();
  }

  static bool isLoggedIn() {
    return getToken() != null && getUser() != null;
  }

  static Future<void> saveVerified(String verified) async {
    await _storage.write(_verifiedKey, verified);
  }

  static String getVerified() {
    return _storage.read(_verifiedKey);
  }

  static String? getTokenSync() {
    final box = GetStorage();
    return box.read('token') as String?;
  }

}