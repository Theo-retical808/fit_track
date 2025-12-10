import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../utils/bmi_calculator.dart';

class ProfileManager extends ChangeNotifier {
  UserProfile? _profile;

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
    final userData = await AuthService.getCurrentUserData();
    if (userData != null) {
      _profile = userData.profile;
      notifyListeners();
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    _profile = profile;
    final userData = await AuthService.getCurrentUserData();
    if (userData != null) {
      userData.profile = profile;
      await AuthService.saveCurrentUserData(userData);
    }
    notifyListeners();
  }

  Future<void> clearProfile() async {
    _profile = null;
    notifyListeners();
  }
}
