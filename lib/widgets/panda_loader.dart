import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class PandaLoader extends StatefulWidget {
  final double size;
  const PandaLoader({super.key, this.size = 120});

  @override
  State<PandaLoader> createState() => _PandaLoaderState();
}

class _PandaLoaderState extends State<PandaLoader>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;

  final List<CardContent> _contents = [
    CardContent(icon: Icons.auto_awesome_rounded, label: "Premium"),
    CardContent(icon: Icons.bolt_rounded, label: "Speed"),
    CardContent(icon: Icons.verified_user_outlined, label: "Trusted"),
    CardContent(icon: Icons.grid_view_rounded, label: "Variety"),
    CardContent(icon: Icons.style_outlined, label: "Editorial"),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _controller.addListener(() {
      final newIndex =
          (_controller.value * _contents.length).floor() % _contents.length;
      if (newIndex != _currentIndex) {
        setState(() {
          _currentIndex = newIndex;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background stacking effect
          for (int i = 2; i > 0; i--)
            Transform.translate(
              offset: Offset(0, i * 6.0),
              child: Transform.scale(
                scale: 1.0 - (i * 0.08),
                child: _buildCard(null, i),
              ),
            ),

          // Main Flipping Card
          _buildFlippingCard(),
        ],
      )
          .animate(onPlay: (controller) => controller.repeat())
          .moveY(
              begin: 0,
              end: -12,
              duration: 1500.ms,
              curve: Curves.easeInOutSine)
          .then()
          .moveY(
              begin: -12,
              end: 0,
              duration: 1500.ms,
              curve: Curves.easeInOutSine),
    );
  }

  Widget _buildFlippingCard() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double progress = (_controller.value * _contents.length) % 1.0;
        final bool isFlipping = progress > 0.8;

        final double flipAngle =
            isFlipping ? (progress - 0.8) / 0.2 * math.pi : 0.0;

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(-flipAngle),
          alignment: Alignment.center,
          child: _buildCard(_contents[_currentIndex % _contents.length], 0),
        );
      },
    );
  }

  Widget _buildCard(CardContent? content, int depth) {
    return Container(
      width: widget.size * 0.85,
      height: widget.size,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.black, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.08 + (depth * 0.02)),
            blurRadius: 20,
            offset: Offset(0, 8 + (depth * 4)),
          ),
        ],
      ),
      child: content == null
          ? null
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(content.icon,
                    size: widget.size * 0.35, color: AppColors.black),
                const SizedBox(height: 12),
                Container(
                  width: widget.size * 0.4,
                  height: 2,
                  color: AppColors.black.withValues(alpha: 0.1),
                ),
                const SizedBox(height: 6),
                Text(
                  content.label.toUpperCase(),
                  style: AppTextStyles.labelBold
                      .copyWith(fontSize: 8, letterSpacing: 2),
                ),
              ],
            ),
    );
  }
}

class CardContent {
  final IconData icon;
  final String label;
  CardContent({required this.icon, required this.label});
}
