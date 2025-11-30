import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(session.exerciseType, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 32),
          Text('${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          _buildStat('Distance', '${session.distance.toStringAsFixed(2)} km'),
          _buildStat('Calories', '${session.caloriesBurned.toStringAsFixed(0)} kcal'),
          _buildStat('Target', session.targetValue.toStringAsFixed(1)),
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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start $type'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Target (km/min)'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final target = double.tryParse(controller.text) ?? 0.0;
              final weight = profileManager.profile?.weight ?? 70.0;
              trainManager.startExercise(type, target, weight);
              Navigator.pop(context);
            },
            child: const Text('Start'),
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
      case 'Gym':
        return Icons.fitness_center;
      default:
        return Icons.sports;
    }
  }
}
