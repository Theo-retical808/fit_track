import 'dart:async';
import 'package:flutter/material.dart';
import '../navigation/main_tab_navigator.dart';

class WelcomeUserScreen extends StatefulWidget {
  final String username;

  const WelcomeUserScreen({super.key, required this.username});

  @override
  State<WelcomeUserScreen> createState() => _WelcomeUserScreenState();
}

class _WelcomeUserScreenState extends State<WelcomeUserScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 25.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );

    _colorAnimation = ColorTween(
      begin: const Color(0xFF121212), // Standard dark theme background
      end: const Color.fromARGB(255, 58, 57, 70),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MainTabNavigator(),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      }
    });

    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _colorAnimation.value,
          body: child,
        );
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  alignment: Alignment.center,
                  child: child,
                );
              },
              child: const Icon(
                Icons.local_fire_department,
                size: 200,
                color: Color.fromARGB(255, 58, 57, 70),
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'Welcome, ${widget.username}!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
