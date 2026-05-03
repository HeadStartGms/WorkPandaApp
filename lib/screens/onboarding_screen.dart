import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onDone;
  const OnboardingScreen({super.key, required this.onDone});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _selectedStyle = 'VOLUMINOUS GIGS';

  final Map<String, Map<String, dynamic>> _styleData = {
    'VOLUMINOUS GIGS': {
      'icon': Icons.auto_awesome_outlined,
      'desc':
          'Curated student gigs for your vertical. Projects throughout your semester will lighten things up for effortless portfolio growth.',
    },
    'STREAK JOBS': {
      'icon': Icons.bolt_outlined,
      'desc':
          'Fast-paced sequential tasks. Maintain your streak to unlock high-priority campus projects and premium rewards.',
    },
    'BOUNCY PROJECTS': {
      'icon': Icons.blur_on_outlined,
      'desc':
          'Dynamic, short-term creative bursts. Perfect for students looking for quick earnings and varied experiences.',
    },
    'LONG PIXIE': {
      'icon': Icons.linear_scale_outlined,
      'desc':
          'Deep-dive internships and long-term commitments. Build solid relationships with premium campus partners.',
    },
    'SOLO RUNS': {
      'icon': Icons.person_outline,
      'desc':
          'Independent freelance gigs. Handle the entire project from start to finish on your own terms.',
    },
    'TEAM GIGS': {
      'icon': Icons.group_outlined,
      'desc':
          'Collaborative multi-student projects. Work with friends to tackle larger, more complex campus operations.',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: PageView(
        controller: _pageController,
        onPageChanged: (i) => setState(() => _currentPage = i),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildWelcomeScreen(),
          _buildChooseScreen(),
          _buildDetailScreen(),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Container(
      width: double.infinity,
      color: AppColors.black,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.white,
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Image.asset('assets/images/download.gif', width: 280),
                const SizedBox(height: 40),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(40, 60, 40, 60),
              decoration: const BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WORKPANDA',
                    style: GoogleFonts.outfit(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                      letterSpacing: -2,
                    ),
                  ),
                  Text(
                    'FOR STUDENTS',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: AppColors.white,
                      letterSpacing: 8,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'The premium marketplace for campus gigs, internships, and creative projects.',
                    style: GoogleFonts.inter(
                      color: AppColors.white.withValues(alpha: 0.5),
                      height: 1.6,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _pageController.nextPage(
                        duration: 800.ms, curve: Curves.easeInOutExpo),
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.keyboard_arrow_right,
                          size: 40, color: AppColors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChooseScreen() {
    return Container(
      color: AppColors.black,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          const Icon(Icons.grid_view_rounded, color: AppColors.white, size: 28),
          const SizedBox(height: 48),
          Text(
            'DEFINE YOUR\nWORK STYLE',
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.white,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: _styleData.keys
                  .map((style) =>
                      _buildGridCard(style, _styleData[style]!['icon']))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridCard(String title, IconData icon) {
    bool isSelected = _selectedStyle == title;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedStyle = title);
        _pageController.nextPage(duration: 600.ms, curve: Curves.easeInOutExpo);
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : AppColors.charcoal,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: isSelected ? AppColors.black : AppColors.white,
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            Center(
                child: Icon(icon,
                    size: 48,
                    color: isSelected ? AppColors.black : AppColors.white)),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailScreen() {
    final data = _styleData[_selectedStyle]!;
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Center(
                child: Image.asset('assets/images/download.gif', width: 260)),
          ),
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(40, 60, 40, 60),
              decoration: const BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedStyle,
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    data['desc'],
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.white.withValues(alpha: 0.5),
                      height: 1.8,
                    ),
                  ),
                  const Spacer(),
                  AppButton(
                    label: 'ENTER WORKPANDA',
                    fullWidth: true,
                    onTap: widget.onDone,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool fullWidth;
  const AppButton(
      {super.key,
      required this.label,
      required this.onTap,
      this.fullWidth = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 72,
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: AppColors.black,
              letterSpacing: 3,
            ),
          ),
        ),
      ),
    );
  }
}
