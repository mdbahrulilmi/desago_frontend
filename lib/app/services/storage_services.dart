import 'package:desago/app/models/UserModel.dart';
import 'package:get_storage/get_storage.dart';

class StorageService {
  static final _storage = GetStorage();

  // Keys
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';

  // Save token
  static Future<void> saveToken(String token) async {
    await _storage.write(_tokenKey, token);
  }

  // Get token
  static String? getToken() {
    return _storage.read(_tokenKey);
  }

  // Save user data
  static Future<void> saveUser(UserModel user) async {
    await _storage.write(_userKey, user.toJson());
  }

  // Get user data
  static UserModel? getUser() {
    final userData = _storage.read(_userKey);
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  // Save both user and token
  static Future<void> saveUserData(UserModel user, String token) async {
    await saveUser(user);
    await saveToken(token);
  }

  // Clear storage (untuk logout)
  static Future<void> clearStorage() async {
    await _storage.erase();
  }

  // Check if user is logged in
  static bool isLoggedIn() {
    return getToken() != null && getUser() != null;
  }
}