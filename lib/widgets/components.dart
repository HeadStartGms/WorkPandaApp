import 'package:flutter/material.dart';import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ─── PREMIUM BRAND LOGO ─────────────────────────────────────────
class PandaLogo extends StatelessWidget {
  final double size;
  const PandaLogo({super.key, this.size = 50});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.05),
      child: Image.asset(
        'assets/images/panda_logo.png',
        width: size,
        fit: BoxFit.contain,
      ),
    );
  }
}

// ─── EDITORIAL BUTTON ────────────────────────────────────────────
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool primary;
  final bool fullWidth;
  final bool loading;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.primary = true,
    this.fullWidth = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
          color: primary ? AppColors.black : AppColors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: AppColors.black,
            width: 1.5,
          ),
          boxShadow: primary
              ? [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ]
              : null,
        ),
        child: Center(
          child: loading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: primary ? AppColors.white : AppColors.black,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  label.toUpperCase(),
                  style: GoogleFonts.outfit(
                    color: primary ? AppColors.white : AppColors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    letterSpacing: 2.0,
                  ),
                ),
        ),
      ),
    ).animate(target: loading ? 0 : 1).scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          curve: Curves.easeOutBack,
        );
  }
}

// ─── MINIMALIST INPUT ───────────────────────────────────────────
class AppInput extends StatelessWidget {
  final String placeholder;
  final IconData? icon;
  final bool obscure;
  final TextEditingController? controller;

  const AppInput({
    super.key,
    required this.placeholder,
    this.icon,
    this.obscure = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          placeholder.toUpperCase(),
          style: AppTextStyles.labelBold
              .copyWith(fontSize: 10, color: AppColors.slate),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.silver, width: 1.5),
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.black),
            decoration: InputDecoration(
              hintText: 'Enter your ${placeholder.toLowerCase()}',
              hintStyle: GoogleFonts.inter(
                  color: AppColors.slate.withValues(alpha: 0.3), fontSize: 16),
              prefixIcon: icon != null
                  ? Icon(icon, color: AppColors.black, size: 20)
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── MODERN NAV ────────────────────────────────────────────────
class AppBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const AppBottomNav(
      {super.key, required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(
              top: BorderSide(
                  color: AppColors.black.withValues(alpha: 0.05), width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: _navItem(0, Icons.grid_view_rounded, 'Home')),
            Expanded(child: _navItem(1, Icons.explore_outlined, 'Explore')),
            _navActionItem(2),
            Expanded(child: _navItem(3, Icons.account_balance_wallet_outlined, 'Wallet')),
            Expanded(child: _navItem(4, Icons.person_outline_rounded, 'Profile')),
          ],
        ),
      ),
    );
  }

  Widget _navItem(int i, IconData icon, String label) {
    final active = i == selectedIndex;
    return GestureDetector(
      onTap: () => onTap(i),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color:
                  active ? AppColors.black : AppColors.black.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 4),
            if (active)
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                    color: AppColors.black, shape: BoxShape.circle),
              ).animate().scale(),
          ],
        ),
      ),
    );
  }

  Widget _navActionItem(int i) {
    return GestureDetector(
      onTap: () => onTap(i),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: AppColors.black,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add_rounded, color: AppColors.white, size: 28),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
        begin: const Offset(1, 1),
        end: const Offset(1.1, 1.1),
        duration: 2.seconds,
        curve: Curves.easeInOut);
  }
}

// ─── PREMIUM GIG CARD ───────────────────────────────────────────
class JobListCard extends StatelessWidget {
  final String title;
  final String budget;
  final String emoji;
  final String college;
  final VoidCallback? onTap;

  const JobListCard({
    super.key,
    required this.title,
    required this.budget,
    required this.emoji,
    required this.college,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.black.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.02),
              blurRadius: 30,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.offWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 28))),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          AppTextStyles.headingMedium.copyWith(fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(
                    college.toUpperCase(),
                    style: AppTextStyles.labelBold
                        .copyWith(fontSize: 10, color: AppColors.slate),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(budget,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headingMedium.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: AppColors.slate),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1, end: 0);
  }
}
