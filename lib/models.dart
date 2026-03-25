class MatchCardData {
  const MatchCardData({
    required this.id,
    required this.title,
    required this.location,
    required this.scheduledAt,
    required this.level,
    required this.timeTag,
    required this.roleFocus,
    required this.surface,
    required this.capacity,
    required this.joinedCount,
    required this.hostType,
    required this.notes,
    required this.hostName,
    required this.hostRating,
    required this.distanceKm,
    this.createdByUser = false,
  });

  final String id;
  final String title;
  final String location;
  final DateTime scheduledAt;
  final String level;
  final String timeTag;
  final String roleFocus;
  final String surface;
  final int capacity;
  final int joinedCount;
  final String hostType;
  final String notes;
  final String hostName;
  final double hostRating;
  final double distanceKm;
  final bool createdByUser;

  List<String> get tags => [timeTag, '$roleFocus 모집', surface];

  MatchCardData copyWith({int? joinedCount}) {
    return MatchCardData(
      id: id,
      title: title,
      location: location,
      scheduledAt: scheduledAt,
      level: level,
      timeTag: timeTag,
      roleFocus: roleFocus,
      surface: surface,
      capacity: capacity,
      joinedCount: joinedCount ?? this.joinedCount,
      hostType: hostType,
      notes: notes,
      hostName: hostName,
      hostRating: hostRating,
      distanceKm: distanceKm,
      createdByUser: createdByUser,
    );
  }
}

class PlayerProfile {
  const PlayerProfile({
    required this.position,
    required this.skill,
    required this.timePreference,
  });

  final String position;
  final String skill;
  final String timePreference;

  PlayerProfile copyWith({
    String? position,
    String? skill,
    String? timePreference,
  }) {
    return PlayerProfile(
      position: position ?? this.position,
      skill: skill ?? this.skill,
      timePreference: timePreference ?? this.timePreference,
    );
  }
}

enum MatchFilter {
  all('전체'),
  beginner('초급'),
  intermediate('중급'),
  night('야간');

  const MatchFilter(this.label);
  final String label;
}
