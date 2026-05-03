import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  final VoidCallback onBack;
  const NotificationsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: LayoutBuilder(builder: (context, constraints) {
        final double hPadding =
            constraints.maxWidth > 800 ? (constraints.maxWidth - 700) / 2 : 24;

        return Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(hPadding, 24, hPadding, 100),
                itemCount: 8,
                separatorBuilder: (c, i) =>
                    const Divider(height: 1, color: AppColors.silver),
                itemBuilder: (c, i) => _buildNotificationItem(i),
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
      color: AppColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                onPressed: onBack,
              ),
              const SizedBox(width: 8),
              Text('NOTIFICATIONS',
                  style: AppTextStyles.labelBold.copyWith(letterSpacing: 4)),
            ],
          ),
          TextButton(
            onPressed: () {},
            child: Text('CLEAR ALL',
                style: AppTextStyles.labelBold
                    .copyWith(fontSize: 10, color: AppColors.slate)),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(int index) {
    final titles = [
      'Application Accepted',
      'New Gig: UI Design',
      'Payment Received',
      'Message from IIT Madras',
      'Deadline Reminder',
      'Profile Verified',
      'New Review Received',
      'Gig Recommendation',
    ];

    final icons = [
      Icons.check_circle_outline,
      Icons.star_outline,
      Icons.account_balance_wallet_outlined,
      Icons.chat_bubble_outline,
      Icons.timer_outlined,
      Icons.verified_user_outlined,
      Icons.rate_review_outlined,
      Icons.recommend_outlined,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: index == 0 ? AppColors.black : AppColors.offWhite,
              shape: BoxShape.circle,
            ),
            child: Icon(icons[index % icons.length],
                size: 20,
                color: index == 0 ? AppColors.white : AppColors.black),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      titles[index % titles.length],
                      style: AppTextStyles.bodyLarge
                          .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${index + 1}h ago',
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontSize: 10, color: AppColors.slate),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Your application for the "Editorial Synthesis" gig has been successfully accepted by the recruiter.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.05, end: 0);
  }
}
