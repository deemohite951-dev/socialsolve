import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/auth_service.dart';
import '../auth/login_screen.dart';
import '../feed/feed_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final user = await AuthService().getSavedUser();

    if (!mounted) return;

    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const FeedScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 80, errorBuilder: (_, __, ___) => const Icon(Icons.shield, color: AppColors.accentGreen, size: 70)),
            const SizedBox(height: 20),
            const Text(
              'SOCIALSOLVE',
              style: TextStyle(color: AppColors.textLight, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            const SizedBox(height: 12),
            const CircularProgressIndicator(color: AppColors.accentGreen, strokeWidth: 2.5),
          ],
        ),
      ),
    );
  }
}