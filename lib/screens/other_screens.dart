import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/components.dart';

// ─── CHAT SCREEN ────────────────────────────────────────────────
class ChatScreen extends StatelessWidget {
  final VoidCallback onBack;
  const ChatScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: onBack),
        title: Text('MESSAGES',
            style: AppTextStyles.labelBold.copyWith(letterSpacing: 4)),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const PandaLogo(size: 80),
                    const SizedBox(height: 32),
                    Text(
                      'INBOX EMPTY',
                      style: AppTextStyles.labelBold.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Secure encrypted messages\nwill appear here.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).animate().fadeIn(),
    );
  }
}

// ─── SETTINGS SCREEN ────────────────────────────────────────────
class SettingsScreen extends StatelessWidget {
  final VoidCallback onBack;
  const SettingsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: onBack),
        title: Text('SETTINGS',
            style: AppTextStyles.labelBold.copyWith(letterSpacing: 4)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          _settingItem('Account Information', Icons.person_outline_rounded),
          _settingItem('Privacy & Bio', Icons.shield_outlined),
          _settingItem(
              'Financial Accounts', Icons.account_balance_wallet_outlined),
          _settingItem('Notification Hub', Icons.notifications_none_rounded),
          const SizedBox(height: 60),
          AppButton(
              label: 'RELEASE SESSION',
              primary: false,
              fullWidth: true,
              onTap: () {}),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _settingItem(String label, IconData icon) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.silver),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.black),
            const SizedBox(width: 20),
            Expanded(
              child: Text(label.toUpperCase(),
                  style: AppTextStyles.labelBold
                      .copyWith(fontSize: 10, letterSpacing: 1.5)),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 18, color: AppColors.slate),
          ],
        ),
      ).animate().fadeIn().slideX(begin: 0.1, end: 0);
}

// ─── APPLICATIONS SCREEN ────────────────────────────────────────
class ApplicationsScreen extends StatelessWidget {
  final VoidCallback onBack;
  const ApplicationsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: onBack),
        title: Text('APPLICATIONS',
            style: AppTextStyles.labelBold.copyWith(letterSpacing: 4)),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.history_edu_rounded,
                        size: 64, color: AppColors.silver),
                    const SizedBox(height: 24),
                    Text(
                      'NO ACTIVE APPLICATIONS',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.labelBold
                          .copyWith(fontSize: 10, color: AppColors.slate),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
