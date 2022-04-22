import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/chat/backend/firebase_chat_bloc/firebase_chat_state.dart';
import 'package:elite_counsel/chat/type/flutter_chat_types.dart' as types;
import 'package:elite_counsel/models/study_lancer_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../backend_util.dart';

/// Provides access to Firebase chat data. Singleton, use
/// FirebaseChatCore.instance to access methods.
class FirebaseChatBloc extends Cubit<FirebaseChatState> {
  FirebaseChatBloc({this.homeBloc})
      : super(
          const FirebaseChatState(rooms: [], loadState: LoadState.initial),
        ) {
          FirebaseAuth.instance.userChanges().listen((event) { if(event!=null){
              user = FirebaseAuth.instance.currentUser;
          } });
  
    roomSnapshotsStream = null;
    homeBloc.stream.listen((state) {
      if (state.loadState == LoadState.done) {
        if (state is AgentHomeState) {
          var agentState = state;
          fetchRooms(agentState.agent);
        } else if (state is StudentHomeState) {
          var studentState = state;
          fetchRooms(studentState.student);
        }
      }
    });
  }

  HomeBloc homeBloc;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> roomSnapshotsStream;
  User user;

  // FirebaseChatCore._privateConstructor() {
  //   user = FirebaseAuth.instance.currentUser;
  // }

  void resetLoginData() async {
    user = null;

    emit(const FirebaseChatState(rooms: [], loadState: LoadState.initial));
    await roomSnapshotsStream.cancel();
    roomSnapshotsStream = null;
  }

  void setUserData() {
    user = FirebaseAuth.instance.currentUser;
  }

  // static final FirebaseChatCore instance =
  //     FirebaseChatCore._privateConstructor();

  Future<types.Room> createGroupRoom({
    String imageUrl,
    Map<String, dynamic> metadata,
    @required String name,
    @required List<StudyLancerUser> users,
  }) async {
    if (user == null) return Future.error('User does not exist');

    final currentUser = await fetchUser(user.uid);
    final roomUsers = [currentUser] + users;

    final room = await FirebaseFirestore.instance.collection('rooms').add({
      'imageUrl': imageUrl,
      'metadata': metadata,
      'name': name,
      'type': 'group',
      'userIds': roomUsers.map((u) => u.id).toList(),
    });

    return types.Room(
      id: room.id,
      imageUrl: imageUrl,
      metadata: metadata,
      name: name,
      type: types.RoomType.group,
      users: roomUsers,
    );
  }

  /// Creates a direct chat for 2 people. Add [metadata] for any additional
  /// custom data.
  Future<types.Room> createRoom(
    StudyLancerUser currentUser,
    StudyLancerUser otherUser, {
    Map<String, dynamic> metadata,
  }) async {
    if (currentUser == null) return Future.error('User does not exist');

    final query = await FirebaseFirestore.instance
        .collection('rooms')
        .where('userIds', arrayContains: currentUser.id)
        .get();

    final rooms = await processRoomsQuery(currentUser, query);

    try {
      return rooms.firstWhere((room) {
        if (room.type == types.RoomType.group) return false;

        final userIds = room.users.map((u) => u.id);
        return userIds.contains(user.uid) && userIds.contains(otherUser.id);
      });
    } catch (e) {
      // Do nothing if room does not exist
      // Create a new room instead
    }

    otherUser = await fetchUser(otherUser.id);
    final users = [currentUser, otherUser];
    final room = await FirebaseFirestore.instance.collection('rooms').add({
      'imageUrl': null,
      'metadata': metadata,
      'name': null,
      'type': 'direct',
      'userData': {
        currentUser.id: {
          'name': currentUser.name,
          'imageUrl': currentUser.photo,
        },
        otherUser.id: {
          'name': otherUser.name,
          'imageUrl': otherUser.photo,
        },
      },
      'userIds': users.map((u) => u.id).toList(),
    });

    return types.Room(
      name: otherUser.name,
      imageUrl: otherUser.photo,
      id: room.id,
      metadata: metadata,
      type: types.RoomType.direct,
      users: users,
    );
  }

