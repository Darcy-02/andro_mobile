import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user_model.dart';
import '../../../mock/users.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/current_user_provider.dart';
import '../providers/connections_provider.dart';
import '../widgets/connection_card.dart';
import 'profile_screen.dart';

class ConnectionsScreen extends ConsumerStatefulWidget {
  final String userId;

  const ConnectionsScreen({super.key, required this.userId});

  @override
  ConsumerState<ConnectionsScreen> createState() =>
      _ConnectionsScreenState();
}

class _ConnectionsScreenState extends ConsumerState<ConnectionsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchCtrl.addListener(() => setState(() => _query = _searchCtrl.text));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  bool get _isOwnProfile =>
      widget.userId == ref.read(currentUserProvider).id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Connections',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        bottom: _isOwnProfile
            ? TabBar(
                controller: _tabController,
                labelColor: AppColors.accent,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.accent,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: AppColors.border,
                tabs: const [
                  Tab(text: 'My Connections'),
                  Tab(text: 'Pending'),
                ],
              )
            : null,
      ),
      body: Column(
        children: [
          _searchBar(),
          Expanded(
            child: _isOwnProfile
                ? TabBarView(
                    controller: _tabController,
                    children: [
                      _MyConnectionsList(query: _query),
                      _PendingList(query: _query),
                    ],
                  )
                : _OtherUserConnectionsList(
                    userId: widget.userId, query: _query),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: TextField(
          controller: _searchCtrl,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Search by name or programme…',
            hintStyle:
                const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            prefixIcon: const Icon(Icons.search,
                color: AppColors.textSecondary, size: 20),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close,
                        color: AppColors.textSecondary, size: 18),
                    onPressed: () => _searchCtrl.clear(),
                  )
                : null,
            filled: true,
            fillColor: AppColors.bgSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.accent),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
        ),
      );
}


class _MyConnectionsList extends ConsumerWidget {
  final String query;

  const _MyConnectionsList({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connections = ref.watch(connectionsProvider);
    final connectedIds = connections.connectedIds;
    final users = mockUsers
        .where((u) => connectedIds.contains(u.id))
        .where((u) => _matches(u, query))
        .toList();

    if (users.isEmpty) {
      return _empty(
          query.isNotEmpty ? 'No results for "$query"' : 'No connections yet.');
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: users.length,
      itemBuilder: (_, i) => ConnectionCard(
        user: users[i],
        status: ConnectionStatus.connected,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ProfileScreen(userId: users[i].id)),
        ),
      ),
    );
  }
}


class _PendingList extends ConsumerWidget {
  final String query;

  const _PendingList({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connections = ref.watch(connectionsProvider);
    final notifier = ref.read(connectionsProvider.notifier);

    final incoming = mockUsers
        .where((u) => connections.incomingRequests.contains(u.id))
        .where((u) => _matches(u, query))
        .toList();

    final outgoing = mockUsers
        .where((u) => connections.sentPendingIds.contains(u.id))
        .where((u) => _matches(u, query))
        .toList();

    if (incoming.isEmpty && outgoing.isEmpty) {
      return _empty(query.isNotEmpty
          ? 'No results for "$query"'
          : 'No pending requests.');
    }

    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      children: [
        if (incoming.isNotEmpty) ...[
          _subHeader('Received'),
          ...incoming.map((u) => _IncomingCard(user: u, notifier: notifier)),
        ],
        if (outgoing.isNotEmpty) ...[
          _subHeader('Sent'),
          ...outgoing.map(
            (u) => ConnectionCard(
              user: u,
              status: ConnectionStatus.pending,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfileScreen(userId: u.id)),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _subHeader(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.8),
        ),
      );
}

class _IncomingCard extends StatelessWidget {
  final UserModel user;
  final ConnectionsNotifier notifier;

  const _IncomingCard({required this.user, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.accentMuted,
            child: Text(user.fullName[0],
                style: const TextStyle(
                    color: AppColors.accent, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.fullName,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
                Text(user.programme,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => notifier.accept(user.id),
            child: _pill('Accept', AppColors.accent, AppColors.bgPrimary),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => notifier.decline(user.id),
            child: _pill(
                'Decline', AppColors.bgElevated, AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _pill(String label, Color bg, Color fg) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(
                color: fg, fontSize: 12, fontWeight: FontWeight.w500)),
      );
}


class _OtherUserConnectionsList extends ConsumerWidget {
  final String userId;
  final String query;

  const _OtherUserConnectionsList(
      {required this.userId, required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileUser =
        mockUsers.firstWhere((u) => u.id == userId, orElse: () => mockUsers[0]);
    final connections = ref.watch(connectionsProvider);

    final users = mockUsers
        .where((u) => profileUser.connectionIds.contains(u.id))
        .where((u) => _matches(u, query))
        .toList();

    if (users.isEmpty) {
      return _empty(query.isNotEmpty
          ? 'No results for "$query"'
          : 'No connections yet.');
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: users.length,
      itemBuilder: (_, i) => ConnectionCard(
        user: users[i],
        status: connections.statusFor(users[i].id),
        onConnect: () =>
            ref.read(connectionsProvider.notifier).connect(users[i].id),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ProfileScreen(userId: users[i].id)),
        ),
      ),
    );
  }
}


bool _matches(UserModel u, String query) {
  if (query.isEmpty) return true;
  final q = query.toLowerCase();
  return u.fullName.toLowerCase().contains(q) ||
      u.programme.toLowerCase().contains(q);
}

Widget _empty(String message) => Center(
      child: Text(message,
          style: const TextStyle(color: AppColors.textSecondary)),
    );
