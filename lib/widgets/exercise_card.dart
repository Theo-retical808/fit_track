import 'package:flutter/material.dart';
import '../models/exercise_session.dart';

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
              Text('Distance: ${session.distance.toStringAsFixed(2)} km'),
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
      case 'Gym':
        return Icons.fitness_center;
      default:
        return Icons.sports;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
