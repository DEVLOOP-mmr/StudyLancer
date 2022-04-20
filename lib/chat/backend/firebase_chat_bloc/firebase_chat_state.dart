// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/chat/type/room.dart';

class FirebaseChatState extends Equatable {
  final List<Room> rooms;
  final LoadState loadState;
  const FirebaseChatState({
    this.rooms,
    this.loadState,
  });

  @override
  List<Object> get props => [rooms, loadState];

  FirebaseChatState copyWith({
    List<Room> rooms,
    LoadState loadState,
  }) {
    return FirebaseChatState(
      rooms: rooms ?? this.rooms,
      loadState: loadState ?? this.loadState,
    );
  }
}
