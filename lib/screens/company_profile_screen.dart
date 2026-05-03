import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/components.dart';

class CompanyProfileScreen extends StatelessWidget {
  final VoidCallback onBack;
  const CompanyProfileScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final double hPadding =
            constraints.maxWidth > 800 ? (constraints.maxWidth - 750) / 2 : 24;

        return CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    _buildCompanyHeader(),
                    const SizedBox(height: 48),
                    _buildTrustMetrics(),
                    const SizedBox(height: 56),
                    _buildAboutSection(),
                    const SizedBox(height: 56),
                    _buildSectionHeader('ACTIVE GIGS BY IIT MADRAS'),
                    const SizedBox(height: 24),
                    JobListCard(
                        title: 'Lab Assistant',
                        budget: '₹500',
                        emoji: '🧪',
                        college: 'IIT Madras',
                        onTap: () {}),
                    JobListCard(
                        title: 'Draft Assistant',
                        budget: '₹800',
                        emoji: '🖋️',
                        college: 'IIT Madras',
                        onTap: () {}),
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

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.white,
      floating: true,
      pinned: true,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
        onPressed: onBack,
      ),
      title: Text('COMPANY PROFILE',
          style:
              AppTextStyles.labelBold.copyWith(letterSpacing: 4, fontSize: 10)),
      centerTitle: true,
    );
  }

  Widget _buildCompanyHeader() {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Text('IITM',
                style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('IIT Madras',
                  style: AppTextStyles.displayLarge.copyWith(fontSize: 28)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 14, color: AppColors.slate),
                  const SizedBox(width: 4),
                  Text('CHENNAI, INDIA',
                      style: AppTextStyles.labelBold
                          .copyWith(fontSize: 10, color: AppColors.slate)),
                ],
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn().slideX(begin: -0.1, end: 0);
  }

  Widget _buildTrustMetrics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _metricItem('GIGS POSTED', '142'),
        _metricItem('HIRE RATE', '94%'),
        _metricItem('RATING', '4.9'),
      ],
    );
  }

  Widget _metricItem(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: AppTextStyles.labelBold
                .copyWith(fontSize: 9, color: AppColors.slate)),
        const SizedBox(height: 8),
        Text(value, style: AppTextStyles.headingMedium.copyWith(fontSize: 18)),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ABOUT', style: AppTextStyles.labelBold.copyWith(fontSize: 12)),
        const SizedBox(height: 16),
        Text(
          'IIT Madras is a leading public technical and research university located in Chennai. Our various departments often require student support for research, documentation, and creative lab work.',
          style: AppTextStyles.bodyLarge
              .copyWith(color: AppColors.charcoal, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.labelBold
          .copyWith(fontSize: 10, color: AppColors.slate),
    );
  }
}