  Future<types.Room> getRoomDetail(String roomId) async {
    if (user == null) return Future.error('User does not exist');

    final doc =
        await FirebaseFirestore.instance.collection('rooms').doc(roomId).get();

    String imageUrl;
    Map<String, dynamic> metadata;
    String name;

    try {
      imageUrl = doc.get('imageUrl') as String;
      metadata = doc.get('metadata') as Map<String, dynamic>;
      name = doc.get('name') as String;
    } catch (e) {
      // Ignore errors since all those fields are optional
    }

    final type = doc.get('type') as String;
    final userIds = doc.get('userIds') as List<dynamic>;

    final users = await Future.wait(
      userIds.map(
        (userId) => fetchUser(userId as String),
      ),
    );

    if (type == 'direct') {
      try {
        final otherUser = users.firstWhere(
          (u) => u.id != user.uid,
        );

        imageUrl = otherUser.photo;
        name = otherUser.name;
      } catch (e) {
        // Do nothing if other user is not found, because he should be found.
        // Consider falling back to some default values.
      }
    }

    final room = types.Room(
      id: doc.id,
      imageUrl: imageUrl,
      metadata: metadata,
      name: name,
      type: type == 'direct' ? types.RoomType.direct : types.RoomType.group,
      users: users,
    );

    return room;
  }

  /// Creates [types.User] in Firebase to store name and avatar used on
  /// rooms list
  Future<void> createUserInFirestore(types.User user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.id).set({
      'avatarUrl': user.avatarUrl,
      'firstName': user.firstName,
      'lastName': user.lastName,
    });
  }

  /// Returns a stream of messages from Firebase for a given room
  Stream<List<types.Message>> messages(String roomId) {
    return FirebaseFirestore.instance
        .collection('rooms/$roomId/messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.fold<List<types.Message>>(
          [],
          (previousValue, element) {
            final data = element.data();
            data['id'] = element.id;
            data['timestamp'] = element['timestamp'].seconds;
            return [...previousValue, types.Message.fromJson(data)];
          },
        );
      },
    );
  }

  /// Emits a stream of rooms from Firebase. Only rooms where current
  /// logged in user exist are returned.
  void fetchRooms(StudyLancerUser currentUser) {
    if (currentUser == null) {
      return;
    }

    var snapshots = FirebaseFirestore.instance
        .collection('rooms')
        .where(
          'userIds',
          arrayContains: currentUser.id,
        )
        .snapshots();
    roomSnapshotsStream ??= snapshots.listen((query) async {
      final rooms = await processRoomsQuery(currentUser, query);
      emit(state.copyWith(rooms: rooms, loadState: LoadState.done));
    });
  }

  /// Sends a message to the Firestore. Accepts any partial message and a
  /// room ID. If arbitrary data is provided in the [partialMessage]
  /// does nothing.
  void sendMessage(dynamic partialMessage, String roomId) async {
    if (user == null) return;

    types.Message message;

    if (partialMessage is types.PartialFile) {
      message = types.FileMessage.fromPartial(
        authorId: user.uid,
        id: '',
        partialFile: partialMessage,
      );
    } else if (partialMessage is types.PartialImage) {
      message = types.ImageMessage.fromPartial(
        authorId: user.uid,
        id: '',
        partialImage: partialMessage,
      );
    } else if (partialMessage is types.PartialText) {
      message = types.TextMessage.fromPartial(
        authorId: user.uid,
        id: '',
        partialText: partialMessage,
      );
    }

    if (message != null) {
      final messageMap = message.toJson();
      messageMap.removeWhere((key, value) => key == 'id');
      messageMap['timestamp'] = FieldValue.serverTimestamp();

      await FirebaseFirestore.instance
          .collection('rooms/$roomId/messages')
          .add(messageMap);
    }
  }

  /// Updates a message in the Firestore. Accepts any message and a
  /// room ID. Message will probably be taken from the [messages] stream.
  void updateMessage(types.Message message, String roomId) async {
    if (user == null) return;
    if (message.authorId == user.uid) return;

    final messageMap = message.toJson();
    messageMap.removeWhere((key, value) => key == 'id' || key == 'timestamp');

    await FirebaseFirestore.instance
        .collection('rooms/$roomId/messages')
        .doc(message.id)
        .update(messageMap);
  }

  /// Returns a stream of all users from Firebase
  Stream<List<types.User>> users() {
    if (user == null) return const Stream.empty();
    return FirebaseFirestore.instance.collection('users').snapshots().map(
          (snapshot) => snapshot.docs.fold<List<types.User>>(
            [],
            (previousValue, element) {
              if (user.uid == element.id) return previousValue;

              return [...previousValue, processUserDocument(element)];
            },
          ),
        );
  }
}
