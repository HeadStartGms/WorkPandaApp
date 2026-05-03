import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/components.dart';

class HelpCenterScreen extends StatelessWidget {
  final VoidCallback onBack;
  const HelpCenterScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final double hPadding =
            constraints.maxWidth > 800 ? (constraints.maxWidth - 700) / 2 : 24;

        return Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: hPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    _buildSearchBar(),
                    const SizedBox(height: 48),
                    _buildSectionHeader('POPULAR TOPICS'),
                    const SizedBox(height: 24),
                    _buildHelpLink('Payment & Withdrawals',
                        Icons.account_balance_wallet_outlined),
                    _buildHelpLink(
                        'Gig Safety & Trust', Icons.security_outlined),
                    _buildHelpLink(
                        'Verification Issues', Icons.verified_user_outlined),
                    _buildHelpLink('Dispute Resolution', Icons.gavel_outlined),
                    const SizedBox(height: 48),
                    _buildSupportCard(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: onBack,
          ),
          const SizedBox(width: 8),
          Text('HELP CENTER',
              style: AppTextStyles.labelBold.copyWith(letterSpacing: 4)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.silver),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for help...',
                hintStyle: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.slate.withValues(alpha: 0.5)),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.labelBold
          .copyWith(fontSize: 10, color: AppColors.slate),
    );
  }

  Widget _buildHelpLink(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.black),
          const SizedBox(width: 16),
          Text(title, style: AppTextStyles.bodyLarge.copyWith(fontSize: 14)),
          const Spacer(),
          const Icon(Icons.chevron_right, size: 16, color: AppColors.slate),
        ],
      ),
    );
  }

  Widget _buildSupportCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          const Icon(Icons.headset_mic_outlined,
              color: AppColors.white, size: 32),
          const SizedBox(height: 20),
          Text(
            'STILL NEED HELP?',
            style: AppTextStyles.labelBold
                .copyWith(color: AppColors.white, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          Text(
            'Our support pandas are online 24/7.',
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.silver.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 32),
          AppButton(
            label: 'CHAT WITH US',
            fullWidth: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
