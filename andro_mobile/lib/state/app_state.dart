import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui/models/profile_models.dart';

class AppState extends ChangeNotifier {
  // ── Current user ────────────────────────────────────────────────────────────
  UserProfile _currentUser = const UserProfile(
    id: 'u1',
    name: 'Ayomide Adeleye',
    preferredName: 'Ayo',
    email: 'shadec137@gmail.com',
    bio: 'CS student at ALU Kigali. Building things at the intersection of tech and community.',
    programme: 'BSc Computer Science',
    graduationYear: 2026,
    interestTags: ['Technology', 'Entrepreneurship', 'Leadership'],
    eventsAttended: 5,
    communitiesCount: 3,
  );

  UserProfile get currentUser => _currentUser;

  void updateCurrentUser(UserProfile updated) {
    _currentUser = updated;
    notifyListeners();
  }

  // ── Theme ───────────────────────────────────────────────────────────────────
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _prefs?.setBool('dark_mode', _themeMode == ThemeMode.dark);
    notifyListeners();
  }

  // ── RSVPs ───────────────────────────────────────────────────────────────────
  final List<RsvpEntry> _rsvps = [
    RsvpEntry(
      eventId: 'f1',
      status: RsvpStatus.going,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    RsvpEntry(
      eventId: 'e1',
      status: RsvpStatus.going,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    RsvpEntry(
      eventId: 'e2',
      status: RsvpStatus.interested,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
  ];

  List<RsvpEntry> get rsvps => List.unmodifiable(_rsvps);

  void rsvpEvent(String eventId, RsvpStatus status) {
    _rsvps.removeWhere((r) => r.eventId == eventId);
    _rsvps.add(RsvpEntry(
      eventId: eventId,
      status: status,
      createdAt: DateTime.now(),
    ));
    notifyListeners();
  }

  void cancelRsvp(String eventId) {
    _rsvps.removeWhere((r) => r.eventId == eventId);
    notifyListeners();
  }

  // ── Saved events ────────────────────────────────────────────────────────────
  final List<String> _savedEventIds = ['e2', 'e3'];
  List<String> get savedEventIds => List.unmodifiable(_savedEventIds);

  void toggleSave(String eventId) {
    if (_savedEventIds.contains(eventId)) {
      _savedEventIds.remove(eventId);
    } else {
      _savedEventIds.add(eventId);
    }
    notifyListeners();
  }

  // ── Connections ─────────────────────────────────────────────────────────────
  final List<String> _connectionIds = ['u2', 'u3'];
  final List<String> _pendingConnectionIds = ['u4'];

  List<String> get connectionIds => List.unmodifiable(_connectionIds);
  List<String> get pendingConnectionIds => List.unmodifiable(_pendingConnectionIds);

  void sendConnectionRequest(String userId) {
    if (!_pendingConnectionIds.contains(userId) &&
        !_connectionIds.contains(userId)) {
      _pendingConnectionIds.add(userId);
      notifyListeners();
    }
  }

  void acceptConnection(String userId) {
    _pendingConnectionIds.remove(userId);
    if (!_connectionIds.contains(userId)) {
      _connectionIds.add(userId);
      notifyListeners();
    }
  }

  // ── Startups ────────────────────────────────────────────────────────────────
  final List<StartupModel> _startups = List.from(mockStartups);
  List<StartupModel> get startups => List.unmodifiable(_startups);

  void expressInterest(String startupId) {
    final idx = _startups.indexWhere((s) => s.id == startupId);
    if (idx == -1) return;
    final s = _startups[idx];
    if (!s.interestedIds.contains(_currentUser.id)) {
      _startups[idx] = s.copyWith(
        interestedIds: [...s.interestedIds, _currentUser.id],
      );
      notifyListeners();
    }
  }

  void addStartup(StartupModel startup) {
    _startups.insert(0, startup);
    notifyListeners();
  }

  // ── Preferences ─────────────────────────────────────────────────────────────
  SharedPreferences? _prefs;

  final Map<String, bool> _prefs2 = {
    'notif_events': true,
    'notif_opportunities': true,
    'notif_communities': true,
    'notif_dms': true,
    'notif_mentions': true,
    'privacy_show_rsvps': true,
    'privacy_appear_search': true,
  };

  bool getPref(String key) => _prefs2[key] ?? true;

  Future<void> setPref(String key, bool value) async {
    _prefs2[key] = value;
    notifyListeners();
    _prefs?.setBool(key, value);
  }

  Future<void> loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final isDark = _prefs!.getBool('dark_mode') ?? true;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    for (final key in _prefs2.keys) {
      _prefs2[key] = _prefs!.getBool(key) ?? true;
    }
    notifyListeners();
  }

  // ── Auth ────────────────────────────────────────────────────────────────────
  void logout() {
    _rsvps.clear();
    _savedEventIds.clear();
    notifyListeners();
  }
}
