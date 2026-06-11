import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/chat_model.dart';
import '../providers/chat_provider.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatProvider);
    final totalUnread = chats.fold<int>(0, (sum, c) => sum + c.unreadCount);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('Chats',
                          style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w600)),
                      if (totalUnread > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('$totalUnread',
                              style: const TextStyle(
                                  color: AppColors.bgPrimary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ],
                  ),
                  const Icon(Icons.search,
                      color: AppColors.textSecondary, size: 22),
                ],
              ),
            ),
            const Divider(color: AppColors.border, height: 1),
            Expanded(
              child: chats.isEmpty
                  ? _empty()
                  : ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (_, i) => _ChatRow(chat: chats[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _empty() => const Center(
        child: Text('No chats yet.',
            style: TextStyle(color: AppColors.textSecondary)),
      );
}

class _ChatRow extends ConsumerWidget {
  final ChatModel chat;

  const _ChatRow({required this.chat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(chatProvider.notifier).markRead(chat.id);
        context.push('/chats/${chat.id}');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            _avatar(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(chat.name,
                            style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      Text(
                        _timeLabel(chat.lastMessageTime),
                        style: TextStyle(
                            color: chat.unreadCount > 0
                                ? AppColors.gold
                                : AppColors.textSecondary,
                            fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(chat.lastMessage,
                            style: TextStyle(
                                color: chat.unreadCount > 0
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: chat.unreadCount > 0
                                    ? FontWeight.w400
                                    : FontWeight.w300),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      if (chat.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                              color: AppColors.gold, shape: BoxShape.circle),
                          child: Center(
                            child: Text('${chat.unreadCount}',
                                style: const TextStyle(
                                    color: AppColors.bgPrimary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar() {
    IconData icon;
    switch (chat.type) {
      case ChatType.event:
        icon = Icons.event_outlined;
        break;
      case ChatType.announcement:
        icon = Icons.campaign_outlined;
        break;
      case ChatType.direct:
        icon = Icons.person_outline;
        break;
      default:
        icon = Icons.groups_outlined;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.goldMuted,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Icon(icon, color: AppColors.gold, size: 20),
    );
  }

  String _timeLabel(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return DateFormat('EEE').format(t);
    return DateFormat('d MMM').format(t);
  }
}
