import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/components.dart';
import '../theme/app_theme.dart';

class AuthScreen extends StatelessWidget {
  final VoidCallback onDone;
  const AuthScreen({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // Background Image with Gradient Overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: Image.network(
                'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=2564&auto=format&fit=crop',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black.withValues(alpha: 0.2),
                    AppColors.black.withValues(alpha: 0.8),
                    AppColors.black,
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              final double hPadding =
                  constraints.maxWidth > 500 ? (constraints.maxWidth - 400) / 2 : 32;

              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Hero(
                          tag: 'logo',
                          child: PandaLogo(size: 100),
                        ),
                      ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.8, 0.8)),
                      
                      const SizedBox(height: 64),
                      
                      Text('JOIN THE\nIIT REVOLUTION', 
                        style: AppTextStyles.displayLarge.copyWith(
                          color: AppColors.white, 
                          fontSize: 36, 
                          height: 1.0,
                          letterSpacing: -1,
                        )
                      ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1, end: 0),
                      
                      const SizedBox(height: 12),
                      
                      Text('Secure campus gigs. Build your legacy.',
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.silver.withValues(alpha: 0.7))),
                      
                      const SizedBox(height: 56),
                      
                      _buildAuthInput(placeholder: 'COLLEGE EMAIL', icon: Icons.alternate_email_rounded),
                      const SizedBox(height: 20),
                      _buildAuthInput(placeholder: 'SECURE PASSWORD', icon: Icons.lock_outline_rounded, obscure: true),
                      
                      const SizedBox(height: 40),
                      
                      AppButton(
                        label: 'ENTER WORKPANDA', 
                        fullWidth: true, 
                        primary: false, // White button
                        onTap: onDone
                      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
                      
                      const SizedBox(height: 32),
                      
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text('FORGOT ACCESS CREDENTIALS?', 
                            style: AppTextStyles.labelBold.copyWith(
                              color: AppColors.silver.withValues(alpha: 0.5), 
                              fontSize: 9,
                              letterSpacing: 2,
                            )
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 64),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('NEW CADET? ', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.silver)),
                          Text('ENLIST NOW', style: AppTextStyles.labelBold.copyWith(color: AppColors.white, letterSpacing: 2)),
                        ],
                      ).animate().fadeIn(delay: 600.ms),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthInput({required String placeholder, required IconData icon, bool obscure = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
      ),
      child: TextField(
        obscureText: obscure,
        style: const TextStyle(color: AppColors.white),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: AppTextStyles.labelBold.copyWith(
            color: AppColors.silver.withValues(alpha: 0.3),
            fontSize: 10,
            letterSpacing: 2,
          ),
          icon: Icon(icon, color: AppColors.silver.withValues(alpha: 0.5), size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    ).animate().fadeIn(delay: 300.ms);
  }
}
