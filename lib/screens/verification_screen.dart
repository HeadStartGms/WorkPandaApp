import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/components.dart';
import '../theme/app_theme.dart';

class VerificationScreen extends StatefulWidget {
  final VoidCallback onDone;
  const VerificationScreen({super.key, required this.onDone});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool _isVerifying = false;

  void _handleVerify() async {
    setState(() => _isVerifying = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _isVerifying = false);
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: LayoutBuilder(builder: (context, constraints) {
        final double hPadding =
            constraints.maxWidth > 500 ? (constraints.maxWidth - 400) / 2 : 32;

        return Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(hPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(child: PandaLogo(size: 80)),
                const SizedBox(height: 56),
                Text('VERIFICATION', style: AppTextStyles.displayLarge),
                const SizedBox(height: 16),
                Text(
                    'A security code has been dispatched to your institutional email address.',
                    style: AppTextStyles.bodyLarge
                        .copyWith(color: AppColors.slate)),
                const SizedBox(height: 60),
                const AppInput(
                    placeholder: 'SECURE CODE',
                    icon: Icons.lock_person_outlined),
                const SizedBox(height: 48),
                AppButton(
                    label: 'VERIFY IDENTITY',
                    fullWidth: true,
                    loading: _isVerifying,
                    onTap: _handleVerify),
                const SizedBox(height: 32),
                Center(
                  child: Text('RESEND IN 45S',
                      style: AppTextStyles.labelBold
                          .copyWith(fontSize: 10, color: AppColors.slate)),
                ),
              ],
            ),
          ),
        );
      }),
    ).animate().fadeIn();
  }
}
