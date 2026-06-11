enum UserRole { student, clubLeader, eventOrganiser, academicTeam }

class UserModel {
  final String id, fullName, email, campus;
  final UserRole role;
  final String? avatarUrl;
  final List<String> interests, rsvpedEventIds, savedEventIds, communityIds;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.campus,
    required this.role,
    this.avatarUrl,
    this.interests = const [],
    this.rsvpedEventIds = const [],
    this.savedEventIds = const [],
    this.communityIds = const [],
  });

  String get initials {
    final p = fullName.trim().split(' ');
    return p.length >= 2
        ? '${p[0][0]}${p[1][0]}'.toUpperCase()
        : p[0][0].toUpperCase();
  }

  String get roleLabel {
    switch (role) {
      case UserRole.student:        return 'Student';
      case UserRole.clubLeader:     return 'Club Leader';
      case UserRole.eventOrganiser: return 'Event Organiser';
      case UserRole.academicTeam:   return 'Academic Team';
    }
  }

  bool get canPost => role != UserRole.student;

  UserModel copyWith({
    String? fullName, String? email, String? campus, UserRole? role,
    String? avatarUrl, List<String>? interests, List<String>? rsvpedEventIds,
    List<String>? savedEventIds, List<String>? communityIds,
  }) =>
      UserModel(
        id: id,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        campus: campus ?? this.campus,
        role: role ?? this.role,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        interests: interests ?? this.interests,
        rsvpedEventIds: rsvpedEventIds ?? this.rsvpedEventIds,
        savedEventIds: savedEventIds ?? this.savedEventIds,
        communityIds: communityIds ?? this.communityIds,
      );
}

enum EventCategory { all, events, workshops, internships, hackathons, leadership }

class EventModel {
  final String id, title, organiser, description, date, time, location, tag;
  final EventCategory category;
  final int totalSeats;
  int registeredCount;
  final String? imageColor;
  final bool isFeatured;

  EventModel({
    required this.id,
    required this.title,
    required this.organiser,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.category,
    required this.tag,
    required this.totalSeats,
    this.registeredCount = 0,
    this.imageColor,
    this.isFeatured = false,
  });

  int get seatsLeft => totalSeats - registeredCount;
  bool get isFull => seatsLeft <= 0;

  String get categoryLabel {
    switch (category) {
      case EventCategory.all:         return 'All';
      case EventCategory.events:      return 'Events';
      case EventCategory.workshops:   return 'Workshop';
      case EventCategory.internships: return 'Internship';
      case EventCategory.hackathons:  return 'Hackathon';
      case EventCategory.leadership:  return 'Leadership';
    }
  }
}

class CommunityModel {
  final String id, name, description, category, avatarColor;
  final int memberCount;
  bool isJoined;
  String lastMessage, lastMessageTime;
  int unreadCount;

  CommunityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.memberCount,
    required this.avatarColor,
    this.isJoined = false,
    this.lastMessage = '',
    this.lastMessageTime = '',
    this.unreadCount = 0,
  });
}

class MessageModel {
  final String id, senderId, senderName, senderInitials, content;
  final DateTime timestamp;
  final bool isMe;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderInitials,
    required this.content,
    required this.timestamp,
    required this.isMe,
  });
}

class IdeaModel {
  final String id, title, description, authorName, authorInitials, stage, domain;
  final List<String> skills;
  int backerCount;
  bool isBacked;

  IdeaModel({
    required this.id,
    required this.title,
    required this.description,
    required this.authorName,
    required this.authorInitials,
    required this.skills,
    required this.stage,
    required this.domain,
    this.backerCount = 0,
    this.isBacked = false,
  });
}
