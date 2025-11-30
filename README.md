# Thenix Fitness - Flutter Fitness Tracking App

A comprehensive fitness tracking application built with Flutter that combines exercise tracking, music playback, and health monitoring.

## Features

### 🏃 Exercise Tracking
- Multiple exercise types: Running, Walking, Cycling, Swimming, Gym
- Real-time GPS tracking with Haversine distance calculation
- Live calorie burn calculation using MET values
- Exercise history and statistics
- Target-based workouts

### 👤 Profile Management
- User profile with personal details
- Automatic BMI calculation
- Health status assessment
- Personalized health advice
- Persistent data storage

### 🎵 Music Player
- Access device music library
- Full playback controls (play, pause, skip)
- Real-time progress tracking
- Playlist management
- Background audio support

### 📊 Dashboard
- Overview of profile and health metrics
- Current exercise tracking
- Exercise history summary
- Total calories burned
- Quick access to all features

## Tech Stack

- **Framework**: Flutter 3.10.0+
- **State Management**: Provider with ChangeNotifier
- **Storage**: SharedPreferences
- **Audio**: just_audio, on_audio_query
- **Location**: geolocator
- **Architecture**: Clean Architecture with separation of concerns

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
├── managers/                 # State management
├── services/                 # Device/API services
├── screens/                  # UI screens
├── widgets/                  # Reusable components
├── utils/                    # Helper functions
├── theme/                    # App theming
└── navigation/               # Navigation logic
```

## Quick Start

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Configure permissions** (see SETUP_GUIDE.md)

3. **Run the app:**
   ```bash
   flutter run
   ```

## Documentation

- [Architecture Documentation](ARCHITECTURE.md) - Detailed architecture overview
- [Setup Guide](SETUP_GUIDE.md) - Complete setup instructions

## Screenshots

*Add screenshots here after running the app*

## Permissions Required

### Android
- Location (Fine & Coarse)
- Storage (Read & Write)
- Media Audio

### iOS
- Location When In Use
- Media Library
- Apple Music

## Dependencies

```yaml
provider: ^6.1.1
shared_preferences: ^2.2.2
hive: ^2.2.3
just_audio: ^0.9.36
on_audio_query: ^2.9.0
geolocator: ^11.0.0
flutter_vector_icons: ^2.0.0
```

## Features in Detail

### BMI Calculator
Automatically calculates Body Mass Index and provides health status:
- Underweight (BMI < 18.5)
- Normal (18.5 ≤ BMI < 25)
- Overweight (25 ≤ BMI < 30)
- Obese (BMI ≥ 30)

### Distance Calculation
Uses Haversine formula for accurate GPS-based distance tracking between coordinates.

### Calorie Calculation
Calculates calories burned using MET (Metabolic Equivalent of Task) values:
- Running: 9.8 MET
- Walking: 3.5 MET
- Cycling: 7.5 MET
- Swimming: 8.0 MET
- Gym: 5.0 MET

Formula: `Calories = MET × Weight(kg) × Time(hours)`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Support

For issues, questions, or feature requests, please open an issue on GitHub.

---

**Built with ❤️ using Flutter**
