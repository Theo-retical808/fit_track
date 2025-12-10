import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../models/user_account.dart';

class AuthManager extends ChangeNotifier {
  String? _currentUsername;
  UserData? _currentUserData;
  bool _isLoading = false;

  String? get currentUsername => _currentUsername;
  UserData? get currentUserData => _currentUserData;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUsername != null;

  // Sign up
  Future<AuthResult> signUp(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return AuthResult(success: false, message: 'Username and password cannot be empty');
    }

    if (username.length < 3) {
      return AuthResult(success: false, message: 'Username must be at least 3 characters');
    }

    if (password.length < 6) {
      return AuthResult(success: false, message: 'Password must be at least 6 characters');
    }

    _isLoading = true;
    notifyListeners();

    try {
      final success = await AuthService.signUp(username, password);

      _isLoading = false;

      if (success) {
        _currentUsername = username;
        _currentUserData = await AuthService.loadUserData(username);
        notifyListeners();
        return AuthResult(success: true, message: 'Account created successfully');
      } else {
        notifyListeners();
        return AuthResult(success: false, message: 'Username already exists');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return AuthResult(success: false, message: 'Error during signup: $e');
    }
  }

  // Login
  Future<AuthResult> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return AuthResult(success: false, message: 'Username and password cannot be empty');
    }

    _isLoading = true;
    notifyListeners();

    try {
      final success = await AuthService.login(username, password);

      _isLoading = false;

      if (success) {
        _currentUsername = username;
        _currentUserData = await AuthService.loadUserData(username);
        notifyListeners();
        return AuthResult(success: true, message: 'Login successful');
      } else {
        notifyListeners();
        return AuthResult(success: false, message: 'Invalid username or password');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return AuthResult(success: false, message: 'Error during login: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    AuthService.logout();
    _currentUsername = null;
    _currentUserData = null;
    notifyListeners();
  }

  // Load user data
  Future<void> loadUserData() async {
    if (_currentUsername != null) {
      _currentUserData = await AuthService.loadUserData(_currentUsername!);
      notifyListeners();
    }
  }

  // Save user data
  Future<void> saveUserData() async {
    if (_currentUsername != null && _currentUserData != null) {
      await AuthService.saveUserData(_currentUsername!, _currentUserData!);
    }
  }

  // Update user data
  void updateUserData(UserData userData) {
    _currentUserData = userData;
    saveUserData();
    notifyListeners();
  }
}

class AuthResult {
  final bool success;
  final String message;

  AuthResult({required this.success, required this.message});
}
