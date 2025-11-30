import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'managers/profile_manager.dart';
import 'managers/train_manager.dart';
import 'managers/music_manager.dart';
import 'services/storage_service.dart';
import 'screens/auth_screen.dart';
import 'theme/dark_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const ThenixFitnessApp());
}

class ThenixFitnessApp extends StatelessWidget {
  const ThenixFitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileManager()),
        ChangeNotifierProvider(create: (_) => TrainManager()),
        ChangeNotifierProvider(create: (_) => MusicManager()),
      ],
      child: MaterialApp(
        title: 'Thenix Fitness',
        theme: darkTheme,
        home: const AuthScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
