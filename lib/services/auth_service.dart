import '../models/user_account.dart';
import '../models/user_profile.dart';

class AuthService {
  static String? _currentUsername;

  // In-memory storage for users (replaces JSON files)
  static final Map<String, UserAccount> _userAccounts = {};
  static final Map<String, UserData> _userData = {};

  static String? get currentUsername => _currentUsername;

  // Initialize with static user
  static void _initializeStaticUser() {
    if (_userAccounts.isEmpty) {
      // Create John Doe account
      final johnAccount = UserAccount(
        username: 'john',
        password: 'pass123',
        userDataFile: 'user_john.json',
        createdAt: DateTime.now(),
      );

      // Create John's profile
      final johnProfile = UserProfile(
        name: 'John Doe',
        age: 21,
        weight: 70.0,
        height: 179.0,
        gender: 'Male',
      );

      // Create John's user data
      final johnData = UserData(
        username: 'john',
        profile: johnProfile,
        exerciseHistory: [],
        musicPlaylist: [],
      );

      _userAccounts['john'] = johnAccount;
      _userData['john'] = johnData;

      print('Static user initialized: john / pass123');
    }
  }

  // Check if username exists
  static bool usernameExists(String username) {
    _initializeStaticUser();
    return _userAccounts.containsKey(username);
  }

  // Sign up new user
  static Future<bool> signUp(String username, String password) async {
    try {
      _initializeStaticUser();
      print('Attempting signup for: $username');

      // Check if username already exists
      final exists = usernameExists(username);
      print('Username exists: $exists');

      if (exists) {
        return false;
      }

      // Create new user account
      final newAccount = UserAccount(
        username: username,
        password: password,
        userDataFile: 'user_$username.json',
        createdAt: DateTime.now(),
      );

      // Create empty user data
      final userData = UserData(username: username);

      // Save to memory
      _userAccounts[username] = newAccount;
      _userData[username] = userData;

      // Set current user
      _currentUsername = username;

      print('Signup successful for: $username');
      print('Total users: ${_userAccounts.length}');
      return true;
    } catch (e) {
      print('Signup error: $e');
      return false;
    }
  }

  // Login user
  static Future<bool> login(String username, String password) async {
    try {
      _initializeStaticUser();
      print('Attempting login for: $username');
      print('Total accounts: ${_userAccounts.length}');

      if (!_userAccounts.containsKey(username)) {
        print('Username not found: $username');
        return false;
      }

      final account = _userAccounts[username]!;
      if (account.password != password) {
        print('Invalid password for: $username');
        return false;
      }

      _currentUsername = username;
      print('Login successful for: $username');
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Logout user
  static void logout() {
    _currentUsername = null;
  }

  // Load user data
  static Future<UserData?> loadUserData(String username) async {
    _initializeStaticUser();
    if (_userData.containsKey(username)) {
      print('Loaded user data for: $username');
      return _userData[username];
    }
    print('No user data found for: $username');
    return UserData(username: username);
  }

  // Save user data
  static Future<void> saveUserData(String username, UserData userData) async {
    _userData[username] = userData;
    print('Saved user data for: $username');
  }

  // Get current user data
  static Future<UserData?> getCurrentUserData() async {
    if (_currentUsername == null) return null;
    return await loadUserData(_currentUsername!);
  }

  // Save current user data
  static Future<void> saveCurrentUserData(UserData userData) async {
    if (_currentUsername == null) return;
    await saveUserData(_currentUsername!, userData);
  }

  // Check if user is logged in
  static bool isLoggedIn() {
    return _currentUsername != null;
  }

  // Debug method to get storage info
  static String getStoragePath() {
    return 'In-Memory Storage (No files)';
  }

  // Debug method to list all users
  static List<String> getAllUsernames() {
    _initializeStaticUser();
    return _userAccounts.keys.toList();
  }

  // Delete user account (optional)
  static Future<bool> deleteAccount(String username, String password) async {
    try {
      if (!_userAccounts.containsKey(username)) return false;

      final account = _userAccounts[username]!;
      if (account.password != password) return false;

      // Remove from memory
      _userAccounts.remove(username);
      _userData.remove(username);

      if (_currentUsername == username) {
        logout();
      }

      print('Deleted account: $username');
      return true;
    } catch (e) {
      print('Error deleting account: $e');
      return false;
    }
  }
}
