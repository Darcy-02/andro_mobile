import '../models/opportunity_model.dart';

final List<OpportunityModel> mockOpportunities = [
  OpportunityModel(
    id: 'op1',
    title: 'Software Engineering Intern — Andela',
    description:
        'Join Andela\'s engineering team for a 3-month internship. Work on real products used across Africa. Remote-friendly with optional Kigali office days.',
    type: OpportunityType.internship,
    deadline: DateTime.now().add(const Duration(days: 12)),
    provider: 'Andela',
    eligibility: 'ALU students, Year 2 and above, Software Engineering or Data Science',
    applyLink: 'https://andela.com/careers',
    tags: ['Engineering', 'Remote', 'Paid'],
    organiserId: 'u6',
    postedAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  OpportunityModel(
    id: 'op2',
    title: 'YALI Regional Leadership Center — East Africa',
    description:
        'Four-week residential program at YALI RLC East Africa for emerging leaders under 35. Covers civic leadership, business and entrepreneurship, and public management.',
    type: OpportunityType.fellowship,
    deadline: DateTime.now().add(const Duration(days: 30)),
    provider: 'YALI Network',
    eligibility: 'East African citizens, 18–35 years, demonstrated community impact',
    contactEmail: 'rlc-eastafrica@yali.state.gov',
    tags: ['Leadership', 'Fellowship', 'Fully Funded'],
    organiserId: 'u4',
    postedAt: DateTime.now().subtract(const Duration(days: 7)),
  ),
  OpportunityModel(
    id: 'op3',
    title: 'MasterCard Foundation Scholars — Graduate Scholarship',
    description:
        'Full scholarship for graduate study at select universities in Africa and abroad for scholars who are committed to giving back to their communities.',
    type: OpportunityType.grant,
    deadline: DateTime.now().add(const Duration(days: 45)),
    provider: 'MasterCard Foundation',
    eligibility: 'Graduating ALU students with strong academic record and community involvement',
    applyLink: 'https://mastercardfdn.org/scholars',
    tags: ['Scholarship', 'Graduate', 'Fully Funded'],
    organiserId: 'u6',
    postedAt: DateTime.now().subtract(const Duration(days: 14)),
  ),
  OpportunityModel(
    id: 'op4',
    title: 'Climate Innovation Challenge — Africa Edition',
    description:
        'Submit a written proposal (2000 words max) for a tech or social innovation addressing climate change in Sub-Saharan Africa. Top 5 teams win \$5,000 each.',
    type: OpportunityType.competition,
    deadline: DateTime.now().add(const Duration(days: 20)),
    provider: 'Africa Climate Foundation',
    eligibility: 'Open to all ALU students, individual or teams up to 4',
    contactEmail: 'challenge@africaclimatefoundation.org',
    tags: ['Climate', 'Competition', 'Prize Money'],
    organiserId: 'u1',
    postedAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
  OpportunityModel(
    id: 'op5',
    title: 'Student Government — VP Academic Affairs',
    description:
        'Run for VP Academic Affairs in the upcoming ALU Student Government election. The role involves representing student interests on curriculum and assessment to faculty.',
    type: OpportunityType.leadership,
    deadline: DateTime.now().add(const Duration(days: 10)),
    provider: 'ALU Student Government',
    eligibility: 'ALU students in good standing, Year 2 or above',
    tags: ['Leadership', 'Student Government', 'Campus'],
    organiserId: 'u6',
    postedAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
];
