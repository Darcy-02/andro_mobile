import '../models/startup_model.dart';

final List<StartupModel> mockStartups = [
  StartupModel(
    id: 's1',
    name: 'AgriConnect',
    pitch: 'Linking smallholder farmers to buyers and financial services via SMS.',
    stage: StartupStage.prototype,
    description:
        'AgriConnect removes the middleman for Rwanda\'s 2 million smallholder farmers. '
        'Farmers list produce via SMS, buyers place orders, and micro-loans are disbursed '
        'through mobile money — all without a smartphone.',
    pitchDeckUrl: null,
    organiserId: 'u1',
    teamMemberIds: ['u1', 'u3', 'u8'],
    openRoles: ['Designer', 'Operations'],
    interestCount: 34,
    createdAt: DateTime(2025, 9, 10),
  ),
  StartupModel(
    id: 's2',
    name: 'EduBridge',
    pitch: 'Offline-first learning platform for students in low-connectivity areas.',
    stage: StartupStage.idea,
    description:
        'EduBridge packages curated curricula onto affordable SD cards distributed '
        'through local schools. Students study offline; progress syncs when connectivity '
        'is available. Targeting rural Ghana and Rwanda in the first phase.',
    pitchDeckUrl: null,
    organiserId: 'u3',
    teamMemberIds: ['u3', 'u5'],
    openRoles: ['Engineer', 'Marketer'],
    interestCount: 21,
    createdAt: DateTime(2025, 10, 3),
  ),
  StartupModel(
    id: 's3',
    name: 'HealthTrack Rwanda',
    pitch: 'Community health worker app for real-time patient tracking in clinics.',
    stage: StartupStage.earlyRevenue,
    description:
        'HealthTrack provides community health workers with a lightweight Android app '
        'to track patient visits, medication adherence, and referrals. Currently deployed '
        'in 12 clinics across Kigali with 3 paying NGO clients.',
    pitchDeckUrl: null,
    organiserId: 'u4',
    teamMemberIds: ['u4', 'u10'],
    openRoles: ['Engineer'],
    interestCount: 58,
    createdAt: DateTime(2025, 6, 20),
  ),
  StartupModel(
    id: 's4',
    name: 'ArtisanHub',
    pitch: 'E-commerce marketplace connecting African craftspeople to global buyers.',
    stage: StartupStage.prototype,
    description:
        'ArtisanHub gives traditional craft makers in Rwanda and Zimbabwe a storefront, '
        'logistics support, and fair-pricing tools. Artists keep 85% of sales — '
        'far above the 40–60% typical of intermediaries.',
    pitchDeckUrl: null,
    organiserId: 'u7',
    teamMemberIds: ['u7', 'u2'],
    openRoles: ['Engineer', 'Marketer', 'Operations'],
    interestCount: 29,
    createdAt: DateTime(2025, 11, 5),
  ),
  StartupModel(
    id: 's5',
    name: 'SolarShare',
    pitch: 'Peer-to-peer solar energy trading for off-grid rural communities.',
    stage: StartupStage.idea,
    description:
        'SolarShare lets households with surplus solar power sell it to neighbours '
        'through a simple token system. The model requires no grid infrastructure — '
        'communities self-organise energy distribution.',
    pitchDeckUrl: null,
    organiserId: 'u1',
    teamMemberIds: ['u1', 'u10'],
    openRoles: ['Engineer', 'Designer', 'Operations'],
    interestCount: 17,
    createdAt: DateTime(2025, 12, 1),
  ),
];
