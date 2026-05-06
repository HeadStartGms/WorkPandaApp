import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'widgets/components.dart';
import 'widgets/premium_components.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/verification_screen.dart';
import 'screens/home_screen.dart';
import 'screens/gig_detail_page.dart';
import 'screens/post_gig_sheet.dart';
import 'screens/discover_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/other_screens.dart';
import 'screens/active_gigs_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/company_profile_screen.dart';
import 'screens/submission_screen.dart';
import 'screens/portfolio_builder_screen.dart';
import 'screens/help_center_screen.dart';
import 'screens/rating_screen.dart';
import 'providers/navigation_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'theme/wp_theme.dart';
import 'providers/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase (Assuming default platform options are configured)
  // await Firebase.initializeApp(); 
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Color(0xFF111111),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const ProviderScope(child: WorkPandaApp()));
}

class WorkPandaApp extends StatelessWidget {
  const WorkPandaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkPanda',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AppShell(),
    );
  }
}

// ─── APP FLOW ────────────────────────────────────────────────────
enum AppFlow { splash, onboarding, auth, verification, main }

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});
  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  // Start directly on main for development; change to AppFlow.splash for production
  AppFlow _flow = AppFlow.main;

  void _setFlow(AppFlow flow) => setState(() => _flow = flow);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _buildFlow(),
    );
  }

  Widget _buildFlow() {
    switch (_flow) {
      case AppFlow.splash:
        return SplashScreen(
            key: const ValueKey('splash'),
            onDone: () => _setFlow(AppFlow.onboarding));
      case AppFlow.onboarding:
        return OnboardingScreen(
            key: const ValueKey('onboard'),
            onDone: () => _setFlow(AppFlow.auth));
      case AppFlow.auth:
        return AuthScreen(
            key: const ValueKey('auth'),
            onDone: () => _setFlow(AppFlow.verification));
      case AppFlow.verification:
        return VerificationScreen(
            key: const ValueKey('verify'),
            onDone: () => _setFlow(AppFlow.main));
      case AppFlow.main:
        return const MainNav(key: ValueKey('main'));
    }
  }
}

// ─── MAIN NAV ────────────────────────────────────────────────────

class MainNav extends ConsumerStatefulWidget {
  const MainNav({super.key});

  @override
  ConsumerState<MainNav> createState() => _MainNavState();
}

class _MainNavState extends ConsumerState<MainNav> {
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
    final navState = ref.watch(navigationProvider);
    final selectedIndex = _getNavIndex(navState.currentDestination);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Apply pure black background
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.05),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Container(
              key: ValueKey<NavDestination>(navState.currentDestination),
              child: _buildScreen(navState.currentDestination, ref),
            ),
          ),
          if (navState.activeOverlay != null)
            _buildOverlay(navState.activeOverlay!, navState.overlayData, ref),
        ],
      ),
      bottomNavigationBar: GlassBottomNav(
        currentIndex: selectedIndex == 2 ? -1 : selectedIndex,
        onTap: (index) {
          if (index == 2) {
            _onFabTap();
          } else {
            HapticFeedback.selectionClick();
            ref.read(navigationProvider.notifier).setDestination(_getNavDest(index));
          }
        },
      ),
    );
  }

  // Removed old _buildFAB, _buildBottomNav, and _navItem


  int _getNavIndex(NavDestination dest) {
    switch (dest) {
      case NavDestination.home: return 0;
      case NavDestination.explore: return 1;
      case NavDestination.active: return 2;
      case NavDestination.wallet: return 3;
      case NavDestination.profile: return 4;
    }
  }

  NavDestination _getNavDest(int index) {
    switch (index) {
      case 0: return NavDestination.home;
      case 1: return NavDestination.explore;
      case 2: return NavDestination.active;
      case 3: return NavDestination.wallet;
      case 4: return NavDestination.profile;
      default: return NavDestination.home;
    }
  }

  Widget _buildScreen(NavDestination dest, WidgetRef ref) {
    switch (dest) {
      case NavDestination.home:
        return const HomeScreen();
      case NavDestination.explore:
        return const DiscoverScreen();
      case NavDestination.active:
        return ActiveGigsScreen(
          onBack: () => ref.read(navigationProvider.notifier).setDestination(NavDestination.home),
          onSubmitTap: () => ref.read(navigationProvider.notifier).openOverlay('submission'),
        );
      case NavDestination.wallet:
        return const WalletScreen();
      case NavDestination.profile:
        return ProfileScreen(
          onSettings: () => ref.read(navigationProvider.notifier).openOverlay('help_center'), // using help center as proxy for now
          onActiveGigsTap: () => ref.read(navigationProvider.notifier).setDestination(NavDestination.active),
          onPortfolioTap: () => ref.read(navigationProvider.notifier).openOverlay('portfolio_builder'),
          onHelpTap: () => ref.read(navigationProvider.notifier).openOverlay('help_center'),
        );
    }
  }

  Widget _buildOverlay(String id, dynamic data, WidgetRef ref) {
    late Widget overlay;
    switch (id) {
      case 'job_detail':
        // Fallback or use a gig model passed via data
        overlay = const SizedBox(); // Not using this for wpmain flow, using standard navigation
        break;
      case 'post_job':
        overlay = const SizedBox(); // Using bottom sheet now
        break;
      case 'notifications':
        overlay = NotificationsScreen(
          onBack: () => ref.read(navigationProvider.notifier).closeOverlay(),
        );
        break;
      case 'company_profile':
        overlay = CompanyProfileScreen(
          onBack: () => ref.read(navigationProvider.notifier).closeOverlay(),
        );
        break;
      case 'submission':
        overlay = SubmissionScreen(
          onBack: () => ref.read(navigationProvider.notifier).closeOverlay(),
        );
        break;
      case 'portfolio_builder':
        overlay = PortfolioBuilderScreen(
          onBack: () => ref.read(navigationProvider.notifier).closeOverlay(),
        );
        break;
      case 'help_center':
        overlay = HelpCenterScreen(
          onBack: () => ref.read(navigationProvider.notifier).closeOverlay(),
        );
        break;
      case 'rating':
        overlay = RatingScreen(
          onBack: () => ref.read(navigationProvider.notifier).closeOverlay(),
        );
        break;
      default:
        overlay = const SizedBox();
    }

    return Positioned.fill(
      child: GestureDetector(
        onTap: () => ref.read(navigationProvider.notifier).closeOverlay(), 
        child: Container(
          color: AppColors.black.withValues(alpha: 0.4), // Dimmed background
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: GestureDetector(
              onTap: () {}, // Prevent taps on the modal itself from closing it
              child: Center(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  margin: const EdgeInsets.only(top: 60), // Editorial offset
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 40,
                        offset: Offset(0, -10),
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      overlay,
                      Positioned(
                        top: 24,
                        right: 24,
                        child: IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, 
                                          color: AppColors.black, size: 32),
                          onPressed: () => ref.read(navigationProvider.notifier).closeOverlay(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().slideY(begin: 1, end: 0, duration: 600.ms, curve: Curves.easeOutQuart);
  }
}
