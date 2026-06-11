enum CommunityCategory { academic, social, professional, sports, arts, service }

class CommunityModel {
  final String id;
  final String name;
  final String description;
  final CommunityCategory category;
  final String? coverImageUrl;
  final List<String> adminIds;
  final List<String> memberIds;
  final bool isPrivate;
  final DateTime createdAt;

  const CommunityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.coverImageUrl,
    required this.adminIds,
    required this.memberIds,
    required this.isPrivate,
    required this.createdAt,
  });

  int get memberCount => memberIds.length;

  CommunityModel copyWith({List<String>? memberIds}) => CommunityModel(
        id: id,
        name: name,
        description: description,
        category: category,
        coverImageUrl: coverImageUrl,
        adminIds: adminIds,
        memberIds: memberIds ?? this.memberIds,
        isPrivate: isPrivate,
        createdAt: createdAt,
      );
}
