import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/rsvp_entry.dart';
import '../../../mock/stub_event.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/rsvp_provider.dart';
import '../widgets/rsvp_card.dart';

class MyRsvpsScreen extends ConsumerStatefulWidget {
  const MyRsvpsScreen({super.key});

  @override
  ConsumerState<MyRsvpsScreen> createState() => _MyRsvpsScreenState();
}

class _MyRsvpsScreenState extends ConsumerState<MyRsvpsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        surfaceTintColor: Colors.transparent,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: AppColors.textPrimary, size: 18),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text('My RSVPs',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.gold,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.gold,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: AppColors.border,
          tabs: const [
            Tab(text: 'Going'),
            Tab(text: 'Interested'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: ref.watch(rsvpProvider).when(
            loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.gold)),
            error: (e, _) => Center(
                child: Text('Error: $e',
                    style: const TextStyle(color: AppColors.danger))),
            data: (entries) {
              final notifier = ref.read(rsvpProvider.notifier);
              final going = notifier.going(entries);
              final interested = notifier.interested(entries);
              final past = notifier.past(entries);
              return TabBarView(
                controller: _tabController,
                children: [
                  _GoingList(entries: going),
                  _InterestedList(entries: interested),
                  _PastList(entries: past),
                ],
              );
            },
          ),
    );
  }
}


class _GoingList extends ConsumerWidget {
  final List<RsvpEntry> entries;

  const _GoingList({required this.entries});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (entries.isEmpty) return _empty('No upcoming events. Browse and RSVP!');

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: entries.length,
      itemBuilder: (_, i) {
        final entry = entries[i];
        final event = _eventFor(entry.eventId);
        if (event == null) return const SizedBox.shrink();

        return Dismissible(
          key: Key('going_${entry.eventId}'),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) => _confirmCancel(context),
          onDismissed: (_) =>
              ref.read(rsvpProvider.notifier).cancelRsvp(entry.eventId),
          background: _swipeBackground(),
          child: RsvpCard(entry: entry, event: event),
        );
      },
    );
  }
}


class _InterestedList extends ConsumerWidget {
  final List<RsvpEntry> entries;

  const _InterestedList({required this.entries});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (entries.isEmpty) {
      return _empty('Nothing marked as interested yet.');
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: entries.length,
      itemBuilder: (_, i) {
        final entry = entries[i];
        final event = _eventFor(entry.eventId);
        if (event == null) return const SizedBox.shrink();

        final daysUntil =
            event.startTime.difference(DateTime.now()).inDays;
        final showNudge =
            daysUntil <= 3 && event.startTime.isAfter(DateTime.now());

        return Column(
          children: [
            Dismissible(
              key: Key('interested_${entry.eventId}'),
              direction: DismissDirection.endToStart,
              confirmDismiss: (_) => _confirmCancel(context),
              onDismissed: (_) =>
                  ref.read(rsvpProvider.notifier).cancelRsvp(entry.eventId),
              background: _swipeBackground(),
              child: RsvpCard(entry: entry, event: event),
            ),
            if (showNudge)
              _NudgeBanner(
                onConfirm: () => ref
                    .read(rsvpProvider.notifier)
                    .rsvpEvent(entry.eventId, RsvpStatus.going),
              ),
          ],
        );
      },
    );
  }
}


class _PastList extends StatelessWidget {
  final List<RsvpEntry> entries;

  const _PastList({required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return _empty('No past events yet.');

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: entries.length,
      itemBuilder: (_, i) {
        final event = _eventFor(entries[i].eventId);
        if (event == null) return const SizedBox.shrink();
        return RsvpCard(entry: entries[i], event: event, dimmed: true);
      },
    );
  }
}


class _NudgeBanner extends StatelessWidget {
  final VoidCallback onConfirm;

  const _NudgeBanner({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.goldMuted,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.gold, size: 16),
          const SizedBox(width: 8),
          const Expanded(
            child: Text('This event is coming up soon!',
                style: TextStyle(color: AppColors.gold, fontSize: 12)),
          ),
          GestureDetector(
            onTap: onConfirm,
            child: const Text(
              'Confirm going →',
              style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}


EventModel? _eventFor(String id) {
  try {
    return mockEvents.firstWhere((e) => e.id == id);
  } catch (_) {
    return null;
  }
}

Future<bool?> _confirmCancel(BuildContext context) => showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgElevated,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Cancel RSVP',
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        content: const Text('Remove this event from your schedule?',
            style:
                TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep it',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cancel RSVP',
                style: TextStyle(
                    color: AppColors.danger, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

Widget _swipeBackground() => Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 24),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cancel_outlined, color: AppColors.danger, size: 22),
          SizedBox(height: 4),
          Text('Cancel',
              style: TextStyle(color: AppColors.danger, fontSize: 11)),
        ],
      ),
    );

Widget _empty(String message) => Center(
      child: Text(message,
          style: const TextStyle(color: AppColors.textSecondary)),
    );
