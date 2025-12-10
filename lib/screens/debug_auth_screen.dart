import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class DebugAuthScreen extends StatefulWidget {
  const DebugAuthScreen({super.key});

  @override
  State<DebugAuthScreen> createState() => _DebugAuthScreenState();
}

class _DebugAuthScreenState extends State<DebugAuthScreen> {
  String _storagePath = 'Loading...';
  List<String> _usernames = [];
  String _status = '';

  @override
  void initState() {
    super.initState();
    _loadDebugInfo();
  }

  Future<void> _loadDebugInfo() async {
    final path = AuthService.getStoragePath();
    final users = AuthService.getAllUsernames();
    setState(() {
      _storagePath = path;
      _usernames = users;
      _status = 'Loaded ${users.length} users';
    });
  }

  Future<void> _testSignup() async {
    final testUsername = 'testuser${DateTime.now().millisecondsSinceEpoch}';
    final result = await AuthService.signUp(testUsername, 'password123');
    setState(() {
      _status = result
          ? 'Test signup successful: $testUsername'
          : 'Test signup failed';
    });
    await _loadDebugInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth Debug')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Storage Path:', style: Theme.of(context).textTheme.titleLarge),
            Text(_storagePath),
            const SizedBox(height: 16),
            Text('Registered Users (${_usernames.length}):',
                style: Theme.of(context).textTheme.titleLarge),
            if (_usernames.isEmpty)
              const Text('No users registered')
            else
              ..._usernames.map((u) => Text('- $u')),
            const SizedBox(height: 16),
            Text('Status:', style: Theme.of(context).textTheme.titleLarge),
            Text(_status),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _testSignup,
              child: const Text('Test Signup'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadDebugInfo,
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
