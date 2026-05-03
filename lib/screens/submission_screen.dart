import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/components.dart';

class SubmissionScreen extends StatefulWidget {
  final VoidCallback onBack;
  const SubmissionScreen({super.key, required this.onBack});

  @override
  State<SubmissionScreen> createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends State<SubmissionScreen> {
  bool _isSubmitting = false;

  void _handleSubmit() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    widget.onBack();
  }

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
                    _buildProjectSummary(),
                    const SizedBox(height: 48),
                    _buildUploadZone(),
                    const SizedBox(height: 40),
                    _buildNotesSection(),
                    const SizedBox(height: 56),
                    AppButton(
                      label: 'SUBMIT DELIVERABLES',
                      fullWidth: true,
                      loading: _isSubmitting,
                      onTap: _handleSubmit,
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
          Text('SUBMIT WORK',
              style: AppTextStyles.labelBold.copyWith(letterSpacing: 4)),
        ],
      ),
    );
  }

  Widget _buildProjectSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PROJECT',
            style: AppTextStyles.labelBold
                .copyWith(fontSize: 10, color: AppColors.slate)),
        const SizedBox(height: 8),
        Text('Editorial Synthesis for Research',
            style: AppTextStyles.headingLarge.copyWith(fontSize: 22)),
        const SizedBox(height: 4),
        Text('DUE IN 3 DAYS',
            style: AppTextStyles.labelBold
                .copyWith(fontSize: 10, color: Colors.orange)),
      ],
    );
  }

  Widget _buildUploadZone() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 64),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
            color: AppColors.black, style: BorderStyle.solid, width: 1.5),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_upload_outlined,
              size: 48, color: AppColors.black),
          const SizedBox(height: 16),
          Text('TAP TO UPLOAD FILES',
              style: AppTextStyles.labelBold.copyWith(fontSize: 11)),
          const SizedBox(height: 8),
          Text('PDF, DOCX, ZIP (MAX 50MB)',
              style: AppTextStyles.bodyMedium
                  .copyWith(fontSize: 10, color: AppColors.slate)),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.98, 0.98));
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('NOTES FOR RECRUITER',
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
              hintText: 'Describe your submission...',
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
