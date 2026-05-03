import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gig.dart';
import '../providers/app_state.dart';
import '../theme/wp_theme.dart';
import 'gig_detail_page.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchCtrl = TextEditingController();
  List<Gig> _results = [];

  final List<Map<String, dynamic>> _filters = [
    {'label': 'All', 'icon': Icons.grid_view_rounded},
    {'label': 'Design', 'icon': Icons.palette_outlined},
    {'label': 'Code', 'icon': Icons.code_rounded},
    {'label': 'Writing', 'icon': Icons.edit_outlined},
    {'label': 'Research', 'icon': Icons.science_outlined},
    {'label': 'Logistics', 'icon': Icons.local_shipping_outlined},
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _updateResults(AppState state) {
    final q = _searchCtrl.text;
    List<Gig> base = state.gigs;

    if (_selectedFilter != 'All') {
      final map = {
        'Design': 'Creative',
        'Code': 'Tech',
        'Writing': 'Writing',
        'Research': 'Research',
        'Logistics': 'Logistics',
      };
      final industry = map[_selectedFilter] ?? _selectedFilter;
      base = base.where((g) => g.industry == industry).toList();
    }

    if (q.isNotEmpty) {
      final ql = q.toLowerCase();
      base = base
          .where((g) =>
              g.title.toLowerCase().contains(ql) ||
              g.description.toLowerCase().contains(ql) ||
              g.college.toLowerCase().contains(ql))
          .toList();
    }

    _results = base;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    _updateResults(state);

    return Scaffold(
      backgroundColor: WPTheme.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildSearch()),
            SliverToBoxAdapter(child: _buildFilters()),
            SliverToBoxAdapter(child: _buildFeaturedBanner()),
            SliverToBoxAdapter(child: _buildTrendingHeader()),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _buildGridCard(_results[i]),
                childCount: _results.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
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
          Text('DISCOVER', style: WPTheme.label(18, color: WPTheme.black)),
          Icon(Icons.tune_rounded, color: WPTheme.black, size: 22),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: WPTheme.offWhite,
          borderRadius: BorderRadius.circular(50),
        ),
        child: TextField(
          controller: _searchCtrl,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Search for campus gigs...',
            hintStyle: WPTheme.body(14, color: WPTheme.midGrey),
            prefixIcon: const Icon(Icons.search, color: WPTheme.midGrey),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 0, 0),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          itemBuilder: (ctx, i) {
            final f = _filters[i];
            final isSelected = f['label'] == _selectedFilter;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  _selectedFilter = f['label'];
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? WPTheme.black : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? WPTheme.black : WPTheme.lightGrey,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    Icon(f['icon'] as IconData,
                        size: 14,
                        color: isSelected ? WPTheme.white : WPTheme.darkGrey),
                    const SizedBox(width: 6),
                    Text(
                      (f['label'] as String).toUpperCase(),
                      style: WPTheme.label(11,
                          color: isSelected ? WPTheme.white : WPTheme.darkGrey),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeaturedBanner() {
    if (_results.isEmpty) return const SizedBox();
    final g = _results.first;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CURATED FOR YOU', style: WPTheme.label(11)),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GigDetailPage(gig: g)),
            ),
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2D1B69), Color(0xFF0D3B38), Color(0xFF1A1A2E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  // decorative bamboo
                  Positioned(
                    right: 20,
                    top: 20,
                    child: Opacity(
                      opacity: 0.12,
                      child: Column(
                        children: List.generate(6, (i) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          width: 60,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade400,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            'VERIFIED PARTNER',
                            style: WPTheme.label(10, color: WPTheme.white),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          g.title,
                          style: WPTheme.display(24, color: WPTheme.white),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          g.description,
                          style: WPTheme.body(13, color: WPTheme.white.withOpacity(0.65)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: WPTheme.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text('VIEW DETAILS',
                                style: WPTheme.label(13, color: WPTheme.black)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text('TRENDING GIGS', style: WPTheme.label(11)),
    );
  }

  Widget _buildGridCard(Gig gig) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GigDetailPage(gig: gig)),
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: WPTheme.offWhite,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(gig.emoji, style: const TextStyle(fontSize: 32)),
            const Spacer(),
            Text(
              gig.title.toUpperCase(),
              style: WPTheme.label(13, color: WPTheme.black),
              maxLines: 2,
            ),
            const SizedBox(height: 6),
            Text(
              '₹${_fmt(gig.budget)} / GIG',
              style: WPTheme.body(12, color: WPTheme.midGrey),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(double b) {
    if (b >= 1000) return '${(b / 1000).toStringAsFixed(1)}k';
    return b.toStringAsFixed(0);
  }
}
