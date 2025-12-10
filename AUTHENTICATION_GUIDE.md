# Authentication System Guide

## Overview

The Thenix Fitness app now includes a complete authentication system with login and signup functionality. Each user has their own isolated data storage using JSON files.

## Features

### 1. User Authentication
- **Sign Up**: Create new user accounts with username and password
- **Login**: Authenticate existing users
- **Logout**: Securely logout and clear session
- **Session Management**: Maintain user session across app usage

### 2. Data Isolation
- Each user has a separate JSON file for their data
- User data includes:
  - Profile information (name, age, weight, height, gender)
  - Exercise history
  - Music playlist preferences
- All users' credentials are stored in a central `users_accounts.json` file

### 3. Security Features
- Password validation (minimum 6 characters)
- Username validation (minimum 3 characters)
- Password visibility toggle
- Form validation
- Secure logout with confirmation

## File Structure

### User Data Files

```
app_documents_directory/
├── users_accounts.json          # All user credentials
├── user_john.json               # John's personal data
├── user_jane.json               # Jane's personal data
└── user_mike.json               # Mike's personal data
```

### users_accounts.json Format

```json
[
  {
    "username": "john",
    "password": "password123",
    "userDataFile": "user_john.json",
    "createdAt": "2025-11-20T10:30:00.000Z"
  },
  {
    "username": "jane",
    "password": "securepass",
    "userDataFile": "user_jane.json",
    "createdAt": "2025-11-20T11:45:00.000Z"
  }
]
```

### user_[username].json Format

```json
{
  "username": "john",
  "profile": {
    "name": "John Doe",
    "age": 25,
    "weight": 75.0,
    "height": 180.0,
    "gender": "Male"
  },
  "exerciseHistory": [
    {
      "id": "1234567890",
      "exerciseType": "Running",
      "startTime": "2025-11-20T08:00:00.000Z",
      "endTime": "2025-11-20T08:30:00.000Z",
      "distance": 5.2,
      "duration": 1800,
      "caloriesBurned": 450.0,
      "targetValue": 5.0,
      "route": []
    }
  ],
  "musicPlaylist": []
}
```

## Architecture

### New Components

#### 1. Models
- **`user_account.dart`**: Defines UserAccount and UserData models
  - `UserAccount`: Stores username, password, and data file reference
  - `UserData`: Stores user's profile, exercise history, and music playlist

#### 2. Managers
- **`auth_manager.dart`**: Manages authentication state
  - Sign up functionality
  - Login functionality
  - Logout functionality
  - Current user tracking
  - Loading states

#### 3. Services
- **`auth_service.dart`**: Handles file-based authentication
  - User account management
  - JSON file operations
  - Data persistence
  - Session management

#### 4. Screens
- **`login_screen.dart`**: Login/Signup UI
  - Toggle between login and signup modes
  - Form validation
  - Password visibility toggle
  - Loading indicators
  - Error handling

## Usage Flow

### Sign Up Flow

```
1. User opens app → LoginScreen
2. User clicks "Don't have an account? Sign Up"
3. User enters username (min 3 chars) and password (min 6 chars)
4. User clicks "Sign Up"
5. AuthManager.signUp() called
6. AuthService checks if username exists
7. If available:
   - Create new UserAccount
   - Add to users_accounts.json
   - Create user_[username].json with empty data
   - Set current user session
   - Navigate to MainTabNavigator
8. If username exists:
   - Show error message
```

### Login Flow

```
1. User opens app → LoginScreen
2. User enters username and password
3. User clicks "Login"
4. AuthManager.login() called
5. AuthService validates credentials
6. If valid:
   - Load user data from user_[username].json
   - Set current user session
   - Navigate to MainTabNavigator
7. If invalid:
   - Show error message
```

### Logout Flow

```
1. User clicks logout icon in ProfileScreen
2. Confirmation dialog appears
3. User confirms logout
4. AuthManager.logout() called
5. Clear current user session
6. Navigate back to LoginScreen
```

## Integration with Existing Features

### ProfileManager
- Now loads/saves data from user-specific JSON file
- Uses `AuthService.getCurrentUserData()` to access user data
- Automatically saves changes to user's file

### TrainManager
- Exercise history stored per user
- Uses `AuthService.getCurrentUserData()` to access user data
- Each user has isolated exercise history

### MusicManager
- Music preferences can be stored per user (future enhancement)
- Currently uses device music library

## Code Examples

### Accessing Current User Data

```dart
// In any manager or service
final userData = await AuthService.getCurrentUserData();
if (userData != null) {
  // Access user's profile
  final profile = userData.profile;
  
  // Access user's exercise history
  final history = userData.exerciseHistory;
  
  // Modify and save
  userData.profile = newProfile;
  await AuthService.saveCurrentUserData(userData);
}
```

