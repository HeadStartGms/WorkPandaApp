import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/components.dart';

class PortfolioBuilderScreen extends StatelessWidget {
  final VoidCallback onBack;
  const PortfolioBuilderScreen({super.key, required this.onBack});

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
                    _buildSyncSection(),
                    const SizedBox(height: 48),
                    _buildSectionHeader('HIGHLIGHTED SKILLS'),
                    const SizedBox(height: 24),
                    _buildSkillItem('UI/UX Design', '5 Completed Gigs'),
                    _buildSkillItem('Technical Writing', '3 Completed Gigs'),
                    _buildSkillItem('Data Analysis', '1 Completed Gig'),
                    const SizedBox(height: 48),
                    _buildSectionHeader('EXTERNAL LINKS'),
                    const SizedBox(height: 24),
                    _buildLinkRow('GITHUB', 'github.com/panda-dev'),
                    _buildLinkRow('BEHANCE', 'behance.net/panda-design'),
                    _buildLinkRow('LINKEDIN', 'linkedin.com/in/panda-student'),
                    const SizedBox(height: 64),
                    AppButton(
                      label: 'UPDATE PORTFOLIO',
                      fullWidth: true,
                      onTap: onBack,
                    ),
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
          Text('PORTFOLIO BUILDER',
              style: AppTextStyles.labelBold.copyWith(letterSpacing: 4)),
        ],
      ),
    );
  }

  Widget _buildSyncSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome, color: AppColors.white, size: 32),
          const SizedBox(height: 24),
          Text(
            'Smart Sync Portfolio',
            style: AppTextStyles.headingMedium.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Automatically generate a professional portfolio based on your completed WorkPanda gigs.',
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.silver.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text('ACTIVATE SYNC',
                style: AppTextStyles.labelBold.copyWith(fontSize: 10)),
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.labelBold
          .copyWith(fontSize: 10, color: AppColors.slate),
    );
  }

  Widget _buildSkillItem(String title, String count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
                color: AppColors.offWhite, shape: BoxShape.circle),
            child: const Icon(Icons.bolt, size: 18),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppTextStyles.bodyLarge
                      .copyWith(fontWeight: FontWeight.bold)),
              Text(count,
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontSize: 11, color: AppColors.slate)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.edit_outlined, size: 16, color: AppColors.slate),
        ],
      ),
    );
  }

  Widget _buildLinkRow(String platform, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(platform, style: AppTextStyles.labelBold.copyWith(fontSize: 10)),
          Text(url,
              style: AppTextStyles.bodyMedium
                  .copyWith(fontSize: 12, color: AppColors.slate)),
        ],
      ),
    );
  }
}
