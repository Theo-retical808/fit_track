import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';
import '../utils/bmi_calculator.dart';

class ProfileManager extends ChangeNotifier {
  UserProfile? _profile;
  static const String _storageKey = 'user_profile';

  UserProfile? get profile => _profile;

  double get bmi {
    if (_profile == null) return 0.0;
    return BMICalculator.calculateBMI(_profile!.weight, _profile!.height);
  }

  String get healthStatus {
    return BMICalculator.getHealthStatus(bmi);
  }

  String get healthAdvice {
    return BMICalculator.getHealthAdvice(bmi);
  }

  Future<void> loadProfile() async {
    final json = StorageService.getJson(_storageKey);
    if (json != null) {
      _profile = UserProfile.fromJson(json);
      notifyListeners();
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    _profile = profile;
    await StorageService.saveJson(_storageKey, profile.toJson());
    notifyListeners();
  }

  Future<void> clearProfile() async {
    _profile = null;
    await StorageService.remove(_storageKey);
    notifyListeners();
  }
}
