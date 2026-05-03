import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/components.dart';

class JobDetailScreen extends StatefulWidget {
  final String title;
  final String budget;
  final String emoji;
  final String college;
  final VoidCallback onBack;
  final VoidCallback onCompanyTap;

  const JobDetailScreen({
    super.key,
    required this.title,
    required this.budget,
    required this.emoji,
    required this.college,
    required this.onBack,
    required this.onCompanyTap,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool _isApplying = false;

  void _handleApply() async {
    setState(() => _isApplying = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _isApplying = false);
    
    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('APPLICATION SENT TO ${widget.college}', 
          style: AppTextStyles.labelBold.copyWith(color: AppColors.white, fontSize: 10)),
        backgroundColor: AppColors.black,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverHeader(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleSection(),
                      const SizedBox(height: 48),
                      _buildDescriptionSection(),
                      const SizedBox(height: 48),
                      _buildRequirementsSection(),
                      const SizedBox(height: 48),
                      _buildCollegeInfo(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildActionPanel(),
        ],
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 400,
      backgroundColor: AppColors.black,
      automaticallyImplyLeading: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=2564&auto=format&fit=crop',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    AppColors.white.withValues(alpha: 0.8),
                    AppColors.white,
                  ],
                  stops: const [0.0, 0.4, 0.9, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 24,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                    )
                  ],
                ),
                child: Text(widget.emoji, style: const TextStyle(fontSize: 40)),
              ).animate().scale(delay: 200.ms, duration: 600.ms, curve: Curves.easeOutBack),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.title.toUpperCase(),
                style: AppTextStyles.displayLarge.copyWith(
                  fontSize: 32,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                widget.budget,
                style: AppTextStyles.labelBold.copyWith(
                  color: AppColors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.location_on_outlined, size: 14, color: AppColors.slate),
            const SizedBox(width: 4),
            Text(
              widget.college.toUpperCase(),
              style: AppTextStyles.labelBold.copyWith(
                fontSize: 10,
                color: AppColors.slate,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.access_time, size: 14, color: AppColors.slate),
            const SizedBox(width: 4),
            Text(
              '2 DAYS AGO',
              style: AppTextStyles.labelBold.copyWith(
                fontSize: 10,
                color: AppColors.slate,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('DESCRIPTION', style: AppTextStyles.labelBold.copyWith(fontSize: 10, color: AppColors.slate, letterSpacing: 3)),
        const SizedBox(height: 16),
        Text(
          'We are looking for a dedicated student to assist with research and editorial synthesis for our upcoming journal publication. You will be responsible for summarizing findings, organizing citations, and ensuring the editorial flow matches academic standards.',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.charcoal,
            height: 1.8,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildRequirementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('REQUIREMENTS', style: AppTextStyles.labelBold.copyWith(fontSize: 10, color: AppColors.slate, letterSpacing: 3)),
        const SizedBox(height: 24),
        _buildRequirementItem('Strong command over English literature'),
        _buildRequirementItem('Previous experience in academic writing'),
        _buildRequirementItem('Ability to work 10 hours per week'),
        _buildRequirementItem('Currently enrolled at a recognized institution'),
      ],
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: AppColors.black),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.charcoal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollegeInfo() {
    return GestureDetector(
      onTap: widget.onCompanyTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.silver.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('IITM',
                    style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.college,
                      style: AppTextStyles.headingMedium.copyWith(fontSize: 16)),
                  Text('Verified Educational Institution',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.slate, fontSize: 10)),
                ],
              ),
            ),
            const Icon(Icons.verified, color: Colors.blue, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionPanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.8),
              border: Border(top: BorderSide(color: AppColors.black.withValues(alpha: 0.05))),
            ),
            child: AppButton(
              label: 'APPLY FOR THIS GIG',
              fullWidth: true,
              loading: _isApplying,
              onTap: _handleApply,
            ),
          ),
        ),
      ),
    );
  }
}
