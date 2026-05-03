import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../models/gig.dart';
import '../providers/app_state.dart';
import '../theme/wp_theme.dart';
import 'gig_detail_page.dart';
import '../providers/navigation_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    
    // Derived lists for Home Page specific content
    final urgentGigs = state.gigs.where((g) => g.urgency == 'Priority').toList();
    final recommendedGigs = state.gigs.take(4).toList(); // Mocking recommended

    return Scaffold(
      backgroundColor: WPTheme.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildGreeting()),
            SliverToBoxAdapter(child: _buildMyActiveStatus()),
            if (urgentGigs.isNotEmpty)
              SliverToBoxAdapter(child: _buildUrgentSection(urgentGigs)),
            SliverToBoxAdapter(child: _buildRecommendedHeader()),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _buildGigCard(recommendedGigs[i], i),
                childCount: recommendedGigs.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('WORKPANDA', style: WPTheme.label(16, color: WPTheme.black)),
          Row(
            children: [
              _headerIcon(Icons.notifications_outlined, onTap: () {
                ref.read(navigationProvider.notifier).openOverlay('notifications');
              }),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  ref.read(navigationProvider.notifier).setDestination(NavDestination.profile);
                },
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: WPTheme.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('WP',
                        style: TextStyle(
                            color: WPTheme.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerIcon(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: WPTheme.offWhite,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: WPTheme.black),
      ),
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_greeting(), style: WPTheme.body(14, color: WPTheme.midGrey)),
          const SizedBox(height: 4),
          Text('YOUR DASHBOARD', style: WPTheme.display(32)),
        ],
      ),
    );
  }

  Widget _buildMyActiveStatus() {
    return GestureDetector(
      onTap: () => ref.read(navigationProvider.notifier).setDestination(NavDestination.active),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: WPTheme.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: WPTheme.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text('🎯', style: TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Active Gigs', style: WPTheme.label(13, color: WPTheme.white)),
                  const SizedBox(height: 4),
                  Text('You are currently hired for 0 gigs.', 
                    style: WPTheme.body(13, color: WPTheme.white.withOpacity(0.7))),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: WPTheme.white.withOpacity(0.5), size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildUrgentSection(List<Gig> urgentGigs) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('URGENT OPPORTUNITIES', style: WPTheme.label(11)),
                Icon(Icons.arrow_forward, size: 16, color: WPTheme.midGrey),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: math.min(urgentGigs.length, 5),
              itemBuilder: (ctx, i) {
                return _urgentCard(urgentGigs[i], i);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _urgentCard(Gig gig, int index) {
    return GestureDetector(
      onTap: () => _openGigDetail(gig),
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8B0000), Color(0xFF4A0000)], // Dark red for urgent
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: 20,
              child: _bambooDeco(opacity: 0.08),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(gig.emoji, style: const TextStyle(fontSize: 28)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: WPTheme.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          'ASAP',
                          style: WPTheme.label(9, color: WPTheme.black),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    gig.title.toUpperCase(),
                    style: WPTheme.label(18, color: WPTheme.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    gig.description,
                    style: WPTheme.body(12, color: WPTheme.white.withOpacity(0.65)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: WPTheme.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          '₹${_formatBudget(gig.budget)}',
                          style: WPTheme.label(11, color: WPTheme.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        gig.college,
                        style: WPTheme.body(11, color: WPTheme.white.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bambooDeco({double opacity = 0.1}) {
    return Opacity(
      opacity: opacity,
      child: Column(
        children: List.generate(
          8,
          (i) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            width: 80,
            height: 6,
            decoration: BoxDecoration(
              color: WPTheme.white,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendedHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('RECOMMENDED FOR YOU', style: WPTheme.label(11)),
        ],
      ),
    );
  }

  Widget _buildGigCard(Gig gig, int index) {
    return GestureDetector(
      onTap: () => _openGigDetail(gig),
      child: AnimatedBuilder(
        animation: _animController,
        builder: (ctx, child) {
          final delay = (index * 0.1).clamp(0.0, 0.8);
          final t = Curves.easeOutCubic.transform(
            ((_animController.value - delay) / (1 - delay)).clamp(0.0, 1.0),
          );
          return Transform.translate(
            offset: Offset(0, 30 * (1 - t)),
            child: Opacity(opacity: t, child: child),
          );
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: WPTheme.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: WPTheme.lightGrey, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: WPTheme.offWhite,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(gig.emoji, style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(gig.title,
                        style: WPTheme.display(15,
                            weight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(gig.college.toUpperCase(),
                        style: WPTheme.label(10, color: WPTheme.midGrey)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${_formatBudget(gig.budget)}',
                    style: WPTheme.display(15, weight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: WPTheme.urgencyColor(gig.urgency).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      gig.urgency.toUpperCase(),
                      style: WPTheme.label(9,
                          color: WPTheme.urgencyColor(gig.urgency)),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: WPTheme.midGrey, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _openGigDetail(Gig gig) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GigDetailPage(gig: gig)),
    );
  }

  String _formatBudget(double b) {
    if (b >= 1000) return '${(b / 1000).toStringAsFixed(1)}k';
    return b.toStringAsFixed(0);
  }
}
