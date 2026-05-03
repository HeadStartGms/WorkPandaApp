import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Illustration area
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black12),
                    ),
                    child: const Center(
                      child: Text(
                        '🐼',
                        style: TextStyle(fontSize: 100),
                      ),
                    ),
                  ),
                  // Decor dots
                  Positioned(
                    top: 20,
                    right: 40,
                    child: _buildDot(20),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 20,
                    child: _buildDot(16),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              // Text Area in a dark card
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  children: [
                    Text(
                      'Find A Perfect Job Match',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Finding Your Dream Job Is Now Much Easier And Faster Like Never Before.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primary,
                      ),
                      child: const Text('Lets Get Started'),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        shape: BoxShape.circle,
      ),
    );
  }
}
