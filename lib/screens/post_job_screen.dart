import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/components.dart';
import '../theme/app_theme.dart';

class PostJobScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onPosted;
  const PostJobScreen(
      {super.key, required this.onBack, required this.onPosted});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  bool _isPosting = false;

  void _handlePost() async {
    setState(() => _isPosting = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isPosting = false);
    widget.onPosted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.close_rounded), onPressed: widget.onBack),
        title: Text('POST GIG',
            style: AppTextStyles.labelBold.copyWith(letterSpacing: 4)),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final double hPadding = constraints.maxWidth > 800
            ? (constraints.maxWidth - 600) / 2 + 24
            : 32;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CREATE A NEW\nOPPORTUNITY',
                style: AppTextStyles.displayLarge.copyWith(fontSize: 32),
              ).animate().fadeIn().slideX(begin: -0.1, end: 0),
              const SizedBox(height: 48),
              const AppInput(
                  placeholder: 'GIG TITLE', icon: Icons.title_rounded),
              const SizedBox(height: 32),
              const AppInput(
                  placeholder: 'BUDGET (₹)',
                  icon: Icons.currency_rupee_rounded),
              const SizedBox(height: 32),
              const AppInput(
                  placeholder: 'INDUSTRY', icon: Icons.category_outlined),
              const SizedBox(height: 40),
              Text('DESCRIPTION',
                  style: AppTextStyles.labelBold
                      .copyWith(fontSize: 10, color: AppColors.slate)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.offWhite,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.silver),
                ),
                child: TextField(
                  maxLines: 6,
                  style:
                      GoogleFonts.inter(fontSize: 16, color: AppColors.black),
                  decoration: InputDecoration(
                    hintText: 'Clearly outline the deliverable...',
                    hintStyle: GoogleFonts.inter(
                        color: AppColors.slate.withValues(alpha: 0.3)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Text('URGENCY',
                  style: AppTextStyles.labelBold
                      .copyWith(fontSize: 10, color: AppColors.slate)),
              const SizedBox(height: 16),
              Row(
                children: [
                  _urgencyTag('LOW', true),
                  const SizedBox(width: 12),
                  _urgencyTag('MEDIUM', false),
                  const SizedBox(width: 12),
                  _urgencyTag('PRIORITY', false),
                ],
              ),
              const SizedBox(height: 80),
              AppButton(
                label: 'LAUNCH GIG',
                fullWidth: true,
                loading: _isPosting,
                onTap: _handlePost,
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _urgencyTag(String label, bool active) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: active ? AppColors.black : AppColors.white,
          border: Border.all(color: AppColors.black, width: 1.5),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.labelBold.copyWith(
              fontSize: 10,
              color: active ? AppColors.white : AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
