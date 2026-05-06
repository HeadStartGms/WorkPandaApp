import 'package:flutter/material.dart';

// ─── HOVER CARD ─────────────────────────────────────────────
class HoverCard extends StatefulWidget {
  final Widget child;

  const HoverCard({super.key, required this.child});

  @override
  _HoverCardState createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: isHovered ? (Matrix4.identity()..translate(0, -5)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isHovered
              ? [const BoxShadow(color: Colors.black54, blurRadius: 20)]
              : [],
        ),
        child: widget.child,
      ),
    );
  }
}

// ─── GLOW BUTTON ────────────────────────────────────────────
class GlowButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const GlowButton({super.key, required this.text, required this.onTap});

  @override
  _GlowButtonState createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: isHovered
                ? [
                    const BoxShadow(
                      color: Colors.white24,
                      blurRadius: 15,
                    )
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── GLASS BOTTOM NAV ───────────────────────────────────────
class GlassBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GlassBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navIcon(Icons.grid_view_rounded, 0),
          _navIcon(Icons.explore_outlined, 1),
          _navIcon(Icons.add_circle, 2, isFab: true), // Virtual FAB
          _navIcon(Icons.account_balance_wallet_outlined, 3),
          _navIcon(Icons.person_outline, 4),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, int index, {bool isFab = false}) {
    final active = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: isFab ? const EdgeInsets.all(12) : const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isFab 
            ? Colors.white 
            : active ? Colors.white.withOpacity(0.1) : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: isFab 
            ? Colors.black 
            : active ? Colors.white : Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }
}

// ─── SHIMMER SKELETON ────────────────────────────────────────
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius = 8,
  });

  @override
  _ShimmerLoadingState createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: const Color(0xFF1A1A1A),
      end: const Color(0xFF2A2A2A),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _colorAnimation.value,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}
