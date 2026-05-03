import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const WorkPandaApp());
}

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────

class Gig {
  final String id;
  final String title;
  final String description;
  final String poster;
  final String college;
  final double budget;
  final String industry;
  final String urgency;
  final String emoji;
  final DateTime postedAt;
  final int applicants;
  bool isBookmarked;

  Gig({
    required this.id,
    required this.title,
    required this.description,
    required this.poster,
    required this.college,
    required this.budget,
    required this.industry,
    required this.urgency,
    required this.emoji,
    required this.postedAt,
    this.applicants = 0,
    this.isBookmarked = false,
  });
}

// ─────────────────────────────────────────────
// APP STATE (simple in-memory state)
// ─────────────────────────────────────────────

class AppState extends ChangeNotifier {
  final List<Gig> _gigs = [
    Gig(
      id: '1',
      title: 'Library Curator',
      description:
          'Help organize and catalog new books in the university library. Flexible hours, easy work.',
      poster: 'Arjun M.',
      college: 'Anna University',
      budget: 450,
      industry: 'Research',
      urgency: 'Low',
      emoji: '📚',
      postedAt: DateTime.now().subtract(const Duration(hours: 2)),
      applicants: 3,
    ),
    Gig(
      id: '2',
      title: 'Panda Researcher',
      description:
          'Compile research on conservation data. Remote work, great for biology students.',
      poster: 'Priya S.',
      college: 'MU Campus',
      budget: 1200,
      industry: 'Research',
      urgency: 'Medium',
      emoji: '🐼',
      postedAt: DateTime.now().subtract(const Duration(hours: 5)),
      applicants: 7,
    ),
    Gig(
      id: '3',
      title: 'Draft Assistant',
      description:
          'Proofread and edit a 15-page academic paper. Must have excellent English skills.',
      poster: 'Kiran R.',
      college: 'IIT Madras',
      budget: 800,
      industry: 'Writing',
      urgency: 'Priority',
      emoji: '✍️',
      postedAt: DateTime.now().subtract(const Duration(hours: 8)),
      applicants: 2,
    ),
    Gig(
      id: '4',
      title: 'Lab Assistant',
      description:
          'Assist in chemistry lab experiments. Basic lab knowledge required. Safety equipment provided.',
      poster: 'Meena T.',
      college: 'Sathyabama',
      budget: 500,
      industry: 'Research',
      urgency: 'Low',
      emoji: '🧪',
      postedAt: DateTime.now().subtract(const Duration(days: 1)),
      applicants: 5,
    ),
    Gig(
      id: '5',
      title: 'UI/UX Design Review',
      description:
          'Review and critique a mobile app design. Provide detailed feedback report.',
      poster: 'Arun K.',
      college: 'Anna University',
      budget: 400,
      industry: 'Creative',
      urgency: 'Medium',
      emoji: '🎨',
      postedAt: DateTime.now().subtract(const Duration(days: 1)),
      applicants: 9,
    ),
    Gig(
      id: '6',
      title: 'Web Support',
      description:
          'Fix bugs in a React website. Basic HTML/CSS/JS required. Should be done in 2 days.',
      poster: 'Siddharth P.',
      college: 'VIT Chennai',
      budget: 1500,
      industry: 'Tech',
      urgency: 'Priority',
      emoji: '🌐',
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
      applicants: 4,
    ),
    Gig(
      id: '7',
      title: 'Case Study Writer',
      description:
          'Write a marketing case study for a startup project. 2000 words, well-researched.',
      poster: 'Divya N.',
      college: 'Loyola College',
      budget: 600,
      industry: 'Writing',
      urgency: 'Low',
      emoji: '📊',
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
      applicants: 1,
    ),
    Gig(
      id: '8',
      title: 'Pencil Buyer',
      description:
          'Buy 2 HB pencils from the stationery shop near gate 2 and deliver to hostel block C room 204.',
      poster: 'Rahul V.',
      college: 'Anna University',
      budget: 30,
      industry: 'Logistics',
      urgency: 'Priority',
      emoji: '✏️',
      postedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      applicants: 0,
    ),
  ];

  List<Gig> get gigs => List.unmodifiable(_gigs);

  void addGig(Gig gig) {
    _gigs.insert(0, gig);
    notifyListeners();
  }

  void toggleBookmark(String gigId) {
    final gig = _gigs.firstWhere((g) => g.id == gigId);
    gig.isBookmarked = !gig.isBookmarked;
    notifyListeners();
  }

