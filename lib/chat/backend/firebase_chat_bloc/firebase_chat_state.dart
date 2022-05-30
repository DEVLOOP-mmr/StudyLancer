// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/chat/type/message.dart';
import 'package:elite_counsel/chat/type/room.dart';

class FirebaseChatState extends Equatable {
  final List<Room>? rooms;
  final LoadState? loadState;
  Map<String, List<Message>?> roomMessages;
  final int totalUnreadMessageCount;
  FirebaseChatState({
    this.rooms,
    this.loadState,
    required this.nonce,
    required this.totalUnreadMessageCount,
    required this.roomMessages,
  });

  /// A unique string to identify for a new message
  ///
  /// Since roomMessages is a Map, bloc state does not recognize map value change as a state change.
  String nonce;

  @override
  List<Object?> get props =>
      [rooms, loadState, roomMessages, totalUnreadMessageCount, nonce];

  FirebaseChatState copyWith({
    List<Room>? rooms,
    LoadState? loadState,
    Map<String, List<Message>?>? roomMessages,
    int? totalMessageCount,
    String? nonce,
  }) {
    return FirebaseChatState(
      rooms: rooms ?? this.rooms,
      loadState: loadState ?? this.loadState,
      roomMessages: roomMessages ?? this.roomMessages,
      totalUnreadMessageCount: totalMessageCount ?? totalUnreadMessageCount,
      nonce: nonce ?? this.nonce,
    );
  }
}
