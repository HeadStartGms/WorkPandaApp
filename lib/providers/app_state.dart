import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gig.dart';

class AppState extends ChangeNotifier {
  final List<Gig> _gigs = [
    Gig(
      id: '1',
      title: 'Library Curator',
      description:
          'Help organize and catalog new books in the university library. Flexible hours, easy work.',
      poster: 'Rahul Manikandan',
      college: 'Anna University',
      budget: 450,
      industry: 'Research',
      urgency: 'Low',
      emoji: '📚',
      timeline: '2 Weeks',
      postedAt: DateTime.now().subtract(const Duration(hours: 2)),
      applicants: 3,
    ),
    Gig(
      id: '2',
      title: 'Panda Researcher',
      description:
          'Compile research on conservation data. Remote work, great for biology students.',
      poster: 'Santhosh P.U.',
      college: 'MU Campus',
      budget: 1200,
      industry: 'Research',
      urgency: 'Medium',
      emoji: '🐼',
      timeline: '4 Days',
      postedAt: DateTime.now().subtract(const Duration(hours: 5)),
      applicants: 7,
    ),
    Gig(
      id: '3',
      title: 'Draft Assistant',
      description:
          'Proofread and edit a 15-page academic paper. Must have excellent English skills.',
      poster: 'Guru.',
      college: 'IIT Madras',
      budget: 800,
      industry: 'Writing',
      urgency: 'Priority',
      emoji: '✍️',
      timeline: '24 Hours',
      postedAt: DateTime.now().subtract(const Duration(hours: 8)),
      applicants: 2,
    ),
    Gig(
      id: '4',
      title: 'Lab Assistant',
      description:
          'Assist in chemistry lab experiments. Basic lab knowledge required. Safety equipment provided.',
      poster: 'Sreekumar',
      college: 'Sathyabama',
      budget: 500,
      industry: 'Research',
      urgency: 'Low',
      emoji: '🧪',
      timeline: '1 Month',
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
      timeline: '3 Days',
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
      timeline: '2 Days',
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
      timeline: '1 Week',
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
      applicants: 1,
    ),
    Gig(
      id: '8',
      title: 'Pencil Buyer',
      description:
          'Buy 2 HB pencils from the stationery shop near gate 2 and deliver to hostel block C room 204.',
      poster: 'Gokul P.U.',
      college: 'Anna University',
      budget: 30,
      industry: 'Logistics',
      urgency: 'Priority',
      emoji: '✏️',
      timeline: '1 Hour',
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
        timeline: g.timeline,
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

final appStateProvider = ChangeNotifierProvider<AppState>((ref) {
  return AppState();
});
