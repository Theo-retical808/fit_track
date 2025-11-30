import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class ProfileCard extends StatelessWidget {
  final UserProfile profile;
  final double bmi;
  final String healthStatus;
  final VoidCallback? onTap;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.bmi,
    required this.healthStatus,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(profile.name, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text('${profile.age} years • ${profile.gender}'),
              const SizedBox(height: 8),
              Text('Weight: ${profile.weight.toStringAsFixed(1)} kg'),
              Text('Height: ${profile.height.toStringAsFixed(0)} cm'),
              const SizedBox(height: 8),
              Text('BMI: ${bmi.toStringAsFixed(1)} ($healthStatus)',
                  style: TextStyle(
                    color: _getHealthColor(healthStatus),
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Color _getHealthColor(String status) {
    switch (status) {
      case 'Normal':
        return Colors.green;
      case 'Underweight':
        return Colors.orange;
      case 'Overweight':
        return Colors.orange;
      case 'Obese':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
