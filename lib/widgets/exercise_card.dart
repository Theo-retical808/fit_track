import 'package:flutter/material.dart';
import '../models/exercise_session.dart';
import '../utils/constants.dart';

class ExerciseCard extends StatelessWidget {
  final ExerciseSession session;
  final VoidCallback? onTap;

  const ExerciseCard({
    super.key,
    required this.session,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final duration = Duration(seconds: session.duration);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    final isDistanceExercise = AppConstants.isDistanceExercise(session.exerciseType);

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(session.exerciseType,
                      style: Theme.of(context).textTheme.headlineMedium),
                  Icon(_getExerciseIcon(session.exerciseType)),
                ],
              ),
              const SizedBox(height: 8),
              Text('Duration: ${minutes}m ${seconds}s'),
              if (isDistanceExercise) ...[
                Text('Distance: ${session.distance.toStringAsFixed(2)} km'),
                Text('Target: ${session.targetValue.toStringAsFixed(1)} km'),
              ] else ...[
                Text('Repetitions: ${session.repetitions}'),
                Text('Target: ${session.targetValue.toStringAsFixed(0)} reps'),
              ],
              Text('Calories: ${session.caloriesBurned.toStringAsFixed(0)} kcal'),
              Text('Date: ${_formatDate(session.startTime)}'),
            ],
          ),
        ),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
