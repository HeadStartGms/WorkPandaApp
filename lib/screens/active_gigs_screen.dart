import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class ActiveGigsScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSubmitTap;
  const ActiveGigsScreen(
      {super.key, required this.onBack, required this.onSubmitTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final double hPadding =
            constraints.maxWidth > 800 ? (constraints.maxWidth - 750) / 2 : 24;

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
                    _buildSectionHeader('ONGOING PROJECTS'),
                    const SizedBox(height: 24),
                    _buildActiveGigCard(
                      title: 'Editorial Synthesis',
                      client: 'IIT Madras',
                      deadline: '3 Days left',
                      progress: 0.65,
                      status: 'In Progress',
                    ),
                    const SizedBox(height: 16),
                    _buildActiveGigCard(
                      title: 'UX Research Phase 1',
                      client: 'Panda Analytics',
                      deadline: 'Tomorrow',
                      progress: 0.90,
                      status: 'Reviewing',
                    ),
                    const SizedBox(height: 48),
                    _buildSectionHeader('PAST DELIVERABLES'),
                    const SizedBox(height: 24),
                    _buildPastGigRow(
                        'Technical Documentation', 'Completed 2w ago'),
                    _buildPastGigRow('API Mockups', 'Completed 1m ago'),
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
          Text('ACTIVE GIGS',
              style: AppTextStyles.labelBold.copyWith(letterSpacing: 4)),
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

  Widget _buildActiveGigCard({
    required String title,
    required String client,
    required String deadline,
    required double progress,
    required String status,
  }) {
    return InkWell(
      onTap: onSubmitTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.black, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style:
                            AppTextStyles.headingMedium.copyWith(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(client.toUpperCase(),
                        style: AppTextStyles.labelBold
                            .copyWith(fontSize: 9, color: AppColors.slate)),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: AppTextStyles.labelBold
                        .copyWith(color: AppColors.white, fontSize: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('PROGRESS',
                    style: AppTextStyles.labelBold.copyWith(fontSize: 9)),
                Text('${(progress * 100).toInt()}%',
                    style: AppTextStyles.labelBold.copyWith(fontSize: 10)),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.silver,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.black),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.timer_outlined,
                    size: 14, color: AppColors.slate),
                const SizedBox(width: 6),
                Text(deadline,
                    style: AppTextStyles.bodyMedium
                        .copyWith(fontSize: 12, color: AppColors.slate)),
                const Spacer(),
                Text('SUBMIT WORK',
                    style: AppTextStyles.labelBold
                        .copyWith(fontSize: 10, color: AppColors.black)),
                const Icon(Icons.chevron_right, size: 16),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1, end: 0);
  }

  Widget _buildPastGigRow(String title, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: AppColors.offWhite, shape: BoxShape.circle),
            child: const Icon(Icons.check_circle_outline, size: 18),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppTextStyles.bodyLarge
                      .copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
              Text(date,
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontSize: 11, color: AppColors.slate)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_outward, size: 14, color: AppColors.slate),
        ],
      ),
    );
  }
}
