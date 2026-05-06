import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gig.dart';
import '../providers/app_state.dart';
import '../theme/wp_theme.dart';

class GigDetailPage extends ConsumerStatefulWidget {
  final Gig gig;
  const GigDetailPage({super.key, required this.gig});

  @override
  ConsumerState<GigDetailPage> createState() => _GigDetailPageState();
}

class _GigDetailPageState extends ConsumerState<GigDetailPage> {
  bool _applied = false;
  bool _isApplying = false;

  void _apply() async {
    if (_applied) return;
    HapticFeedback.mediumImpact();
    setState(() => _isApplying = true);
    await Future.delayed(const Duration(milliseconds: 900));
    ref.read(appStateProvider).applyToGig(widget.gig.id);
    if (mounted) {
      setState(() {
        _isApplying = false;
        _applied = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch to update bookmark status if changed
    final appState = ref.watch(appStateProvider);
    final gig = appState.gigs.firstWhere((g) => g.id == widget.gig.id, orElse: () => widget.gig);

    return Scaffold(
      backgroundColor: WPTheme.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: WPTheme.white,
            elevation: 0,
            pinned: true,
            expandedHeight: 220,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: WPTheme.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: WPTheme.black.withOpacity(0.08),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back, color: WPTheme.black, size: 20),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  ref.read(appStateProvider).toggleBookmark(gig.id);
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: WPTheme.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: WPTheme.black.withOpacity(0.08),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      gig.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                      color: WPTheme.black,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [WPTheme.black, WPTheme.darkGrey],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 20,
                      bottom: 20,
                      child: Text(gig.emoji,
                          style: const TextStyle(fontSize: 80)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 90, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              _tag(gig.industry),
                              const SizedBox(width: 8),
                              _urgencyTag(gig.urgency),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(gig.title,
                              style: WPTheme.display(26, color: WPTheme.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _statsRow(gig),
                  const SizedBox(height: 24),
                  Text('ABOUT THIS GIG', style: WPTheme.label(11)),
                  const SizedBox(height: 10),
                  Text(gig.description, style: WPTheme.body(15)),
                  const SizedBox(height: 24),
                  _posterCard(gig),
                  const SizedBox(height: 24),
                  _paymentBreakdown(gig),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
              child: GestureDetector(
                onTap: _apply,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: _applied ? WPTheme.bamboo : WPTheme.black,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: _isApplying
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: WPTheme.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _applied ? '✓  GIG ACCEPTED' : 'ACCEPT GIG',
                            style: WPTheme.label(14, color: WPTheme.white),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: WPTheme.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(label.toUpperCase(),
          style: WPTheme.label(10, color: WPTheme.white)),
    );
  }

  Widget _urgencyTag(String urgency) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: WPTheme.urgencyColor(urgency).withOpacity(0.25),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(urgency.toUpperCase(),
          style: WPTheme.label(10, color: WPTheme.urgencyColor(urgency))),
    );
  }

  Widget _statsRow(Gig gig) {
    final fmt = gig.budget >= 1000
        ? '₹${(gig.budget / 1000).toStringAsFixed(1)}k'
        : '₹${gig.budget.toStringAsFixed(0)}';
    final ago = _timeAgo(gig.postedAt);

    return Row(
      children: [
        _statBox(fmt, 'BUDGET'),
        const SizedBox(width: 12),
        _statBox(gig.timeline, 'TIMELINE'),
        const SizedBox(width: 12),
        _statBox('${gig.applicants}', 'APPLICANTS'),
      ],
    );
  }

  Widget _statBox(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: WPTheme.offWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: WPTheme.display(16, weight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label, style: WPTheme.label(9, color: WPTheme.midGrey)),
          ],
        ),
      ),
    );
  }

  Widget _posterCard(Gig gig) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: WPTheme.lightGrey),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: WPTheme.black,
            child: Text(
              gig.poster.substring(0, 1),
              style: const TextStyle(color: WPTheme.white, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(gig.poster, style: WPTheme.display(14, weight: FontWeight.w700)),
              Text(gig.college, style: WPTheme.label(10, color: WPTheme.midGrey)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: WPTheme.offWhite,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified, size: 12, color: WPTheme.bamboo),
                const SizedBox(width: 4),
                Text('VERIFIED', style: WPTheme.label(9, color: WPTheme.bamboo)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentBreakdown(Gig gig) {
    final int budgetInt = gig.budget.round();
    final int platform = (gig.budget * 0.02).round();
    final int gateway = (gig.budget * 0.02).round();
    final int workerPay = budgetInt - platform - gateway;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WPTheme.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PAYMENT BREAKDOWN',
              style: WPTheme.label(11, color: WPTheme.white)),
          const SizedBox(height: 14),
          _payRow('Total Budget', '₹$budgetInt',
              color: WPTheme.white),
          _payRow('Platform Fee (2%)', '- ₹$platform',
              color: WPTheme.midGrey),
          _payRow('Gateway Fee (2%)', '- ₹$gateway',
              color: WPTheme.midGrey),
          const Divider(color: Color(0xFF333333), height: 20),
          _payRow('You Receive', '₹$workerPay',
              color: WPTheme.bambooLight, bold: true),
        ],
      ),
    );
  }

  Widget _payRow(String label, String value,
      {required Color color, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: WPTheme.body(13,
                  color: bold ? WPTheme.white : WPTheme.midGrey)),
          Text(value,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
              )),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
