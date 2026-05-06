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
          itemBuilder: (BuildContext ctx, int i) {
            final f = _filters[i];
            final isSelected = f['label'] == _selectedFilter;
            return _HoverableFilterChip(
              key: ValueKey(f['label'] as String),
              filter: f,
              isSelected: isSelected,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  _selectedFilter = f['label'] as String;
                });
              },
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

class _HoverableFilterChip extends StatefulWidget {
  final Map<String, dynamic> filter;
  final bool isSelected;
  final VoidCallback onTap;

  const _HoverableFilterChip({
    super.key,
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_HoverableFilterChip> createState() => _HoverableFilterChipState();
}

class _HoverableFilterChipState extends State<_HoverableFilterChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _sweep;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _sweep = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutQuart);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _ctrl.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _ctrl.reverse();
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: widget.isSelected ? WPTheme.black : Colors.transparent,
            border: Border.all(
              color: widget.isSelected ? WPTheme.black : WPTheme.lightGrey,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Smooth left-to-right sweep (enter) and left-to-right vanish (exit)
              if (!widget.isSelected)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _sweep,
                    builder: (context, _) {
                      return Align(
                        // centerLeft → fills from left on enter
                        // centerRight → shrinks from left on exit (vanishes L→R)
                        alignment: _isHovered
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: FractionallySizedBox(
                          widthFactor: _sweep.value,
                          child: Container(color: WPTheme.lightGrey),
                        ),
                      );
                    },
                  ),
                ),

              // Content stays on top
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.filter['icon'] as IconData,
                        size: 14,
                        color: widget.isSelected ? WPTheme.white : WPTheme.darkGrey),
                    const SizedBox(width: 6),
                    Text(
                      (widget.filter['label'] as String).toUpperCase(),
                      style: WPTheme.label(11,
                          color: widget.isSelected ? WPTheme.white : WPTheme.darkGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
