import 'package:flutter/foundation.dart';

enum UserRole { student, clubLeader, organiser, staff, admin }

@immutable
class UserModel {
  final String id;
  final String fullName;
  final String preferredName;
  final String email;
  final String programme;
  final int graduationYear;
  final String? bio;
  final String? avatarUrl;
  final List<String> interestTags;
  final String campus;
  final UserRole role;
  final int eventsAttended;
  final List<String> communityIds;
  final List<String> connectionIds;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.preferredName,
    required this.email,
    required this.programme,
    required this.graduationYear,
    this.bio,
    this.avatarUrl,
    required this.interestTags,
    this.campus = 'Kigali',
    required this.role,
    this.eventsAttended = 0,
    required this.communityIds,
    required this.connectionIds,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? preferredName,
    String? email,
    String? programme,
    int? graduationYear,
    String? bio,
    String? avatarUrl,
    List<String>? interestTags,
    String? campus,
    UserRole? role,
    int? eventsAttended,
    List<String>? communityIds,
    List<String>? connectionIds,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      preferredName: preferredName ?? this.preferredName,
      email: email ?? this.email,
      programme: programme ?? this.programme,
      graduationYear: graduationYear ?? this.graduationYear,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      interestTags: interestTags ?? this.interestTags,
      campus: campus ?? this.campus,
      role: role ?? this.role,
      eventsAttended: eventsAttended ?? this.eventsAttended,
      communityIds: communityIds ?? this.communityIds,
      connectionIds: connectionIds ?? this.connectionIds,
    );
  }
}
