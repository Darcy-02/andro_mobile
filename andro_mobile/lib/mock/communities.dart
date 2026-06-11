import '../models/community_model.dart';

final List<CommunityModel> mockCommunities = [
  CommunityModel(
    id: 'c1',
    name: 'ALU Debate Society',
    description:
        'The official debate club at ALU Kigali. We compete in national and regional tournaments and host public debates on campus every two weeks.',
    category: CommunityCategory.academic,
    adminIds: ['u3'],
    memberIds: ['u1', 'u3', 'u5', 'u7', 'u9'],
    isPrivate: false,
    createdAt: DateTime(2023, 8, 15),
  ),
  CommunityModel(
    id: 'c2',
    name: 'Tech and Innovation Hub',
    description:
        'A community for builders, coders, and tech enthusiasts. We run workshops, hackathons, and a weekly study hall every Friday evening.',
    category: CommunityCategory.professional,
    adminIds: ['u6'],
    memberIds: ['u1', 'u2', 'u4', 'u6', 'u8', 'u10'],
    isPrivate: false,
    createdAt: DateTime(2023, 9, 1),
  ),
  CommunityModel(
    id: 'c3',
    name: 'Entrepreneurship Club',
    description:
        'Supporting student founders through mentorship, pitch practice, and connections to investors and accelerators across East Africa.',
    category: CommunityCategory.professional,
    adminIds: ['u1'],
    memberIds: ['u1', 'u2', 'u3', 'u5', 'u7'],
    isPrivate: false,
    createdAt: DateTime(2023, 9, 10),
  ),
  CommunityModel(
    id: 'c4',
    name: 'Women in Leadership',
    description:
        'A safe space for women at ALU to share experiences, build networks, and grow as leaders. Open to allies who support gender equity.',
    category: CommunityCategory.social,
    adminIds: ['u4'],
    memberIds: ['u4', 'u5', 'u7', 'u10'],
    isPrivate: false,
    createdAt: DateTime(2023, 10, 5),
  ),
  CommunityModel(
    id: 'c5',
    name: 'ALU Sports Collective',
    description:
        'Organising football, volleyball, basketball and athletics at ALU. We compete in the Kigali Universities Sports League each semester.',
    category: CommunityCategory.sports,
    adminIds: ['u9'],
    memberIds: ['u3', 'u6', 'u8', 'u9'],
    isPrivate: false,
    createdAt: DateTime(2023, 8, 20),
  ),
  CommunityModel(
    id: 'c6',
    name: 'Campus Leaders Circle',
    description:
        'Invitation-only group for student government members, club presidents, and cohort reps to coordinate cross-campus initiatives.',
    category: CommunityCategory.service,
    adminIds: ['u6'],
    memberIds: ['u1', 'u4', 'u6', 'u9'],
    isPrivate: true,
    createdAt: DateTime(2024, 1, 15),
  ),
  CommunityModel(
    id: 'c7',
    name: 'Travel Buddies',
    description:
        'Weekend trips, Rwanda road trips, and gorilla trekking coordination for ALU students. Safety in numbers, memories for life.',
    category: CommunityCategory.social,
    adminIds: ['u5'],
    memberIds: ['u2', 'u5', 'u7', 'u10'],
    isPrivate: false,
    createdAt: DateTime(2024, 2, 1),
  ),
];
