# Static User Guide

## Overview

The authentication system now uses **in-memory storage** with a pre-configured static user instead of JSON files. This bypasses file system issues and allows immediate testing of the authentication feature.

## Static User Credentials

### John Doe Account
- **Username**: `john`
- **Password**: `pass123`

### John's Profile
- **Name**: John Doe
- **Age**: 21 years old
- **Weight**: 70 kg
- **Height**: 179 cm
- **Gender**: Male

## How to Use

### Login as John
1. Open the app
2. You'll see the Login screen
3. Enter:
   - Username: `john`
   - Password: `pass123`
4. Click "Login"
5. You'll be logged into the app with John's profile already set up

### Create New Users
You can still sign up with new usernames:
1. Click "Don't have an account? Sign Up"
2. Enter a new username (min 3 characters)
3. Enter a password (min 6 characters)
4. Click "Sign Up"
5. Your new account will be created in memory

## Features

### ✅ What Works
- Login with static user (john/pass123)
- Sign up new users
- Multiple user accounts
- Data isolation between users
- Profile management per user
- Exercise history per user
- Logout functionality
- Session management

### ⚠️ Limitations
- **Data is NOT persistent**: All data is lost when app closes
- **In-memory only**: No files are created
- **No cloud sync**: Data stays in app memory
- **Resets on restart**: John's profile resets to default on app restart

## Testing Scenarios

### Test 1: Login as John
```
1. Open app
2. Login: john / pass123
3. Navigate to Profile tab
4. See John Doe's profile with BMI calculated
5. Navigate to Training tab
6. Start an exercise
7. Navigate to Dashboard
8. See exercise statistics
```

### Test 2: Create New User
```
1. Open app
2. Click "Sign Up"
3. Username: testuser
4. Password: test123
5. Click "Sign Up"
6. Navigate to Profile tab
7. Create your profile
8. Start using the app
```

### Test 3: Multiple Users
```
1. Login as john / pass123
2. Create profile data
3. Logout
4. Sign up as: alice / alice123
5. Create different profile
6. Logout
7. Login as john / pass123
8. See John's data (not Alice's)
```

### Test 4: Data Isolation
```
1. Login as john
2. Start exercise (Running, 5km)
3. Logout
4. Login as different user
5. Check Training history
6. Should be empty (not showing John's exercise)
```

## Debug Features

### Debug Screen
Click the bug icon (🐛) on the login screen to see:
- Storage type: "In-Memory Storage (No files)"
- List of registered users
- Test signup functionality

### Console Output
When running the app, you'll see debug messages:
```
Static user initialized: john / pass123
Attempting login for: john
Total accounts: 1
Login successful for: john
Loaded user data for: john
```

## Architecture

### In-Memory Storage
```dart
// User accounts stored in Map
Map<String, UserAccount> _userAccounts = {
  'john': UserAccount(username: 'john', password: 'pass123', ...),
  // New users added here
};

// User data stored in Map
Map<String, UserData> _userData = {
  'john': UserData(
    username: 'john',
    profile: UserProfile(name: 'John Doe', age: 21, ...),
    exerciseHistory: [],
    musicPlaylist: [],
  ),
  // New user data added here
};
```

### Data Flow
```
Login → Check _userAccounts Map → Set current user → Load from _userData Map
```

## Advantages

### ✅ Pros
- **No file system issues**: Works on all platforms
- **Instant setup**: John's account ready immediately
- **Fast**: No file I/O operations
- **Simple**: Easy to understand and debug
- **Reliable**: No permission or path issues

### ❌ Cons
- **Not persistent**: Data lost on app close
- **Memory only**: Can't survive app restart
- **No backup**: Can't export or import data
- **Limited**: Not suitable for production

## Future Migration

When ready to implement persistent storage, you can:

### Option 1: SharedPreferences
```dart
// Save to SharedPreferences
final prefs = await SharedPreferences.getInstance();
await prefs.setString('users', jsonEncode(_userAccounts));
```

### Option 2: SQLite Database
```dart
// Use sqflite package
final db = await openDatabase('fitness.db');
await db.insert('users', user.toMap());
```

### Option 3: Cloud Backend
```dart
// Use Firebase or custom API
await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: username,
  password: password,
);
```

## Troubleshooting

### Issue: Can't login as John
**Solution**: Make sure you're using exact credentials:
- Username: `john` (lowercase)
- Password: `pass123` (no spaces)

### Issue: Data disappears
**Expected**: Data is in-memory only and resets when app closes

### Issue: Can't create new users
**Check**: 
1. Username must be at least 3 characters
2. Password must be at least 6 characters
3. Username must be unique

### Issue: Wrong profile showing
**Solution**: Make sure you logged in with correct username

## Code Reference

### Initialize Static User
```dart
// In auth_service.dart
static void _initializeStaticUser() {
  if (_userAccounts.isEmpty) {
    final johnAccount = UserAccount(
      username: 'john',
      password: 'pass123',
      userDataFile: 'user_john.json',
      createdAt: DateTime.now(),
    );
    
    final johnProfile = UserProfile(
      name: 'John Doe',
      age: 21,
      weight: 70.0,
      height: 179.0,
      gender: 'Male',
    );
    
    final johnData = UserData(
      username: 'john',
      profile: johnProfile,
      exerciseHistory: [],
      musicPlaylist: [],
    );
    
    _userAccounts['john'] = johnAccount;
    _userData['john'] = johnData;
  }
}
```

### Add More Static Users
To add more pre-configured users, modify `_initializeStaticUser()`:
```dart
// Add Jane Doe
final janeAccount = UserAccount(
  username: 'jane',
  password: 'jane123',
  userDataFile: 'user_jane.json',
  createdAt: DateTime.now(),
);

final janeProfile = UserProfile(
  name: 'Jane Doe',
  age: 25,
  weight: 60.0,
  height: 165.0,
  gender: 'Female',
);

final janeData = UserData(
  username: 'jane',
  profile: janeProfile,
  exerciseHistory: [],
  musicPlaylist: [],
);

_userAccounts['jane'] = janeAccount;
_userData['jane'] = janeData;
```

## Summary

The static user system provides a **simple, reliable way to test authentication** without dealing with file system complexities. Use **john/pass123** to login immediately, or create new users that will persist for the current app session.

---

**Quick Start**: Login with `john` / `pass123` and start using the app!
