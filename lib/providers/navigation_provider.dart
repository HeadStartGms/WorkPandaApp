import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NavDestination { home, explore, active, wallet, profile }

class NavState {
  final NavDestination currentDestination;
  final String? activeOverlay; // e.g., 'job_detail', 'post_job'
  final dynamic overlayData;

  NavState({
    this.currentDestination = NavDestination.home,
    this.activeOverlay,
    this.overlayData,
  });

  NavState copyWith({
    NavDestination? currentDestination,
    String? activeOverlay,
    dynamic overlayData,
    bool clearOverlay = false,
  }) {
    return NavState(
      currentDestination: currentDestination ?? this.currentDestination,
      activeOverlay: clearOverlay ? null : (activeOverlay ?? this.activeOverlay),
      overlayData: clearOverlay ? null : (overlayData ?? this.overlayData),
    );
  }
}

class NavigationNotifier extends StateNotifier<NavState> {
  NavigationNotifier() : super(NavState());

  void setDestination(NavDestination destination) {
    state = state.copyWith(currentDestination: destination, clearOverlay: true);
  }

  void openOverlay(String overlayId, {dynamic data}) {
    state = state.copyWith(activeOverlay: overlayId, overlayData: data);
  }

  void closeOverlay() {
    state = state.copyWith(clearOverlay: true);
  }
}

final navigationProvider = StateNotifierProvider<NavigationNotifier, NavState>((ref) {
  return NavigationNotifier();
});