  void applyToGig(String gigId) {
    final idx = _gigs.indexWhere((g) => g.id == gigId);
    if (idx != -1) {
      final g = _gigs[idx];
      _gigs[idx] = Gig(
        id: g.id,
        title: g.title,
        description: g.description,
        poster: g.poster,
        college: g.college,
        budget: g.budget,
        industry: g.industry,
        urgency: g.urgency,
        emoji: g.emoji,
        postedAt: g.postedAt,
        applicants: g.applicants + 1,
        isBookmarked: g.isBookmarked,
      );
      notifyListeners();
    }
  }

  List<Gig> getByIndustry(String industry) {
    if (industry == 'All') return _gigs;
    return _gigs.where((g) => g.industry == industry).toList();
  }

  List<Gig> search(String query) {
    if (query.isEmpty) return _gigs;
    final q = query.toLowerCase();
    return _gigs
        .where((g) =>
            g.title.toLowerCase().contains(q) ||
            g.description.toLowerCase().contains(q) ||
            g.college.toLowerCase().contains(q) ||
            g.industry.toLowerCase().contains(q))
        .toList();
  }
}

// Singleton
final appState = AppState();

// ─────────────────────────────────────────────
// THEME
// ─────────────────────────────────────────────

class WPTheme {
  static const Color black = Color(0xFF0D0D0D);
  static const Color white = Color(0xFFFAFAF7);
  static const Color offWhite = Color(0xFFF2F2ED);
  static const Color lightGrey = Color(0xFFE8E8E3);
  static const Color midGrey = Color(0xFFB0B0A8);
  static const Color darkGrey = Color(0xFF4A4A44);
  static const Color bamboo = Color(0xFF8B9B6B); // subtle bamboo accent
  static const Color bambooLight = Color(0xFFD4DDB8);
  static const Color urgencyLow = Color(0xFF6B9B6B);
  static const Color urgencyMid = Color(0xFFB8860B);
  static const Color urgencyHigh = Color(0xFFB84040);

  static Color urgencyColor(String urgency) {
    switch (urgency) {
      case 'Medium':
        return urgencyMid;
      case 'Priority':
        return urgencyHigh;
      default:
        return urgencyLow;
    }
  }

  static TextStyle display(double size,
      {Color color = black, FontWeight weight = FontWeight.w900}) {
    return TextStyle(
      fontFamily: 'serif',
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: -0.5,
    );
  }

  static TextStyle label(double size,
      {Color color = darkGrey, FontWeight weight = FontWeight.w600}) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: 1.5,
    );
  }

  static TextStyle body(double size, {Color color = black}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: color,
      height: 1.5,
    );
  }
}

// ─────────────────────────────────────────────
// ROOT APP
// ─────────────────────────────────────────────

class WorkPandaApp extends StatelessWidget {
  const WorkPandaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkPanda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: WPTheme.white,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        fontFamily: 'SF Pro Display',
      ),
      home: const MainShell(),
    );
  }
}

