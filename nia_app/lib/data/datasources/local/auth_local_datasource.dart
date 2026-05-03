import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/user_model.dart';

class AuthLocalDataSource {
  final SharedPreferences prefs;
  const AuthLocalDataSource(this.prefs);

  Future<void> cacheUser(UserModel user) async {
    await prefs.setString(AppConstants.keyUserId, user.id);
    await prefs.setString(AppConstants.keyUserEmail, user.email);
    await prefs.setString(AppConstants.keyUserName, user.name);
    await prefs.setString(AppConstants.keyUserPhone, user.phone);
    await prefs.setString(AppConstants.keyAuthToken, user.token);
    await prefs.setBool(AppConstants.keyIsLoggedIn, true);
  }

  Future<UserModel?> getCachedUser() async {
    final isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
    if (!isLoggedIn) return null;
    final id = prefs.getString(AppConstants.keyUserId);
    final email = prefs.getString(AppConstants.keyUserEmail);
    final name = prefs.getString(AppConstants.keyUserName);
    final phone = prefs.getString(AppConstants.keyUserPhone);
    final token = prefs.getString(AppConstants.keyAuthToken);
    if (id == null || email == null) return null;
    return UserModel(
      id: id,
      email: email,
      name: name ?? '',
      phone: phone ?? '',
      token: token ?? '',
    );
  }

  Future<void> clearSession() async {
    await prefs.remove(AppConstants.keyUserId);
    await prefs.remove(AppConstants.keyUserEmail);
    await prefs.remove(AppConstants.keyUserName);
    await prefs.remove(AppConstants.keyUserPhone);
    await prefs.remove(AppConstants.keyAuthToken);
    await prefs.setBool(AppConstants.keyIsLoggedIn, false);
  }

  Future<bool> isLoggedIn() async {
    return prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }

  // Stores registered users as a list of JSON strings keyed by email
  Future<Map<String, dynamic>?> getRegisteredUser(String email) async {
    final raw = prefs.getString('user_$email');
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> saveRegisteredUser(Map<String, dynamic> userData) async {
    final email = userData['email'] as String;
    await prefs.setString('user_$email', jsonEncode(userData));
  }

  Future<bool> emailExists(String email) async {
    return prefs.containsKey('user_$email');
  }
}
