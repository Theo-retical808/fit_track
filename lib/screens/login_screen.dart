import 'dart:async';
import 'package:fit_track/screens/welcome_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../managers/auth_manager.dart';
import '../utils/constants.dart';
import 'debug_auth_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSignUp = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final authManager = context.read<AuthManager>();
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    AuthResult result;
    if (_isSignUp) {
      result = await authManager.signUp(username, password);
    } else {
      result = await authManager.login(username, password);
    }

    if (!mounted) return;

    if (result.success) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                WelcomeUserScreen(username: username),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            }),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DebugAuthScreen()),
          );
        },
        child: const Icon(Icons.bug_report),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppConstants.primaryColor,
              AppConstants.backgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: AnimationLimiter(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 375),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: [
                        const AnimatedLoginIcon(),
                        const SizedBox(height: 24),
                        Text(
                          AppConstants.appName,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isSignUp
                              ? 'Start your fitness journey here!'
                              : 'Progress is waiting—let’s keep going!',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white70,
                                  ),
                        ),
                        const SizedBox(height: 48),
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: AnimationLimiter(
                              child: Column(
                                children:
                                    AnimationConfiguration.toStaggeredList(
                                  duration: const Duration(milliseconds: 375),
                                  childAnimationBuilder: (widget) =>
                                      SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: widget,
                                    ),
                                  ),
                                  children: [
                                    TextFormField(
                                      controller: _usernameController,
                                      decoration: InputDecoration(
                                        labelText: 'Username',
                                        prefixIcon: const Icon(Icons.person),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter username';
                                        }
                                        if (value.length < 3) {
                                          return 'Username must be at least 3 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        prefixIcon: const Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          icon: Icon(_obscurePassword
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword =
                                                  !_obscurePassword;
                                            });
                                          },
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onFieldSubmitted: (_) => _handleSubmit(),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter password';
                                        }
                                        if (_isSignUp && value.length < 6) {
                                          return 'Password must be at least 6 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    Consumer<AuthManager>(
                                      builder: (context, authManager, _) {
                                        if (authManager.isLoading) {
                                          return const CircularProgressIndicator();
                                        }
                                        return SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: _handleSubmit,
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              _isSignUp ? 'Sign Up' : 'Login',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isSignUp = !_isSignUp;
                                          _formKey.currentState?.reset();
                                        });
                                      },
                                      child: Text(
                                        _isSignUp
                                            ? 'Already have an account? Login'
                                            : "Don't have an account? Sign Up",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedLoginIcon extends StatefulWidget {
  const AnimatedLoginIcon({super.key});

  @override
  State<AnimatedLoginIcon> createState() => _AnimatedLoginIconState();
}

class _AnimatedLoginIconState extends State<AnimatedLoginIcon> {
  int _iconIndex = 0;
  final List<IconData> _icons = [
    Icons.directions_run,
    Icons.directions_walk,
    Icons.sports_gymnastics,
    Icons.fitness_center,
    Icons.directions_bike,
    Icons.pool,
    Icons.sports_mma,
    Icons.sports_volleyball
  ];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _iconIndex = (_iconIndex + 1) % _icons.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final bool isEntering = child.key == ValueKey<int>(_iconIndex);

        final fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 5.0, curve: Curves.easeIn),
          ),
        );

        final fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
          ),
        );

        final slideIn = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
          ),
        );

        if (isEntering) {
          return SlideTransition(
            position: slideIn,
            child: FadeTransition(
              opacity: fadeIn,
              child: child,
            ),
          );
        } else {
          return FadeTransition(
            opacity: fadeOut,
            child: child,
          );
        }
      },
      child: Icon(
        _icons[_iconIndex],
        key: ValueKey<int>(_iconIndex),
        size: 100,
        color: Colors.white,
      ),
    );
  }
}
