# Thenix Fitness - Quick Reference Guide

## 🚀 Getting Started (3 Steps)

1. **Install Dependencies**
   ```bash
   cd fit_track
   flutter pub get
   ```

2. **Configure Permissions** (See PERMISSIONS_CONFIG.md)
   - Android: Edit `android/app/src/main/AndroidManifest.xml`
   - iOS: Edit `ios/Runner/Info.plist`

3. **Run the App**
   ```bash
   flutter run
   ```

## 📁 Project Structure at a Glance

```
lib/
├── main.dart                          # Entry point
├── models/                            # Data structures
│   ├── user_profile.dart             # User info
│   ├── exercise_session.dart         # Workout data
│   └── track.dart                    # Music track
├── managers/                          # Business logic (ChangeNotifier)
│   ├── profile_manager.dart          # Profile & BMI
│   ├── train_manager.dart            # Exercise tracking
│   └── music_manager.dart            # Music playback
├── services/                          # Device interactions
│   ├── storage_service.dart          # SharedPreferences
│   ├── location_service.dart         # GPS
│   └── audio_service.dart            # Music library
├── screens/                           # UI pages
│   ├── auth_screen.dart              # Landing page
│   ├── dashboard_screen.dart         # Overview
│   ├── training_screen.dart          # Exercise tracking
│   ├── music_screen.dart             # Music player
│   └── profile_screen.dart           # Profile management
├── widgets/                           # Reusable components
├── utils/                             # Helper functions
├── theme/                             # App styling
└── navigation/                        # Tab navigation
```

## 🔑 Key Components

### State Management (Provider)
```dart
// Access managers in widgets
Consumer<ProfileManager>(
  builder: (context, manager, _) {
    return Text(manager.profile?.name ?? 'No profile');
  },
)

// Or use context
context.read<TrainManager>().startExercise(...);
context.watch<MusicManager>().isPlaying;
```

### Data Flow
```
User Action → Screen → Manager → Service → Storage/Device
                ↓
            notifyListeners()
                ↓
            UI Updates
```

## 🎯 Core Features

### 1. Profile Management
- **Create/Edit**: ProfileScreen → ProfileManager.updateProfile()
- **BMI Calculation**: Automatic via BMICalculator
- **Storage**: SharedPreferences (persistent)

### 2. Exercise Tracking
- **Start**: TrainingScreen → TrainManager.startExercise()
- **GPS**: LocationService with Geolocator
- **Distance**: Haversine formula in DistanceCalculator
- **Calories**: MET values × weight × time

### 3. Music Player
- **Load**: MusicManager.loadPlaylist() → AudioService
- **Play**: MusicManager.play(index) → just_audio
- **Controls**: play, pause, next, previous, seek

## 📊 Data Models

### UserProfile
```dart
{
  name: String,
  age: int,
  weight: double,  // kg
  height: double,  // cm
  gender: String
}
```

### ExerciseSession
```dart
{
  id: String,
  exerciseType: String,
  startTime: DateTime,
  endTime: DateTime?,
  distance: double,     // km
  duration: int,        // seconds
  caloriesBurned: double,
  targetValue: double,
  route: List<LocationPoint>
}
```

### Track
```dart
{
  id: String,
  title: String,
  artist: String,
  albumArt: String?,
  uri: String,
  duration: int  // milliseconds
}
```

## 🎨 Customization Points

### Colors (`utils/constants.dart`)
```dart
static const Color primaryColor = Color(0xFF6C63FF);
static const Color secondaryColor = Color(0xFF03DAC6);
static const Color backgroundColor = Color(0xFF121212);
```

### Exercise Types & MET Values
```dart
static const List<String> exerciseTypes = [
  'Running', 'Walking', 'Cycling', 'Swimming', 'Gym'
];

static const Map<String, double> metValues = {
  'Running': 9.8,
  'Walking': 3.5,
  // Add more...
};
```

## 🔧 Common Tasks

### Add New Exercise Type
1. Add to `AppConstants.exerciseTypes`
2. Add MET value to `AppConstants.metValues`
3. Add icon case in `TrainingScreen._getExerciseIcon()`

### Change Theme Colors
1. Edit `utils/constants.dart`
2. Update `theme/dark_theme.dart`

### Add New Screen
1. Create in `screens/`
2. Add to `MainTabNavigator._screens`
3. Add BottomNavigationBarItem

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Location not working | Check permissions, use physical device |
| Music not loading | Grant storage permissions, ensure music files exist |
| Build errors | Run `flutter clean && flutter pub get` |
| State not updating | Ensure `notifyListeners()` is called |
| App crashes on start | Check permissions are configured |

## 📱 Testing on Device

```bash
# List devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run in release mode
flutter run --release
```

## 🔐 Required Permissions

### Android
- ACCESS_FINE_LOCATION
- ACCESS_COARSE_LOCATION
- READ_EXTERNAL_STORAGE
- READ_MEDIA_AUDIO (Android 13+)

### iOS
- NSLocationWhenInUseUsageDescription
- NSAppleMusicUsageDescription
- NSMediaLibraryUsageDescription

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| provider | State management |
| shared_preferences | Local storage |
| geolocator | GPS tracking |
| just_audio | Audio playback |
| on_audio_query | Music library access |
| flutter_vector_icons | Icons |

## 🎓 Learning Resources

- **Architecture**: See ARCHITECTURE.md
- **Setup**: See SETUP_GUIDE.md
- **Permissions**: See PERMISSIONS_CONFIG.md
- **Progress**: See IMPLEMENTATION_CHECKLIST.md

## 💡 Pro Tips

1. **Test on physical devices** for GPS and audio features
2. **Grant permissions** before testing features
3. **Use Provider.of with listen: false** for one-time reads
4. **Check battery usage** during GPS tracking
5. **Handle permission denials** gracefully in production

## 🚦 Status Indicators

- ✅ **Green**: Feature fully implemented
- 🔧 **Yellow**: Requires configuration
- ❌ **Red**: Not implemented

Current Status: ✅ Core implementation complete, 🔧 Requires platform permissions

---

**Quick Help**: For detailed information, see the respective documentation files in the project root.
