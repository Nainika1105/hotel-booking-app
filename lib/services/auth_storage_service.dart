import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthStorageService {
  static const String _usersKey = 'users';
  static const String _loggedInKey = 'loggedInUser';

  static Future<void> saveUser(
      String email, String password, String name) async {
    final prefs = await SharedPreferences.getInstance();

    final usersString = prefs.getString(_usersKey);
    Map<String, dynamic> users =
        usersString != null ? jsonDecode(usersString) : {};

    users[email] = {
      'email': email,
      'password': password,
      'name': name,
    };

    await prefs.setString(_usersKey, jsonEncode(users));
  }

  static Future<Map<String, dynamic>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getString(_usersKey);
    return usersString != null ? jsonDecode(usersString) : {};
  }

  static Future<void> setLoggedInUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loggedInKey, email);
  }

  static Future<String?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_loggedInKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
  }
}
