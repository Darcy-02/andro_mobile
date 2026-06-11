import 'package:flutter/foundation.dart';

enum StartupStage { idea, prototype, earlyRevenue }

@immutable
class StartupModel {
  final String id;
  final String name;
  final String pitch;
  final StartupStage stage;
  final String? description;
  final String? pitchDeckUrl;
  final String organiserId;
  final List<String> teamMemberIds;
  final List<String> openRoles;
  final int interestCount;
  final DateTime createdAt;

  const StartupModel({
    required this.id,
    required this.name,
    required this.pitch,
    required this.stage,
    this.description,
    this.pitchDeckUrl,
    required this.organiserId,
    required this.teamMemberIds,
    required this.openRoles,
    this.interestCount = 0,
    required this.createdAt,
  });

  StartupModel copyWith({
    String? id,
    String? name,
    String? pitch,
    StartupStage? stage,
    String? description,
    String? pitchDeckUrl,
    String? organiserId,
    List<String>? teamMemberIds,
    List<String>? openRoles,
    int? interestCount,
    DateTime? createdAt,
  }) {
    return StartupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      pitch: pitch ?? this.pitch,
      stage: stage ?? this.stage,
      description: description ?? this.description,
      pitchDeckUrl: pitchDeckUrl ?? this.pitchDeckUrl,
      organiserId: organiserId ?? this.organiserId,
      teamMemberIds: teamMemberIds ?? this.teamMemberIds,
      openRoles: openRoles ?? this.openRoles,
      interestCount: interestCount ?? this.interestCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
