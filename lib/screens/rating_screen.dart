import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/components.dart';

class RatingScreen extends StatefulWidget {
  final VoidCallback onBack;
  const RatingScreen({super.key, required this.onBack});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _rating = 0;

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
                  children: [
                    const SizedBox(height: 48),
                    const PandaLogo(size: 80),
                    const SizedBox(height: 40),
                    Text(
                      'HOW WAS THE GIG?',
                      style: AppTextStyles.labelBold
                          .copyWith(fontSize: 14, letterSpacing: 4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Rate your experience with IIT Madras',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.slate),
                    ),
                    const SizedBox(height: 56),
                    _buildStars(),
                    const SizedBox(height: 64),
                    _buildCommentBox(),
                    const SizedBox(height: 64),
                    AppButton(
                      label: 'SUBMIT REVIEW',
                      fullWidth: true,
                      onTap: widget.onBack,
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
            icon: const Icon(Icons.close, size: 24),
            onPressed: widget.onBack,
          ),
          const SizedBox(width: 8),
          Text('RATE GIG',
              style: AppTextStyles.labelBold.copyWith(letterSpacing: 4)),
        ],
      ),
    );
  }

  Widget _buildStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 48,
            color: index < _rating ? AppColors.black : AppColors.silver,
          ),
          onPressed: () => setState(() => _rating = index + 1),
        );
      }),
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildCommentBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SHARE MORE DETAILS',
            style: AppTextStyles.labelBold
                .copyWith(fontSize: 10, color: AppColors.slate)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.offWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.silver),
          ),
          child: TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'What went well? Any areas for improvement?',
              hintStyle: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.slate.withValues(alpha: 0.5)),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
