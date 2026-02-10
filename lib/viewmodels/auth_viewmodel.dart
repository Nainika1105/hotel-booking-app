import 'package:flutter/material.dart';
import '../services/auth_storage_service.dart';

class AuthViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  bool _isLoggedIn = false;

  AuthViewModel() {
    checkLoginStatus();
  }

  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkLoginStatus() async {
    final user = await AuthStorageService.getLoggedInUser();
    _isLoggedIn = user != null;
    notifyListeners();
  }

  Future<bool> signup(String name, String email, String password) async {
    isLoading = true;
    notifyListeners();

    final users = await AuthStorageService.getUsers();

    if (users.containsKey(email)) {
      error = 'User already exists';
      isLoading = false;
      notifyListeners();
      return false;
    }

    await AuthStorageService.saveUser(email, password, name);
    await AuthStorageService.setLoggedInUser(email);

    _isLoggedIn = true;
    isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    final users = await AuthStorageService.getUsers();

    if (!users.containsKey(email)) {
      error = 'User not found';
      isLoading = false;
      notifyListeners();
      return false;
    }

    if (users[email]['password'] != password) {
      error = 'Invalid password';
      isLoading = false;
      notifyListeners();
      return false;
    }

    await AuthStorageService.setLoggedInUser(email);
    _isLoggedIn = true;
    isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    await AuthStorageService.logout();
    _isLoggedIn = false;
    notifyListeners();
  }
}
