import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/exercise_session.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../utils/distance_calculator.dart';
import '../utils/constants.dart';

class TrainManager extends ChangeNotifier {
  ExerciseSession? _currentSession;
  List<ExerciseSession> _history = [];
  StreamSubscription<Position>? _positionSubscription;
  Timer? _timer;
  Position? _lastPosition;

  static const String _historyKey = 'exercise_history';

  ExerciseSession? get currentSession => _currentSession;
  List<ExerciseSession> get history => _history;
  bool get isTraining => _currentSession != null;

  double get totalCalories {
    return _history.fold(0.0, (sum, session) => sum + session.caloriesBurned);
  }

  Future<void> loadHistory() async {
    final list = StorageService.getList(_historyKey);
    if (list != null) {
      _history = list.map((json) => ExerciseSession.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> startExercise(String exerciseType, double targetValue, double userWeight) async {
    final hasPermission = await LocationService.checkPermission();
    if (!hasPermission) return;

    _currentSession = ExerciseSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exerciseType: exerciseType,
      startTime: DateTime.now(),
      targetValue: targetValue,
    );

    _lastPosition = await LocationService.getCurrentPosition();

    _positionSubscription = LocationService.getPositionStream().listen((position) {
      _updatePosition(position, userWeight);
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateDuration(userWeight);
    });

    notifyListeners();
  }

  void _updatePosition(Position position, double userWeight) {
    if (_currentSession == null || _lastPosition == null) return;

    final distance = DistanceCalculator.calculateDistance(
      _lastPosition!.latitude,
      _lastPosition!.longitude,
      position.latitude,
      position.longitude,
    );

    final route = List<LocationPoint>.from(_currentSession!.route)
      ..add(LocationPoint(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
      ));

    _currentSession = _currentSession!.copyWith(
      distance: _currentSession!.distance + distance,
      route: route,
    );

    _lastPosition = position;
    notifyListeners();
  }

  void _updateDuration(double userWeight) {
    if (_currentSession == null) return;

    final duration = _currentSession!.duration + 1;
    final met = AppConstants.metValues[_currentSession!.exerciseType] ?? 5.0;
    final calories = DistanceCalculator.calculateCalories(met, userWeight, duration);

    _currentSession = _currentSession!.copyWith(
      duration: duration,
      caloriesBurned: calories,
    );

    notifyListeners();
  }

  Future<void> finishExercise() async {
    if (_currentSession == null) return;

    await _positionSubscription?.cancel();
    _timer?.cancel();

    _currentSession = _currentSession!.copyWith(endTime: DateTime.now());
    _history.insert(0, _currentSession!);

    await _saveHistory();

    _currentSession = null;
    _lastPosition = null;
    notifyListeners();
  }

  Future<void> _saveHistory() async {
    final list = _history.map((session) => session.toJson()).toList();
    await StorageService.saveList(_historyKey, list);
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }
}
