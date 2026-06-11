enum MessageType { text, image, file, system }
enum ChatType { event, community, announcement, direct }

class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final Map<String, List<String>> reactions;
  final String? replyToId;

  const MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.type,
    required this.timestamp,
    this.reactions = const {},
    this.replyToId,
  });
}

class ChatModel {
  final String id;
  final ChatType type;
  final String name;
  final List<String> memberIds;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String? eventId;
  final String? communityId;

  const ChatModel({
    required this.id,
    required this.type,
    required this.name,
    required this.memberIds,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    this.eventId,
    this.communityId,
  });
}
