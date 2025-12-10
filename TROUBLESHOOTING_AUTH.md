# Authentication Troubleshooting Guide

## Issue: "Username already exists" on every signup attempt

### Possible Causes & Solutions

#### 1. **File Permission Issues**
The app might not have permission to write to the documents directory.

**Solution:**
- On Android: Check app permissions in Settings
- On iOS: Permissions should be automatic
- Try uninstalling and reinstalling the app

#### 2. **Corrupted JSON File**
The `users_accounts.json` file might be corrupted or have invalid data.

**Solution:**
- Use the Debug Screen (bug icon on login screen) to check:
  - Storage path
  - Number of registered users
  - Test signup functionality

#### 3. **File Already Exists with Bad Data**
Previous test runs might have created a corrupted file.

**Solution:**
- Clear app data:
  - **Android**: Settings → Apps → Fit Track → Storage → Clear Data
  - **iOS**: Uninstall and reinstall the app
  - **Windows**: Delete files in `C:\Users\[USERNAME]\AppData\Roaming\com.example\fit_track\`

#### 4. **Path Provider Issue**
The `path_provider` package might not be working correctly.

**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

## Debug Steps

### Step 1: Check Debug Screen
1. Open the app
2. Click the bug icon (🐛) in the bottom right of login screen
3. Check the information displayed:
   - **Storage Path**: Should show a valid directory path
   - **Registered Users**: Should show 0 if no users exist
   - **Status**: Should show any error messages

### Step 2: Test Signup
1. In Debug Screen, click "Test Signup"
2. Check if it creates a user successfully
3. Click "Refresh" to see if the user appears in the list

### Step 3: Check Console Output
When running the app, check the console for debug messages:
```
Attempting signup for: [username]
Username exists: false
Current accounts count: 0
Saved 1 user accounts
Saved user data for: [username]
Signup successful for: [username]
```

If you see errors, they will appear in the console.

### Step 4: Manual File Check

#### Android (requires root or adb)
```bash
adb shell
run-as com.example.fit_track
cd app_flutter
ls -la
cat users_accounts.json
```

#### Windows
1. Navigate to: `C:\Users\[YOUR_USERNAME]\AppData\Roaming\com.example\fit_track\`
2. Check if `users_accounts.json` exists
3. Open it with a text editor
4. Should contain: `[]` (empty array) or valid JSON

#### iOS (requires Xcode)
1. Open Xcode
2. Window → Devices and Simulators
3. Select your device/simulator
4. Find the app container
5. Download container and check files

## Common Error Messages

### "Username already exists"
**Cause**: Either the username is taken OR there's an error reading the file

**Debug**:
1. Check Debug Screen to see actual registered users
2. Try a completely unique username like `test12345678`
3. Check console for error messages

### "Invalid username or password"
**Cause**: Either credentials are wrong OR file reading failed

**Debug**:
1. Make sure you've successfully signed up first
2. Check Debug Screen to confirm user exists
3. Try the exact username/password you used for signup

### "Error during signup: [error]"
**Cause**: File system error

**Debug**:
1. Check the specific error message
2. Verify app has storage permissions
3. Try clearing app data and starting fresh

## Quick Fixes

### Fix 1: Clear All Data
```dart
// Add this button to Debug Screen if needed
Future<void> clearAllData() async {
  final path = await AuthService.getStoragePath();
  final usersFile = File('$path/users_accounts.json');
  if (await usersFile.exists()) {
    await usersFile.delete();
  }
  // Delete all user data files
  final dir = Directory(path);
  await for (var entity in dir.list()) {
    if (entity.path.contains('user_')) {
      await entity.delete();
    }
  }
}
```

### Fix 2: Verify File Contents
Add this to Debug Screen:
```dart
Future<String> readUsersFile() async {
  try {
    final path = await AuthService.getStoragePath();
    final file = File('$path/users_accounts.json');
    if (await file.exists()) {
      return await file.readAsString();
    }
    return 'File does not exist';
  } catch (e) {
    return 'Error: $e';
  }
}
```

### Fix 3: Force Create Empty File
```dart
Future<void> initializeAuthFiles() async {
  final path = await AuthService.getStoragePath();
  final file = File('$path/users_accounts.json');
  if (!await file.exists()) {
    await file.writeAsString('[]');
  }
}
```

## Testing Procedure

### Test 1: Fresh Install
1. Uninstall app completely
2. Reinstall
3. Try signup with username: `testuser1`
4. Check Debug Screen

### Test 2: Multiple Users
1. Sign up as `user1` with password `password1`
2. Logout
3. Sign up as `user2` with password `password2`
4. Check Debug Screen shows 2 users
5. Logout
6. Login as `user1` with `password1`
7. Should work

### Test 3: Data Persistence
1. Sign up and create profile
2. Close app completely
3. Reopen app
4. Login with same credentials
5. Profile should still exist

## Platform-Specific Issues

### Android
- **Issue**: Permission denied
- **Fix**: Add to AndroidManifest.xml:
```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

### iOS
- **Issue**: File not persisting
- **Fix**: Check Info.plist has proper permissions

### Windows
- **Issue**: Path not found
- **Fix**: Ensure path_provider is working:
```dart
print(await getApplicationDocumentsDirectory());
```

## Still Not Working?

### Last Resort: Use SharedPreferences Instead

If file-based storage continues to fail, you can switch to SharedPreferences:

1. Modify `AuthService` to use SharedPreferences
2. Store users as JSON string in preferences
3. Less ideal but more reliable on some platforms

### Contact Support

If none of these solutions work:
1. Note your platform (Android/iOS/Windows)
2. Copy the console output
3. Note the storage path from Debug Screen
4. Check if the directory exists and is writable

## Prevention

### Best Practices
1. Always check Debug Screen after signup
2. Test on actual devices, not just emulators
3. Clear data between major testing sessions
4. Keep console open to see error messages
5. Test with simple usernames first (no special characters)

---

**Note**: The debug print statements will help identify exactly where the issue occurs. Check your console output carefully!
