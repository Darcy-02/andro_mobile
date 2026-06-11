import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/chat_model.dart';
import '../../../mock/chats.dart';

class ChatNotifier extends Notifier<List<ChatModel>> {
  @override
  List<ChatModel> build() => List.from(mockChats)
    ..sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

  List<MessageModel> messagesFor(String chatId) =>
      mockMessages.where((m) => m.chatId == chatId).toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

  void sendMessage(String chatId, String content, String senderId, String senderName) {
    final msg = MessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      chatId: chatId,
      senderId: senderId,
      senderName: senderName,
      content: content,
      type: MessageType.text,
      timestamp: DateTime.now(),
    );
    mockMessages.add(msg);
    state = [
      for (final c in state)
        if (c.id == chatId)
          ChatModel(
            id: c.id,
            type: c.type,
            name: c.name,
            memberIds: c.memberIds,
            lastMessage: content,
            lastMessageTime: msg.timestamp,
            unreadCount: 0,
            eventId: c.eventId,
            communityId: c.communityId,
          )
        else
          c,
    ]..sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
  }

  void markRead(String chatId) {
    state = [
      for (final c in state)
        if (c.id == chatId)
          ChatModel(
            id: c.id,
            type: c.type,
            name: c.name,
            memberIds: c.memberIds,
            lastMessage: c.lastMessage,
            lastMessageTime: c.lastMessageTime,
            unreadCount: 0,
            eventId: c.eventId,
            communityId: c.communityId,
          )
        else
          c,
    ];
  }
}

final chatProvider =
    NotifierProvider<ChatNotifier, List<ChatModel>>(ChatNotifier.new);
