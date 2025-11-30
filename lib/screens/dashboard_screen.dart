// This file is kept for backward compatibility
// The dashboard functionality is now integrated into MainTabNavigator
// You can delete this file if not needed elsewhere

import 'package:flutter/material.dart';
import '../navigation/main_tab_navigator.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainTabNavigator();
  }
}
