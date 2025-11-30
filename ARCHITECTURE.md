# Thenix Fitness App - Architecture Documentation

## Project Structure

```
fit_track/
├── lib/
│   ├── main.dart                    # Entry point with Provider setup
│   ├── models/                      # Data models
│   │   ├── user_profile.dart
│   │   ├── exercise_session.dart
│   │   └── track.dart
│   ├── managers/                    # Business logic & state management
│   │   ├── profile_manager.dart
│   │   ├── train_manager.dart
│   │   └── music_manager.dart
│   ├── services/                    # Device/API interactions
│   │   ├── storage_service.dart
│   │   ├── location_service.dart
│   │   └── audio_service.dart
│   ├── utils/                       # Helper functions
│   │   ├── bmi_calculator.dart
│   │   ├── distance_calculator.dart
│   │   └── constants.dart
│   ├── screens/                     # UI screens
│   │   ├── auth_screen.dart
│   │   ├── dashboard_screen.dart
│   │   ├── training_screen.dart
│   │   ├── music_screen.dart
│   │   └── profile_screen.dart
│   ├── widgets/                     # Reusable components
│   │   ├── profile_card.dart
│   │   ├── exercise_card.dart
│   │   └── music_track_tile.dart
│   ├── theme/
│   │   └── dark_theme.dart
│   └── navigation/
│       └── main_tab_navigator.dart
└── assets/
    ├── images/
    ├── audio/
    └── fonts/
```

## Data Flow

User Actions → Screen → Manager → Service → Model → Back to UI

### Examples:

1. **Profile Update:**
   - ProfileScreen.edit → ProfileManager.updateProfile() → StorageService.save() → notifyListeners() → UI rebuilds

2. **Start Exercise:**
   - TrainingScreen.startExercise → TrainManager.startExercise() → LocationService.startTracking() → Live updates → Dashboard shows data

3. **Music Playback:**
   - MusicScreen.playTrack() → MusicManager.play() → just_audio plays → Stream updates → UI shows status

## State Management

Using **Provider** with **ChangeNotifier** pattern:

- **ProfileManager**: User profile, BMI, health status
- **TrainManager**: Exercise sessions, GPS tracking, calories
- **MusicManager**: Music playback, playlist, reactive updates

## Key Features

### Profile Management
- Create/edit user profile
- BMI calculation
- Health status assessment
- Persistent storage with SharedPreferences

### Exercise Tracking
- Multiple exercise types (Running, Walking, Cycling, Swimming, Gym)
- GPS-based distance tracking using Haversine formula
- Real-time calorie calculation using MET values
- Exercise history with detailed statistics

### Music Player
- Device audio library access
- Playlist management
- Play/pause/skip controls
- Real-time playback progress

## Dependencies

- **provider**: State management
- **shared_preferences**: Local data persistence
- **hive**: Alternative storage option
- **just_audio**: Audio playback
- **on_audio_query**: Device music library access
- **geolocator**: GPS location tracking
- **flutter_vector_icons**: Icon library

## Setup Instructions

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Configure permissions in platform-specific files:

   **Android** (android/app/src/main/AndroidManifest.xml):
   ```xml
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
   ```

   **iOS** (ios/Runner/Info.plist):
   ```xml
   <key>NSLocationWhenInUseUsageDescription</key>
   <string>We need your location to track your exercise</string>
   <key>NSMicrophoneUsageDescription</key>
   <string>We need access to your music library</string>
   <key>NSAppleMusicUsageDescription</key>
   <string>We need access to your music library</string>
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Navigation Flow

```
AuthScreen (Landing)
    ↓
MainTabNavigator (BottomNavigationBar)
    ├── DashboardScreen
    ├── TrainingScreen
    ├── MusicScreen
    └── ProfileScreen
```

## Future Enhancements

- Social features (share workouts)
- Workout plans and goals
- Integration with wearables
- Cloud sync
- Advanced analytics and charts
