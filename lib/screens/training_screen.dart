import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../managers/train_manager.dart';
import '../managers/profile_manager.dart';
import '../utils/constants.dart';
import '../widgets/exercise_card.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Training')),
      body: Consumer2<TrainManager, ProfileManager>(
        builder: (context, trainManager, profileManager, _) {
          if (trainManager.isTraining) {
            return _buildActiveSession(context, trainManager);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Start Exercise', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                ...AppConstants.exerciseTypes.map((type) => Card(
                      child: ListTile(
                        leading: Icon(_getExerciseIcon(type)),
                        title: Text(type),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () => _showStartDialog(context, type, trainManager, profileManager),
                      ),
                    )),
                const SizedBox(height: 24),
                Text('History', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                if (trainManager.history.isEmpty)
                  const Center(child: Text('No exercise history'))
                else
                  ...trainManager.history.map((session) => ExerciseCard(session: session)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActiveSession(BuildContext context, TrainManager manager) {
    final session = manager.currentSession!;
    final duration = Duration(seconds: session.duration);
    final isDistanceExercise = AppConstants.isDistanceExercise(session.exerciseType);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(session.exerciseType, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 32),
          
          // Timer display
          Text('${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          
          // Different stats based on exercise type
          if (isDistanceExercise) ...[
            _buildStat('Distance', '${session.distance.toStringAsFixed(2)} km'),
            _buildStat('Target', '${session.targetValue.toStringAsFixed(1)} km'),
          ] else ...[
            // Repetition counter for time-based exercises
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConstants.surfaceColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text('Repetitions', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => manager.removeRepetition(),
                        icon: const Icon(Icons.remove_circle, size: 40),
                        color: Colors.red,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        '${session.repetitions}',
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () => manager.addRepetition(),
                        icon: const Icon(Icons.add_circle, size: 40),
                        color: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildStat('Target', '${session.targetValue.toStringAsFixed(0)} reps'),
          ],
          
          const SizedBox(height: 16),
          _buildStat('Calories', '${session.caloriesBurned.toStringAsFixed(0)} kcal'),
          const SizedBox(height: 32),
          
          ElevatedButton(
            onPressed: () => manager.finishExercise(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Finish Exercise'),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showStartDialog(BuildContext context, String type, TrainManager trainManager,
      ProfileManager profileManager) {
    final controller = TextEditingController();
    final isDistanceExercise = AppConstants.isDistanceExercise(type);
    
    final targetLabel = isDistanceExercise ? 'Target Distance (km)' : 'Target Repetitions';
    final targetHint = isDistanceExercise ? 'e.g., 5.0' : 'e.g., 20';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start $type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isDistanceExercise)
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'This is a time-based exercise. You can track repetitions during the workout.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: targetLabel,
                hintText: targetHint,
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final target = double.tryParse(controller.text) ?? 0.0;
              final weight = profileManager.profile?.weight ?? 70.0;
              
              Navigator.pop(context);
              
              final success = await trainManager.startExercise(type, target, weight);
              if (!success && context.mounted) {
                if (isDistanceExercise) {
                  _showLocationPermissionDialog(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to start exercise. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  void _showLocationPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This exercise requires GPS tracking to measure distance.'),
            SizedBox(height: 16),
            Text('To enable location access:'),
            SizedBox(height: 8),
            Text('1. Go to your phone Settings'),
            Text('2. Find "Apps" or "Application Manager"'),
            Text('3. Find "fit_track" app'),
            Text('4. Tap "Permissions"'),
            Text('5. Enable "Location" permission'),
            SizedBox(height: 16),
            Text('Or try starting the exercise again to get the permission prompt.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              // Try to open app settings
              try {
                await Geolocator.openAppSettings();
              } catch (e) {
                print('Could not open app settings: $e');
              }
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  IconData _getExerciseIcon(String type) {
    switch (type) {
      case 'Running':
        return Icons.directions_run;
      case 'Walking':
        return Icons.directions_walk;
      case 'Cycling':
        return Icons.directions_bike;
      case 'Swimming':
        return Icons.pool;
      case 'Push Ups':
        return Icons.fitness_center;
      case 'Curl Ups':
        return Icons.self_improvement;
      case 'Pull Ups':
        return Icons.sports_gymnastics;
      case 'Squats':
        return Icons.accessibility_new;
      case 'Planks':
        return Icons.timer;
      default:
        return Icons.sports;
    }
  }
}
