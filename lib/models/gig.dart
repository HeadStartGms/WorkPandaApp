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
  final String timeline;
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
    required this.timeline,
    required this.postedAt,
    this.applicants = 0,
    this.isBookmarked = false,
  });
}
