enum OpportunityType { internship, fellowship, competition, grant, leadership, research }

class OpportunityModel {
  final String id;
  final String title;
  final String description;
  final OpportunityType type;
  final DateTime deadline;
  final String provider;
  final String eligibility;
  final String? applyLink;
  final String? contactEmail;
  final List<String> tags;
  final String organiserId;
  final DateTime postedAt;

  const OpportunityModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.deadline,
    required this.provider,
    required this.eligibility,
    this.applyLink,
    this.contactEmail,
    required this.tags,
    required this.organiserId,
    required this.postedAt,
  });

  bool get isExpired => deadline.isBefore(DateTime.now());
}
