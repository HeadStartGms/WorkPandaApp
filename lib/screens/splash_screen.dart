import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/panda_loader.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onDone;
  const SplashScreen({super.key, required this.onDone});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), widget.onDone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PandaLoader(size: 160),
            const SizedBox(height: 80),
            Text(
              'WORKPANDA',
              style: AppTextStyles.labelBold.copyWith(
                fontSize: 24,
                letterSpacing: 12,
              ),
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 16),
            Container(
              height: 1,
              width: 40,
              color: AppColors.black.withValues(alpha: 0.1),
            ).animate().scaleX(delay: 800.ms),
            const SizedBox(height: 16),
            Text(
              'THE STUDENT GIG ECONOMY',
              style: AppTextStyles.labelBold.copyWith(
                fontSize: 9,
                color: AppColors.slate,
                letterSpacing: 3,
              ),
            ).animate().fadeIn(delay: 1.seconds),
          ],
        ),
      ),
    );
  }
}
