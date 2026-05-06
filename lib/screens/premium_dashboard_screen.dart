import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Design tokens ────────────────────────────────────────────────────────────
const _bg         = Color(0xFF080810);
const _surface    = Color(0xFF111118);
const _card       = Color(0xFF1A1A26);
const _cardHover  = Color(0xFF1F1F2E);
const _accent     = Color(0xFF3B82F6);   // electric blue
const _accentGlow = Color(0x333B82F6);
const _border     = Color(0xFF2A2A3A);
const _borderHov  = Color(0xFF3B82F6);
const _textPri    = Color(0xFFF1F1F5);
const _textSec    = Color(0xFF8888A0);
const _textMuted  = Color(0xFF55556A);

class PremiumDashboardScreen extends StatefulWidget {
  const PremiumDashboardScreen({super.key});

  @override
  State<PremiumDashboardScreen> createState() => _PremiumDashboardScreenState();
}

class _PremiumDashboardScreenState extends State<PremiumDashboardScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['All Projects', 'Active', 'Completed', 'Archived'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // Subtle radial glow in the background
          Positioned(
            top: -200,
            left: -100,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [_accent.withOpacity(0.07), Colors.transparent],
                ),
              ),
            ),
          ),

          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 32, right: 32, top: 48, bottom: 120),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildStatsRow(),
                    const SizedBox(height: 40),
                    _buildFilterTabs(),
                    const SizedBox(height: 28),
                    _buildGrid(),
                  ],
                ),
              ),
            ),
          ),

          // Floating bottom nav
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: _buildBottomNav(),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 700;
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Logo + title
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_accent, Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: _accent.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('WorkPanda', style: GoogleFonts.inter(color: _textPri, fontSize: 18, fontWeight: FontWeight.w700)),
                  Text('Dashboard Overview', style: GoogleFonts.inter(color: _textMuted, fontSize: 11, letterSpacing: 0.5)),
                ],
              ),
            ],
          ),

          // Search bar
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                width: isMobile ? double.infinity : 380,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: _textMuted, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        style: GoogleFonts.inter(color: _textPri, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Search projects, resources...',
                          hintStyle: GoogleFonts.inter(color: _textMuted, fontSize: 14),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: _border,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('⌘K', style: GoogleFonts.inter(color: _textMuted, fontSize: 11)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Right actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIconBtn(Icons.notifications_none_rounded),
              const SizedBox(width: 10),
              _buildIconBtn(Icons.help_outline_rounded),
              const SizedBox(width: 14),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _accent.withOpacity(0.5), width: 2),
                  boxShadow: [BoxShadow(color: _accent.withOpacity(0.2), blurRadius: 10)],
                ),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=33'),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildIconBtn(IconData icon) {
    return _Hoverable(
      builder: (hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: hovered ? _accent.withOpacity(0.12) : Colors.transparent,
          border: Border.all(color: hovered ? _accent.withOpacity(0.5) : _border),
          boxShadow: hovered ? [BoxShadow(color: _accent.withOpacity(0.2), blurRadius: 12)] : [],
        ),
        child: Icon(icon, color: hovered ? _accent : _textSec, size: 18),
      ),
    );
  }

  // ─── Stats Row ─────────────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    final stats = [
      {'label': 'Active Projects', 'value': '12', 'delta': '+3 this week', 'icon': Icons.folder_open_rounded, 'up': true},
      {'label': 'Completed', 'value': '48', 'delta': '+8 this month', 'icon': Icons.check_circle_outline_rounded, 'up': true},
      {'label': 'Pending Review', 'value': '5', 'delta': '−2 from last week', 'icon': Icons.schedule_rounded, 'up': false},
      {'label': 'Team Members', 'value': '24', 'delta': '+2 joined', 'icon': Icons.group_outlined, 'up': true},
    ];

    return LayoutBuilder(builder: (context, constraints) {
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: stats.map((s) {
          return _Hoverable(
            builder: (hovered) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutQuart,
              width: (constraints.maxWidth / 4).clamp(200, 280) - 12,
              transform: hovered ? (Matrix4.identity()..translate(0.0, -3.0)) : Matrix4.identity(),
              decoration: BoxDecoration(
                color: hovered ? _cardHover : _card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: hovered ? _accent.withOpacity(0.45) : _border),
                boxShadow: hovered
                    ? [
                        BoxShadow(color: _accent.withOpacity(0.12), blurRadius: 20, spreadRadius: 0),
                        BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 30, offset: const Offset(0, 8)),
                      ]
                    : [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: _accent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(s['icon'] as IconData, color: _accent, size: 18),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: (s['up'] as bool)
                              ? Colors.greenAccent.withOpacity(0.1)
                              : Colors.redAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          s['delta'] as String,
                          style: GoogleFonts.inter(
                            color: (s['up'] as bool) ? Colors.greenAccent : Colors.redAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    s['value'] as String,
                    style: GoogleFonts.inter(color: _textPri, fontSize: 28, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s['label'] as String,
                    style: GoogleFonts.inter(color: _textSec, fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  // ─── Filter Tabs ───────────────────────────────────────────────────────────
  Widget _buildFilterTabs() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final sel = _selectedTabIndex == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedTabIndex = i),
              child: Padding(
                padding: const EdgeInsets.only(right: 32, bottom: 14),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: GoogleFonts.inter(
                        color: sel ? _textPri : _textSec,
                        fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 14,
                      ),
                      child: Text(_tabs[i]),
                    ),
                    if (sel)
                      Positioned(
                        bottom: -14,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: _accent,
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [BoxShadow(color: _accent.withOpacity(0.6), blurRadius: 8)],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ─── Project Cards Grid ────────────────────────────────────────────────────
  Widget _buildGrid() {
    final cards = [
      _CardData(
        icon: Icons.show_chart_rounded,
        status: 'Live',
        statusColor: const Color(0xFF10B981),
        title: 'Analytics Engine',
        desc: 'Processing real-time user metrics and event streams with sub-ms latency.',
        metricValue: '2.4k',
        metricLabel: 'req/s',
        progress: 0.78,
      ),
      _CardData(
        icon: Icons.storage_rounded,
        status: 'Stable',
        statusColor: _accent,
        title: 'Core Database',
        desc: 'PostgreSQL cluster with read replicas active across 3 regions.',
        metricValue: '99.9%',
        metricLabel: 'uptime',
        progress: 0.99,
      ),
      _CardData(
        icon: Icons.memory_rounded,
        status: 'High Load',
        statusColor: const Color(0xFFF59E0B),
        title: 'Edge Nodes',
        desc: 'Global CDN edge deployment and multi-region caching layer.',
        metricValue: '84%',
        metricLabel: 'capacity',
        progress: 0.84,
      ),
    ];

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: cards.map((c) => _buildCard(c)).toList(),
    );
  }

  Widget _buildCard(_CardData c) {
    return _Hoverable(
      builder: (hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutQuart,
        width: 360,
        transform: hovered ? (Matrix4.identity()..translate(0.0, -5.0)..scale(1.02)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: hovered ? _cardHover : _card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: hovered ? _accent.withOpacity(0.6) : _border, width: hovered ? 1.5 : 1),
          boxShadow: hovered
              ? [
                  BoxShadow(color: _accent.withOpacity(0.14), blurRadius: 28, spreadRadius: 0),
                  BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 40, offset: const Offset(0, 12)),
                ]
              : [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 12)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top gradient accent line
                AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: hovered
                          ? [_accent, const Color(0xFF6366F1)]
                          : [_border, _border],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon + status badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [_accent.withOpacity(0.2), const Color(0xFF6366F1).withOpacity(0.1)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _accent.withOpacity(0.25)),
                            ),
                            child: Icon(c.icon, color: _accent, size: 22),
                          ),
                          _buildStatusBadge(c.status, c.statusColor),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Title
                      Text(
                        c.title,
                        style: GoogleFonts.inter(
                          color: _textPri,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Description
                      Text(
                        c.desc,
                        style: GoogleFonts.inter(
                          color: _textSec,
                          fontSize: 13,
                          height: 1.6,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: c.progress,
                          backgroundColor: _border,
                          valueColor: AlwaysStoppedAnimation<Color>(_accent.withOpacity(0.8)),
                          minHeight: 4,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Divider
                      Container(height: 1, color: _border),
                      const SizedBox(height: 18),

                      // Metric + CTA
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.metricValue,
                                style: GoogleFonts.inter(
                                  color: _textPri,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                c.metricLabel.toUpperCase(),
                                style: GoogleFonts.inter(
                                  color: _textMuted,
                                  fontSize: 9,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          _Hoverable(
                            builder: (btnHov) => AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                              transform: btnHov
                                  ? (Matrix4.identity()..translate(0.0, -2.0))
                                  : Matrix4.identity(),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                color: btnHov ? _accent : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: btnHov ? _accent : _border),
                                boxShadow: btnHov
                                    ? [BoxShadow(color: _accent.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 4))]
                                    : [],
                              ),
                              child: Text(
                                'View Details',
                                style: GoogleFonts.inter(
                                  color: btnHov ? Colors.white : _textSec,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: color.withOpacity(0.6), blurRadius: 6)],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: GoogleFonts.inter(color: color, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ─── Bottom Nav ────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _surface.withOpacity(0.75),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: _border),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 40, offset: const Offset(0, 20)),
              BoxShadow(color: _accent.withOpacity(0.06), blurRadius: 40),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNavItem(Icons.dashboard_outlined, true),
              _buildNavItem(Icons.folder_outlined, false),
              const SizedBox(width: 6),
              // FAB
              _Hoverable(
                builder: (hov) => AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutBack,
                  width: 52,
                  height: 52,
                  transform: hov ? (Matrix4.identity()..scale(1.08)) : Matrix4.identity(),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_accent, Color(0xFF6366F1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: _accent.withOpacity(hov ? 0.5 : 0.3), blurRadius: hov ? 20 : 12, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
                ),
              ),
              const SizedBox(width: 6),
              _buildNavItem(Icons.people_outline_rounded, false),
              _buildNavItem(Icons.settings_outlined, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return _Hoverable(
      builder: (hov) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? _accent.withOpacity(0.15) : (hov ? Colors.white.withOpacity(0.05) : Colors.transparent),
        ),
        child: Icon(
          icon,
          size: 22,
          color: isActive ? _accent : (hov ? _textPri : _textSec),
        ),
      ),
    );
  }
}

// ─── Card data model ──────────────────────────────────────────────────────────
class _CardData {
  final IconData icon;
  final String status;
  final Color statusColor;
  final String title;
  final String desc;
  final String metricValue;
  final String metricLabel;
  final double progress;

  const _CardData({
    required this.icon,
    required this.status,
    required this.statusColor,
    required this.title,
    required this.desc,
    required this.metricValue,
    required this.metricLabel,
    required this.progress,
  });
}

// ─── Reusable hover widget ────────────────────────────────────────────────────
class _Hoverable extends StatefulWidget {
  final Widget Function(bool isHovered) builder;
  const _Hoverable({required this.builder});

  @override
  State<_Hoverable> createState() => _HoverableState();
}

class _HoverableState extends State<_Hoverable> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      cursor: SystemMouseCursors.click,
      child: widget.builder(_hov),
    );
  }
}
