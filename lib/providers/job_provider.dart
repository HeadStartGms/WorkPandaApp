import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobListing {
  final String id;
  final String title;
  final String company;
  final String location;
  final String pay;
  final String duration;
  final String category;
  final String description;
  final String emoji;

  JobListing({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.pay,
    required this.duration,
    required this.category,
    required this.description,
    required this.emoji,
  });
}

class JobNotifier extends StateNotifier<AsyncValue<List<JobListing>>> {
  JobNotifier() : super(const AsyncValue.loading()) {
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    state = const AsyncValue.loading();
    try {
      // Simulation of a fetch from Firestore
      await Future.delayed(const Duration(milliseconds: 800));
      
      final mockJobs = [
        JobListing(
          id: '1',
          title: 'UX DESIGN',
          company: 'Anna University',
          location: 'Chennai, TN',
          pay: '₹5,000',
          duration: '2 Weeks',
          category: 'Creative',
          description: 'High payout student gig available at Anna University.',
          emoji: '✨',
        ),
        JobListing(
          id: '2',
          title: 'CONTENT WRITING',
          company: 'Startup Hub',
          location: 'Remote',
          pay: '₹3,500',
          duration: '1 Month',
          category: 'Writing',
          description: 'Help us draft professional student blogs.',
          emoji: '✍️',
        ),
        JobListing(
          id: '3',
          title: 'TECH SUPPORT',
          company: 'Cloud Corp',
          location: 'Bangalore, KA',
          pay: '₹8,000',
          duration: '3 Months',
          category: 'Tech',
          description: 'Provide level 1 support for cloud operations.',
          emoji: '💻',
        ),
      ];
      
      state = AsyncValue.data(mockJobs);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void addJob(JobListing job) {
    state.whenData((jobs) {
      state = AsyncValue.data([job, ...jobs]);
    });
  }
}

final jobProvider = StateNotifierProvider<JobNotifier, AsyncValue<List<JobListing>>>((ref) {
  return JobNotifier();
});
