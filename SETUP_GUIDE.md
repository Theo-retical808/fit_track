# Thenix Fitness - Quick Setup Guide

## Prerequisites
- Flutter SDK (3.10.0 or higher)
- Android Studio / Xcode for platform-specific builds
- Physical device or emulator with GPS and audio capabilities

## Installation Steps

### 1. Install Dependencies
```bash
cd fit_track
flutter pub get
```

### 2. Configure Android Permissions

Edit `android/app/src/main/AndroidManifest.xml` and add these permissions inside the `<manifest>` tag:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
```

### 3. Configure iOS Permissions

Edit `ios/Runner/Info.plist` and add these keys:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to track your exercise routes and distance</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location to track your exercise routes and distance</string>
<key>NSAppleMusicUsageDescription</key>
<string>We need access to your music library to play music during workouts</string>
<key>NSMediaLibraryUsageDescription</key>
<string>We need access to your music library to play music during workouts</string>
```

### 4. Run the App

```bash
# For Android
flutter run

# For iOS
flutter run -d ios

# For specific device
flutter devices
flutter run -d <device-id>
```

## First Time Usage

1. **Launch App**: You'll see the Auth/Landing screen with the app logo and quote
2. **Start Journey**: Tap "Start Your Journey" button
3. **Create Profile**: Navigate to Profile tab and create your profile (name, age, weight, height, gender)
4. **Start Training**: Go to Training tab, select an exercise type, set a target, and start tracking
5. **Play Music**: Go to Music tab to access your device's music library (grant permissions when prompted)

## Testing Features

### Profile Management
- Create profile with your details
- View BMI calculation and health status
- Edit profile anytime

### Exercise Tracking
- Choose from: Running, Walking, Cycling, Swimming, Gym
- Grant location permissions when prompted
- Start exercise and watch real-time tracking
- View distance, duration, and calories burned
- Finish exercise to save to history

### Music Player
- Grant audio permissions when prompted
- Browse your device's music library
- Play/pause/skip tracks
- View playback progress

## Troubleshooting

### Location Not Working
- Ensure location services are enabled on your device
- Grant location permissions to the app
- Test on a physical device (emulators may have limited GPS)

### Music Not Loading
- Grant storage/media permissions
- Ensure you have music files on your device
- On Android 13+, you may need to grant READ_MEDIA_AUDIO permission

### Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## Project Structure Overview

- **models/**: Data structures (UserProfile, ExerciseSession, Track)
- **managers/**: Business logic with ChangeNotifier (ProfileManager, TrainManager, MusicManager)
- **services/**: Device interactions (StorageService, LocationService, AudioService)
- **screens/**: UI screens (Auth, Dashboard, Training, Music, Profile)
- **widgets/**: Reusable components
- **utils/**: Helper functions (BMI calculator, distance calculator)

## Next Steps

1. Add your app logo to `assets/images/`
2. Customize colors in `lib/utils/constants.dart`
3. Add custom fonts to `assets/fonts/` and update `pubspec.yaml`
4. Test on physical devices for best GPS and audio experience
5. Customize exercise types and MET values as needed

## Support

For issues or questions, refer to:
- Flutter documentation: https://flutter.dev/docs
- Geolocator package: https://pub.dev/packages/geolocator
- Just Audio package: https://pub.dev/packages/just_audio
- Provider package: https://pub.dev/packages/provider
