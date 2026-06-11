enum RsvpStatus { going, interested, waitlisted, cancelled }

class RsvpEntry {
  final String eventId;
  final RsvpStatus status;
  final DateTime createdAt;
  final bool checkedIn;

  const RsvpEntry({
    required this.eventId,
    required this.status,
    required this.createdAt,
    this.checkedIn = false,
  });
}

enum StartupStage { idea, prototype, earlyRevenue }

class StartupModel {
  final String id;
  final String name;
  final String pitch;
  final StartupStage stage;
  final String description;
  final String? pitchDeckUrl;
  final String organiserId;
  final List<String> teamMemberIds;
  final List<String> openRoles;
  final List<String> interestedIds;
  final DateTime createdAt;

  const StartupModel({
    required this.id,
    required this.name,
    required this.pitch,
    required this.stage,
    required this.description,
    this.pitchDeckUrl,
    required this.organiserId,
    required this.teamMemberIds,
    required this.openRoles,
    required this.interestedIds,
    required this.createdAt,
  });

  StartupModel copyWith({List<String>? interestedIds, List<String>? openRoles}) {
    return StartupModel(
      id: id,
      name: name,
      pitch: pitch,
      stage: stage,
      description: description,
      pitchDeckUrl: pitchDeckUrl,
      organiserId: organiserId,
      teamMemberIds: teamMemberIds,
      openRoles: openRoles ?? this.openRoles,
      interestedIds: interestedIds ?? this.interestedIds,
      createdAt: createdAt,
    );
  }
}

class UserProfile {
  final String id;
  final String name;
  final String preferredName;
  final String email;
  final String bio;
  final String programme;
  final int graduationYear;
  final List<String> interestTags;
  final int eventsAttended;
  final int communitiesCount;

  const UserProfile({
    required this.id,
    required this.name,
    required this.preferredName,
    required this.email,
    required this.bio,
    required this.programme,
    required this.graduationYear,
    required this.interestTags,
    required this.eventsAttended,
    required this.communitiesCount,
  });

  UserProfile copyWith({
    String? name,
    String? preferredName,
    String? bio,
    String? programme,
    int? graduationYear,
    List<String>? interestTags,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      preferredName: preferredName ?? this.preferredName,
      email: email,
      bio: bio ?? this.bio,
      programme: programme ?? this.programme,
      graduationYear: graduationYear ?? this.graduationYear,
      interestTags: interestTags ?? this.interestTags,
      eventsAttended: eventsAttended,
      communitiesCount: communitiesCount,
    );
  }

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}

class MockUser {
  final String id;
  final String name;
  final String programme;

  const MockUser({
    required this.id,
    required this.name,
    required this.programme,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}

final List<MockUser> mockUsers = [
  MockUser(id: 'u1', name: 'Ayomide Adeleye', programme: 'BSc Computer Science'),
  MockUser(id: 'u2', name: 'Chisom Okonkwo', programme: 'BSc Business Management'),
  MockUser(id: 'u3', name: 'Ivan Mugisha', programme: 'BSc Software Engineering'),
  MockUser(id: 'u4', name: 'Fatima Al-Rashid', programme: 'BSc Data Science'),
  MockUser(id: 'u5', name: 'Kofi Mensah', programme: 'BSc Entrepreneurship'),
  MockUser(id: 'u6', name: 'Amara Diallo', programme: 'BSc Computer Science'),
];

final List<StartupModel> mockStartups = [
  StartupModel(
    id: 's1',
    name: 'AgriLink',
    pitch: 'Connecting smallholder farmers to premium markets',
    stage: StartupStage.earlyRevenue,
    description:
        'AgriLink enables smallholder farmers across Sub-Saharan Africa to access premium markets, fair pricing, and logistics support through a simple mobile interface.',
    organiserId: 'u2',
    teamMemberIds: ['u2', 'u5'],
    openRoles: ['Engineer', 'Marketer'],
    interestedIds: ['u3'],
    createdAt: DateTime(2025, 3, 1),
  ),
  StartupModel(
    id: 's2',
    name: 'HealthBridge',
    pitch: 'Telemedicine for underserved communities in Africa',
    stage: StartupStage.prototype,
    description:
        'HealthBridge connects patients in remote areas with qualified doctors through a low-bandwidth video consultation platform optimised for African networks.',
    organiserId: 'u3',
    teamMemberIds: ['u3', 'u4'],
    openRoles: ['Designer', 'Operations'],
    interestedIds: ['u2'],
    createdAt: DateTime(2025, 4, 15),
  ),
  StartupModel(
    id: 's3',
    name: 'EduStack',
    pitch: 'Gamified exam prep for African high-schoolers',
    stage: StartupStage.idea,
    description:
        'EduStack makes exam preparation engaging through bite-sized gamified content aligned with national curricula across East and West Africa.',
    organiserId: 'u5',
    teamMemberIds: ['u5'],
    openRoles: ['Designer', 'Engineer', 'Marketer'],
    interestedIds: [],
    createdAt: DateTime(2025, 5, 10),
  ),
  StartupModel(
    id: 's4',
    name: 'PayRoute',
    pitch: 'Cross-border payments simplified for African SMEs',
    stage: StartupStage.prototype,
    description:
        'PayRoute offers a simple API and dashboard that lets African SMEs send and receive cross-border payments in local currencies at minimal cost.',
    organiserId: 'u6',
    teamMemberIds: ['u6', 'u4'],
    openRoles: [],
    interestedIds: ['u2', 'u5'],
    createdAt: DateTime(2025, 2, 20),
  ),
];
