import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/training_screen.dart';
import '../screens/music_screen.dart';
import '../screens/profile_screen.dart';
import '../managers/profile_manager.dart';
import '../managers/train_manager.dart';
import '../widgets/profile_card.dart';
import '../widgets/exercise_card.dart';

class MainTabNavigator extends StatefulWidget {
  const MainTabNavigator({super.key});

  @override
  State<MainTabNavigator> createState() => _MainTabNavigatorState();
}

class _MainTabNavigatorState extends State<MainTabNavigator> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileManager>().loadProfile();
      context.read<TrainManager>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildDashboard(),
      const TrainingScreen(),
      const MusicScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Training',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Music',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Consumer2<ProfileManager, TrainManager>(
        builder: (context, profileManager, trainManager, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (profileManager.profile != null)
                  ProfileCard(
                    profile: profileManager.profile!,
                    bmi: profileManager.bmi,
                    healthStatus: profileManager.healthStatus,
                  )
                else
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text('Create your profile to get started'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              setState(() => _currentIndex = 3);
                            },
                            child: const Text('Create Profile'),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Text('Statistics',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildStatRow('Total Exercises',
                            trainManager.history.length.toString()),
                        _buildStatRow('Total Calories',
                            trainManager.totalCalories.toStringAsFixed(0)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (trainManager.currentSession != null) ...[
                  Text('Current Exercise',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  ExerciseCard(session: trainManager.currentSession!),
                  const SizedBox(height: 16),
                ],
                Text('Recent History',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                if (trainManager.history.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: Text('No exercise history yet')),
                    ),
                  )
                else
                  ...trainManager.history
                      .take(3)
                      .map((session) => ExerciseCard(session: session)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