// ─────────────────────────────────────────────
// MAIN SHELL (Bottom Nav)
// ─────────────────────────────────────────────

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fabController;

  final List<Widget> _pages = const [
    HomePage(),
    DiscoverPage(),
    SizedBox(), // placeholder for FAB
    MyGigsPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _onFabTap() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PostGigSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WPTheme.white,
      body: IndexedStack(
        index: _currentIndex > 2 ? _currentIndex - 1 : _currentIndex,
        children: [
          const HomePage(),
          const DiscoverPage(),
          const MyGigsPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildFAB() {
    return GestureDetector(
      onTap: _onFabTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: WPTheme.black,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: WPTheme.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: WPTheme.white, size: 28),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: WPTheme.white,
        border: Border(top: BorderSide(color: WPTheme.lightGrey, width: 1)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.grid_view_rounded, 0),
              _navItem(Icons.explore_outlined, 1),
              const SizedBox(width: 60), // FAB space
              _navItem(Icons.work_outline_rounded, 2),
              _navItem(Icons.person_outline_rounded, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    final isActive = (index < 2 ? index : index + 1) == _currentIndex ||
        (index == 0 && _currentIndex == 0) ||
        (index == 1 && _currentIndex == 1) ||
        (index == 2 && _currentIndex == 3) ||
        (index == 3 && _currentIndex == 4);

    // simpler active check
    final active = index == (_currentIndex > 2 ? _currentIndex - 1 : _currentIndex);

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _currentIndex = index > 1 ? index + 1 : index);
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: active ? WPTheme.black : WPTheme.midGrey,
              size: 24,
            ),
            if (active)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: WPTheme.black,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HOME PAGE
// ─────────────────────────────────────────────

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  String _selectedIndustry = 'All';
  final TextEditingController _searchController = TextEditingController();
  List<Gig> _displayedGigs = [];
  bool _isSearching = false;

  final List<String> _industries = [
    'All', 'Research', 'Creative', 'Tech', 'Writing', 'Logistics'
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _displayedGigs = appState.gigs;
    appState.addListener(_onStateChange);
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchController.dispose();
    appState.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() => _updateGigs());
  }

  void _updateGigs() {
    if (_isSearching && _searchController.text.isNotEmpty) {
      _displayedGigs = appState.search(_searchController.text);
    } else {
      _displayedGigs = appState.getByIndustry(_selectedIndustry);
    }
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WPTheme.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildSearch()),
            SliverToBoxAdapter(child: _buildFeaturedCard()),
            SliverToBoxAdapter(child: _buildIndustrySection()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ACTIVE FEED', style: WPTheme.label(11)),
                    Text(
                      '${_displayedGigs.length} gigs',
                      style: WPTheme.label(11, color: WPTheme.midGrey),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _buildGigCard(_displayedGigs[i], i),
                childCount: _displayedGigs.length,
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
              _headerIcon(Icons.notifications_outlined),
              const SizedBox(width: 8),
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: WPTheme.black,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('SK',
                      style: TextStyle(
                          color: WPTheme.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerIcon(IconData icon) {
    return GestureDetector(
      onTap: () {},
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

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_greeting(), style: WPTheme.body(14, color: WPTheme.midGrey)),
          const SizedBox(height: 4),
          Text('FIND YOUR\nFOCUS', style: WPTheme.display(32)),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: WPTheme.offWhite,
              borderRadius: BorderRadius.circular(50),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (q) {
                setState(() {
                  _isSearching = q.isNotEmpty;
                  _updateGigs();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search gigs, colleges, roles...',
                hintStyle: WPTheme.body(14, color: WPTheme.midGrey),
                prefixIcon: const Icon(Icons.search, color: WPTheme.midGrey),
                suffixIcon: _isSearching
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() {
                            _isSearching = false;
                            _updateGigs();
                          });
                        },
                        child: const Icon(Icons.close, color: WPTheme.midGrey),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard() {
    final featured = appState.gigs.isNotEmpty ? appState.gigs.first : null;
    if (featured == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('CURATED OPPORTUNITIES', style: WPTheme.label(11)),
                Icon(Icons.arrow_forward, size: 16, color: WPTheme.midGrey),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: math.min(appState.gigs.length, 5),
              itemBuilder: (ctx, i) {
                final g = appState.gigs[i];
                return _featuredCard(g, i);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _featuredCard(Gig gig, int index) {
    final colors = [
      [WPTheme.black, WPTheme.darkGrey],
      [const Color(0xFF2D4A2D), const Color(0xFF1A2E1A)],
      [const Color(0xFF1A1A2E), const Color(0xFF16213E)],
    ];
    final c = colors[index % colors.length];

    return GestureDetector(
      onTap: () => _openGigDetail(gig),
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [c[0], c[1]],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            // bamboo texture lines
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
                      Icon(Icons.arrow_outward, color: WPTheme.white.withOpacity(0.7), size: 18),
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

  Widget _buildIndustrySection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('INDUSTRIES', style: WPTheme.label(11)),
                Icon(Icons.arrow_forward, size: 16, color: WPTheme.midGrey),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _industries.length,
              itemBuilder: (ctx, i) {
                final ind = _industries[i];
                final isSelected = ind == _selectedIndustry;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _selectedIndustry = ind;
                      _isSearching = false;
                      _searchController.clear();
                      _updateGigs();
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? WPTheme.black : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? WPTheme.black : WPTheme.lightGrey,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      ind.toUpperCase(),
                      style: WPTheme.label(11,
                          color: isSelected ? WPTheme.white : WPTheme.darkGrey),
                    ),
                  ),
                );
              },
            ),
          ),
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

// ─────────────────────────────────────────────
// DISCOVER PAGE
// ─────────────────────────────────────────────

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
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
  void initState() {
    super.initState();
    _results = appState.gigs;
    appState.addListener(_onStateChange);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    appState.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() => _updateResults());
  }

  void _updateResults() {
    final q = _searchCtrl.text;
    List<Gig> base = appState.gigs;

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
          onChanged: (_) => setState(() => _updateResults()),
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
                  _updateResults();
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

// ─────────────────────────────────────────────
// POST GIG SHEET
// ─────────────────────────────────────────────

class PostGigSheet extends StatefulWidget {
  const PostGigSheet({super.key});

  @override
  State<PostGigSheet> createState() => _PostGigSheetState();
}

class _PostGigSheetState extends State<PostGigSheet> {
  final _titleCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _selectedIndustry = '';
  String _selectedUrgency = 'Low';
  bool _isLoading = false;

  final List<String> _industries = [
    'Research', 'Creative', 'Tech', 'Writing', 'Logistics'
  ];

  final Map<String, String> _industryEmojis = {
    'Research': '🔬',
    'Creative': '🎨',
    'Tech': '💻',
    'Writing': '✍️',
    'Logistics': '📦',
  };

  @override
  void dispose() {
    _titleCtrl.dispose();
    _budgetCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _titleCtrl.text.trim().isNotEmpty &&
      _budgetCtrl.text.trim().isNotEmpty &&
      _selectedIndustry.isNotEmpty &&
      _descCtrl.text.trim().isNotEmpty;

  void _submitGig() async {
    if (!_isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all required fields'),
          backgroundColor: WPTheme.black,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    final gig = Gig(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      poster: 'You',
      college: 'Anna University',
      budget: double.tryParse(_budgetCtrl.text.trim()) ?? 0,
      industry: _selectedIndustry,
      urgency: _selectedUrgency,
      emoji: _industryEmojis[_selectedIndustry] ?? '📋',
      postedAt: DateTime.now(),
    );

    appState.addGig(gig);

    if (mounted) {
      Navigator.pop(context);
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('🐼 Gig launched successfully!'),
          backgroundColor: WPTheme.black,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      maxChildSize: 0.97,
      minChildSize: 0.5,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: WPTheme.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              _buildSheetHandle(),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSheetHeader(),
                      const SizedBox(height: 28),
                      _buildField(
                        label: 'GIG TITLE',
                        hint: 'Enter your gig title',
                        controller: _titleCtrl,
                        icon: Icons.title_rounded,
                      ),
                      const SizedBox(height: 20),
                      _buildField(
                        label: 'BUDGET (₹)',
                        hint: 'Enter your budget (₹10 – ₹50,000)',
                        controller: _budgetCtrl,
                        icon: Icons.currency_rupee_rounded,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      _buildIndustryPicker(),
                      const SizedBox(height: 20),
                      _buildField(
                        label: 'DESCRIPTION',
                        hint: 'Clearly outline the deliverable...',
                        controller: _descCtrl,
                        icon: Icons.description_outlined,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 20),
                      _buildUrgencyPicker(),
                      const SizedBox(height: 8),
                      _buildEscrowNote(),
                      const SizedBox(height: 28),
                      _buildLaunchButton(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSheetHandle() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: WPTheme.lightGrey,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildSheetHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('POST GIG', style: WPTheme.label(13, color: WPTheme.midGrey)),
            const SizedBox(height: 4),
            Text('CREATE A NEW\nOPPORTUNITY', style: WPTheme.display(26)),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: WPTheme.offWhite,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.close, size: 18, color: WPTheme.darkGrey),
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: WPTheme.label(11)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: WPTheme.offWhite,
            borderRadius: BorderRadius.circular(maxLines > 1 ? 16 : 50),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            onChanged: (_) => setState(() {}),
            style: WPTheme.body(15),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: WPTheme.body(14, color: WPTheme.midGrey),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Icon(icon, color: WPTheme.midGrey, size: 18),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                  vertical: maxLines > 1 ? 16 : 14, horizontal: maxLines > 1 ? 16 : 0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIndustryPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('INDUSTRY', style: WPTheme.label(11)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _industries.map((ind) {
            final isSelected = ind == _selectedIndustry;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedIndustry = ind);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? WPTheme.black : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? WPTheme.black : WPTheme.lightGrey,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_industryEmojis[ind] ?? '📋',
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      ind.toUpperCase(),
                      style: WPTheme.label(11,
                          color: isSelected ? WPTheme.white : WPTheme.darkGrey),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildUrgencyPicker() {
    final urgencies = ['Low', 'Medium', 'Priority'];
    final colors = [WPTheme.urgencyLow, WPTheme.urgencyMid, WPTheme.urgencyHigh];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('URGENCY', style: WPTheme.label(11)),
        const SizedBox(height: 10),
        Row(
          children: List.generate(urgencies.length, (i) {
            final u = urgencies[i];
            final isSelected = u == _selectedUrgency;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedUrgency = u);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? WPTheme.black : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? WPTheme.black : WPTheme.lightGrey,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      u.toUpperCase(),
                      style: WPTheme.label(11,
                          color: isSelected ? WPTheme.white : WPTheme.darkGrey),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildEscrowNote() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WPTheme.bambooLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: WPTheme.bambooLight, width: 1),
      ),
      child: Row(
        children: [
          const Text('🔒', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Budget is locked in escrow and released only after you approve the work.',
              style: WPTheme.body(12, color: WPTheme.darkGrey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLaunchButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _submitGig,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: _isValid ? WPTheme.black : WPTheme.lightGrey,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: WPTheme.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  '🐼  LAUNCH GIG',
                  style: WPTheme.label(15,
                      color: _isValid ? WPTheme.white : WPTheme.midGrey),
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// GIG DETAIL PAGE
// ─────────────────────────────────────────────

class GigDetailPage extends StatefulWidget {
  final Gig gig;
  const GigDetailPage({super.key, required this.gig});

  @override
  State<GigDetailPage> createState() => _GigDetailPageState();
}

class _GigDetailPageState extends State<GigDetailPage> {
  bool _applied = false;
  bool _isApplying = false;

  void _apply() async {
    if (_applied) return;
    HapticFeedback.mediumImpact();
    setState(() => _isApplying = true);
    await Future.delayed(const Duration(milliseconds: 900));
    appState.applyToGig(widget.gig.id);
    if (mounted) {
      setState(() {
        _isApplying = false;
        _applied = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gig = widget.gig;
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
                  appState.toggleBookmark(gig.id);
                  setState(() {});
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
      bottomNavigationBar: SafeArea(
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
                        _applied ? '✓  APPLICATION SENT' : 'APPLY FOR THIS GIG',
                        style: WPTheme.label(14, color: WPTheme.white),
                      ),
              ),
            ),
          ),
        ),
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
        _statBox('${gig.applicants}', 'APPLICANTS'),
        const SizedBox(width: 12),
        _statBox(ago, 'POSTED'),
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
    final platform = gig.budget * 0.02;
    final gateway = gig.budget * 0.02;
    final workerPay = gig.budget - platform - gateway;

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
          _payRow('Total Budget', '₹${gig.budget.toStringAsFixed(0)}',
              color: WPTheme.white),
          _payRow('Platform Fee (2%)', '- ₹${platform.toStringAsFixed(0)}',
              color: WPTheme.midGrey),
          _payRow('Gateway Fee (2%)', '- ₹${gateway.toStringAsFixed(0)}',
              color: WPTheme.midGrey),
          const Divider(color: Color(0xFF333333), height: 20),
          _payRow('You Receive', '₹${workerPay.toStringAsFixed(0)}',
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

// ─────────────────────────────────────────────
// MY GIGS PAGE (placeholder)
// ─────────────────────────────────────────────

class MyGigsPage extends StatelessWidget {
  const MyGigsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WPTheme.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('WORKPANDA', style: WPTheme.label(16, color: WPTheme.black)),
              const SizedBox(height: 28),
              Text('MY GIGS', style: WPTheme.display(32)),
              const SizedBox(height: 32),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🐼', style: TextStyle(fontSize: 64)),
                      const SizedBox(height: 16),
                      Text('No active gigs yet',
                          style: WPTheme.display(18, color: WPTheme.midGrey)),
                      const SizedBox(height: 8),
                      Text(
                        'Apply to gigs from the Discover page\nor post your own.',
                        style: WPTheme.body(14, color: WPTheme.midGrey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PROFILE PAGE (placeholder)
// ─────────────────────────────────────────────

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WPTheme.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('WORKPANDA', style: WPTheme.label(16, color: WPTheme.black)),
              const SizedBox(height: 28),
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: WPTheme.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('SK',
                          style: TextStyle(
                              color: WPTheme.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Student K', style: WPTheme.display(20)),
                      Text('Anna University',
                          style: WPTheme.label(11, color: WPTheme.midGrey)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.verified, size: 14, color: WPTheme.bamboo),
                          const SizedBox(width: 4),
                          Text('Verified Student',
                              style: WPTheme.label(10, color: WPTheme.bamboo)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  _statCard('0', 'Completed'),
                  const SizedBox(width: 12),
                  _statCard('100%', 'On Time'),
                  const SizedBox(width: 12),
                  _statCard('4.9★', 'Rating'),
                ],
              ),
              const SizedBox(height: 28),
              Text('SKILLS', style: WPTheme.label(11)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Design', 'Writing', 'Research', 'Python', 'Video Editing']
                    .map((s) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: WPTheme.lightGrey),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(s, style: WPTheme.body(13)),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: WPTheme.offWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(value, style: WPTheme.display(18, weight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(label, style: WPTheme.label(10, color: WPTheme.midGrey)),
          ],
        ),
      ),
    );
  }
}