### Checking Authentication Status

```dart
// Check if user is logged in
if (AuthService.isLoggedIn()) {
  // User is authenticated
  final username = AuthService.currentUsername;
}
```

### Using AuthManager in Widgets

```dart
// Access auth state
Consumer<AuthManager>(
  builder: (context, authManager, _) {
    if (authManager.isLoading) {
      return CircularProgressIndicator();
    }
    
    if (authManager.isLoggedIn) {
      return Text('Welcome ${authManager.currentUsername}');
    }
    
    return LoginButton();
  },
)
```

## Validation Rules

### Username
- Minimum 3 characters
- Cannot be empty
- Must be unique
- Case-sensitive

### Password
- Minimum 6 characters for signup
- Cannot be empty
- No maximum length
- Stored as plain text (consider encryption for production)

## Security Considerations

### Current Implementation
⚠️ **For Development/Demo Purposes Only**

- Passwords stored in plain text
- No encryption
- Local file storage only
- No network security

### Production Recommendations

1. **Password Security**
   - Hash passwords using bcrypt or similar
   - Add salt to password hashes
   - Never store plain text passwords

2. **Data Encryption**
   - Encrypt user data files
   - Use secure storage packages
   - Implement key management

3. **Network Security**
   - Move to backend authentication (Firebase, custom API)
   - Use HTTPS for all communications
   - Implement JWT tokens
   - Add refresh token mechanism

4. **Additional Features**
   - Email verification
   - Password reset functionality
   - Two-factor authentication
   - Account recovery options
   - Session timeout
   - Biometric authentication

## File Locations

### Android
```
/data/data/com.example.fit_track/app_flutter/
├── users_accounts.json
└── user_*.json files
```

### iOS
```
/var/mobile/Containers/Data/Application/[APP_ID]/Documents/
├── users_accounts.json
└── user_*.json files
```

### Windows
```
C:\Users\[USERNAME]\AppData\Roaming\com.example\fit_track\
├── users_accounts.json
└── user_*.json files
```

## Testing

### Test Scenarios

1. **Sign Up**
   - Create new user with valid credentials
   - Try duplicate username (should fail)
   - Try short username (should fail)
   - Try short password (should fail)

2. **Login**
   - Login with valid credentials
   - Try wrong password (should fail)
   - Try non-existent username (should fail)

3. **Data Persistence**
   - Create profile
   - Logout
   - Login again
   - Verify profile data persists

4. **Multi-User**
   - Create multiple users
   - Switch between users
   - Verify data isolation

## Troubleshooting

### Issue: "Username already exists"
- **Cause**: Username is taken
- **Solution**: Choose a different username

### Issue: Data not persisting
- **Cause**: File write permissions or path issues
- **Solution**: Check app permissions, verify path_provider setup

### Issue: Cannot login after signup
- **Cause**: File system error during signup
- **Solution**: Check logs, verify file creation

### Issue: Lost user data
- **Cause**: File deleted or corrupted
- **Solution**: No recovery possible with current implementation (add backup in production)

## Future Enhancements

1. **Cloud Sync**
   - Sync data across devices
   - Backup to cloud storage
   - Real-time synchronization

2. **Social Features**
   - Friend system
   - Share workouts
   - Leaderboards

3. **Enhanced Security**
   - Password encryption
   - Biometric login
   - Session management

4. **Account Management**
   - Change password
   - Delete account
   - Export data
   - Account recovery

## API Reference

### AuthManager

```dart
class AuthManager extends ChangeNotifier {
  // Properties
  String? currentUsername
  UserData? currentUserData
  bool isLoading
  bool isLoggedIn
  
  // Methods
  Future<AuthResult> signUp(String username, String password)
  Future<AuthResult> login(String username, String password)
  Future<void> logout()
  Future<void> loadUserData()
  Future<void> saveUserData()
  void updateUserData(UserData userData)
}
```

### AuthService

```dart
class AuthService {
  // Static methods
  static Future<bool> signUp(String username, String password)
  static Future<bool> login(String username, String password)
  static void logout()
  static Future<UserData?> loadUserData(String username)
  static Future<void> saveUserData(String username, UserData userData)
  static Future<UserData?> getCurrentUserData()
  static Future<void> saveCurrentUserData(UserData userData)
  static bool isLoggedIn()
  static Future<bool> usernameExists(String username)
  static Future<bool> deleteAccount(String username, String password)
}
```

---

**Note**: This authentication system is designed for local development and testing. For production apps, implement proper backend authentication with encryption and security best practices.
