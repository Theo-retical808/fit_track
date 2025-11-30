# Platform Permissions Configuration

## Android Configuration

### File: `android/app/src/main/AndroidManifest.xml`

Add these permissions inside the `<manifest>` tag (before `<application>`):

```xml
<!-- Internet permission -->
<uses-permission android:name="android.permission.INTERNET"/>

<!-- Location permissions for GPS tracking -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />

<!-- Storage permissions for music library access -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

<!-- Android 13+ media permissions -->
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
```

### Complete AndroidManifest.xml Example:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <!-- Add permissions here -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
    
    <application
        android:label="fit_track"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <!-- Rest of application config -->
    </application>
</manifest>
```

## iOS Configuration

### File: `ios/Runner/Info.plist`

Add these keys inside the `<dict>` tag:

```xml
<!-- Location permissions -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to track your exercise routes and calculate distance</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location to track your exercise routes even when the app is in background</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>We need your location to track your exercise routes</string>

<!-- Music library permissions -->
<key>NSAppleMusicUsageDescription</key>
<string>We need access to your music library to play music during your workouts</string>

<key>NSMediaLibraryUsageDescription</key>
<string>We need access to your media library to play music during your workouts</string>

<key>kTCCServiceMediaLibrary</key>
<string>We need access to your music library to play music during your workouts</string>
```

### Complete Info.plist Example:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Existing keys -->
    <key>CFBundleName</key>
    <string>fit_track</string>
    
    <!-- Add permission keys here -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>We need your location to track your exercise routes and calculate distance</string>
    
    <key>NSLocationAlwaysUsageDescription</key>
    <string>We need your location to track your exercise routes even when the app is in background</string>
    
    <key>NSAppleMusicUsageDescription</key>
    <string>We need access to your music library to play music during your workouts</string>
    
    <key>NSMediaLibraryUsageDescription</key>
    <string>We need access to your media library to play music during your workouts</string>
    
    <!-- Rest of Info.plist -->
</dict>
</plist>
```

## Verification

After adding permissions, verify they're working:

1. **Location**: Start an exercise and check if GPS tracking works
2. **Music**: Go to Music tab and check if songs load
3. **Storage**: Check if exercise history persists after app restart

## Runtime Permissions

The app will automatically request permissions at runtime when needed:
- Location permission requested when starting an exercise
- Storage/Media permission requested when accessing music library

## Troubleshooting

### Android
- If location doesn't work, check Settings → Apps → Fit Track → Permissions
- For Android 13+, ensure READ_MEDIA_AUDIO is granted
- Background location requires special permission on Android 10+

### iOS
- Check Settings → Privacy → Location Services → Fit Track
- Check Settings → Privacy → Media & Apple Music → Fit Track
- Permissions must be granted before features work

## Testing Permissions

```dart
// Location permission check
final hasLocationPermission = await LocationService.checkPermission();

// Audio permission check
final hasAudioPermission = await AudioService.checkPermission();
```
