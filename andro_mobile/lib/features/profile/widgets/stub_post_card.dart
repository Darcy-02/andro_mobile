// TODO: swap with feed dev's PostCard

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PostCard extends StatelessWidget {
  final String postId;
  final String authorId;
  final String content;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;

  const PostCard({
    super.key,
    required this.postId,
    required this.authorId,
    required this.content,
    required this.createdAt,
    this.likeCount = 0,
    this.commentCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.favorite_border, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text('$likeCount', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(width: 12),
              const Icon(Icons.chat_bubble_outline, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text('$commentCount', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

// Mock posts
class StubPost {
  final String id;
  final String authorId;
  final String content;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final bool isSaved;

  const StubPost({
    required this.id,
    required this.authorId,
    required this.content,
    required this.createdAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isSaved = false,
  });
}

final List<StubPost> mockPosts = [
  StubPost(
    id: 'p1',
    authorId: 'u1',
    content: 'Just demoed AgriConnect to 3 potential investors at the pitch night. '
        'Incredible feedback — we\'re refining the SMS flow this week.',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    likeCount: 24,
    commentCount: 6,
  ),
  StubPost(
    id: 'p2',
    authorId: 'u1',
    content: 'Reminder: Innovation Week registration closes tomorrow. '
        'Don\'t miss the keynote — it\'s going to be lit 🔥',
    createdAt: DateTime.now().subtract(const Duration(days: 4)),
    likeCount: 38,
    commentCount: 11,
  ),
  StubPost(
    id: 'p3',
    authorId: 'u1',
    content: 'Sharing my notes from the Data Science workshop. '
        'Key takeaway: clean data beats fancy models every single time.',
    createdAt: DateTime.now().subtract(const Duration(days: 12)),
    likeCount: 17,
    commentCount: 3,
  ),
  StubPost(
    id: 'p4',
    authorId: 'u3',
    content: 'EduBridge just hit 500 students on the pilot programme. '
        'What started as a side project is becoming something real.',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    likeCount: 52,
    commentCount: 14,
    isSaved: true,
  ),
  StubPost(
    id: 'p5',
    authorId: 'u6',
    content: 'Innovation Week schedule is out. 14 sessions, 3 keynotes, '
        '1 pitch competition with a ¥500k prize. Register now.',
    createdAt: DateTime.now().subtract(const Duration(days: 6)),
    likeCount: 91,
    commentCount: 22,
    isSaved: true,
  ),
];
