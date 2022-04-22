// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import 'package:elite_counsel/models/study_lancer_user.dart';

import 'user.dart';

/// All possible room types
enum RoomType { direct, group }

/// A class that represents a room where 2 or more participants can chat
@immutable
class Room {
  /// Creates a [Room]
  const Room({
    @required this.id,
    this.imageUrl,
    this.metadata,
    this.name,
    @required this.type,
    @required this.users,
  });

  /// Room's unique ID
  final String id;

  /// Room's image. In case of the [RoomType.direct] - avatar of the second person,
  /// otherwise a custom image [RoomType.group].
  final String imageUrl;

  /// Type of the room, direct, group etc.
  final RoomType type;

  /// Additional custom metadata or attributes related to the room
  final Map<String, dynamic> metadata;

  /// Room's name. In case of the [RoomType.direct] - name of the second person,
  /// otherwise a custom name [RoomType.group].
  final String name;

  /// List of users which are in the room
  final List<StudyLancerUser> users;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Room &&
        other.id == id &&
        other.imageUrl == imageUrl &&
        other.type == type &&
        mapEquals(other.metadata, metadata) &&
        other.name == name &&
        listEquals(other.users, users);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        imageUrl.hashCode ^
        type.hashCode ^
        metadata.hashCode ^
        name.hashCode ^
        users.hashCode;
  }
}
