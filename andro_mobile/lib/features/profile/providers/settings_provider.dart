import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final bool eventsNotifications;
  final bool opportunitiesNotifications;
  final bool communitiesNotifications;
  final bool dmsNotifications;
  final bool mentionsNotifications;
  final bool showRsvpsPublicly;
  final bool appearInSearch;

  const SettingsState({
    this.eventsNotifications = true,
    this.opportunitiesNotifications = true,
    this.communitiesNotifications = true,
    this.dmsNotifications = true,
    this.mentionsNotifications = true,
    this.showRsvpsPublicly = true,
    this.appearInSearch = true,
  });

  SettingsState copyWith({
    bool? eventsNotifications,
    bool? opportunitiesNotifications,
    bool? communitiesNotifications,
    bool? dmsNotifications,
    bool? mentionsNotifications,
    bool? showRsvpsPublicly,
    bool? appearInSearch,
  }) =>
      SettingsState(
        eventsNotifications: eventsNotifications ?? this.eventsNotifications,
        opportunitiesNotifications: opportunitiesNotifications ?? this.opportunitiesNotifications,
        communitiesNotifications: communitiesNotifications ?? this.communitiesNotifications,
        dmsNotifications: dmsNotifications ?? this.dmsNotifications,
        mentionsNotifications: mentionsNotifications ?? this.mentionsNotifications,
        showRsvpsPublicly: showRsvpsPublicly ?? this.showRsvpsPublicly,
        appearInSearch: appearInSearch ?? this.appearInSearch,
      );

  factory SettingsState.fromPrefs(SharedPreferences prefs) => SettingsState(
        eventsNotifications: prefs.getBool('notif_events') ?? true,
        opportunitiesNotifications: prefs.getBool('notif_opportunities') ?? true,
        communitiesNotifications: prefs.getBool('notif_communities') ?? true,
        dmsNotifications: prefs.getBool('notif_dms') ?? true,
        mentionsNotifications: prefs.getBool('notif_mentions') ?? true,
        showRsvpsPublicly: prefs.getBool('privacy_rsvps') ?? true,
        appearInSearch: prefs.getBool('privacy_search') ?? true,
      );
}

// Keys

const _kNotifEvents = 'notif_events';
const _kNotifOpportunities = 'notif_opportunities';
const _kNotifCommunities = 'notif_communities';
const _kNotifDms = 'notif_dms';
const _kNotifMentions = 'notif_mentions';
const _kPrivacyRsvps = 'privacy_rsvps';
const _kPrivacySearch = 'privacy_search';


class SettingsNotifier extends AsyncNotifier<SettingsState> {
  @override
  Future<SettingsState> build() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsState.fromPrefs(prefs);
  }

  Future<void> setEventsNotifications(bool value) =>
      _set(_kNotifEvents, value, (s) => s.copyWith(eventsNotifications: value));

  Future<void> setOpportunitiesNotifications(bool value) =>
      _set(_kNotifOpportunities, value, (s) => s.copyWith(opportunitiesNotifications: value));

  Future<void> setCommunitiesNotifications(bool value) =>
      _set(_kNotifCommunities, value, (s) => s.copyWith(communitiesNotifications: value));

  Future<void> setDmsNotifications(bool value) =>
      _set(_kNotifDms, value, (s) => s.copyWith(dmsNotifications: value));

  Future<void> setMentionsNotifications(bool value) =>
      _set(_kNotifMentions, value, (s) => s.copyWith(mentionsNotifications: value));

  Future<void> setShowRsvpsPublicly(bool value) =>
      _set(_kPrivacyRsvps, value, (s) => s.copyWith(showRsvpsPublicly: value));

  Future<void> setAppearInSearch(bool value) =>
      _set(_kPrivacySearch, value, (s) => s.copyWith(appearInSearch: value));

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = const AsyncData(SettingsState());
  }

  Future<void> _set(
    String key,
    bool value,
    SettingsState Function(SettingsState) updater,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    state = AsyncData(updater(state.requireValue));
  }
}

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
