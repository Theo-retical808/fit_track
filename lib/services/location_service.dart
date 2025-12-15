import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<bool> checkPermission() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print('Location service enabled: $serviceEnabled');
      
      if (!serviceEnabled) {
        print('Location services are disabled - asking user to enable');
        // On Android, this will prompt user to enable location services
        serviceEnabled = await Geolocator.openLocationSettings();
        if (!serviceEnabled) {
          print('User did not enable location services');
          return false;
        }
      }

      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();
      print('Current permission: $permission');
      
      // Handle different permission states
      if (permission == LocationPermission.denied) {
        print('Permission denied, requesting permission...');
        permission = await Geolocator.requestPermission();
        print('Permission after request: $permission');
        
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied by user');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        // Optionally, you could open app settings here
        // await Geolocator.openAppSettings();
        return false;
      }

      if (permission == LocationPermission.whileInUse || 
          permission == LocationPermission.always) {
        print('Location permission granted: $permission');
        return true;
      }

      print('Unexpected permission state: $permission');
      return false;
    } catch (e) {
      print('Error checking location permission: $e');
      return false;
    }
  }

  static Future<Position?> getCurrentPosition() async {
    final hasPermission = await checkPermission();
    if (!hasPermission) {
      print('No location permission, cannot get position');
      return null;
    }

    try {
      print('Getting current position...');
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      print('Got position: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      print('Error getting position: $e');
      return null;
    }
  }

  static Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // meters
      ),
    );
  }
}
