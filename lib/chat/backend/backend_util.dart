import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elite_counsel/bloc/profile_bloc.dart';
import 'package:elite_counsel/chat/type/flutter_chat_types.dart' as types;
import 'package:elite_counsel/models/study_lancer_user.dart';
import 'package:elite_counsel/variables.dart';

/// Fetches user from MongoDB databsse and returs either a [Student] or [Agent]
Future<StudyLancerUser> fetchUser(String userId) async {
  final currentUserType = Variables.sharedPreferences.get(Variables.userType);
  var userType = '';
  userType = currentUserType == 'student' ? 'agent' : 'student';
  var user = ProfileBloc.getUserProfile(userType: userType, uid: userId);

  return user;
}

/// Returns a list of [types.Room] created from Firebase query.
/// If room has 2 participants, sets correct room name and image.
Future<List<types.Room>> processRoomsQuery(
  StudyLancerUser currentUser,
  QuerySnapshot query,
) async {
  final futures = query.docs.map((doc) async {
    String imageUrl;
    Map<String, dynamic> metadata;
    String name;

    final type = doc.get('type') as String;
    final List<dynamic> userIds = doc.get('userIds') as List<dynamic>;

    final List<StudyLancerUser> users = [currentUser];
    String otherUserID =
        userIds.firstWhere((element) => element != currentUser.id);
    final otherUser = StudyLancerUser(id: otherUserID);
    users.add(otherUser);

    if (type == "direct") {
      Map<String, dynamic> map = doc.data();
      if (map['userData'] != null) {
        imageUrl = map['userData'][otherUserID]['imageUrl'];
        name = map['userData'][otherUserID]['name'];
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
  });

  return await Future.wait(futures);
}

/// Returns a [types.User] created from Firebase document
types.User processUserDocument(DocumentSnapshot doc) {
  Map<String, dynamic> jsonDocData = doc.data();
  if (jsonDocData == null) {
    return types.User(id: doc.id);
  }
  if (jsonDocData.keys.isEmpty) {
    return types.User(id: doc.id);
  }
  final avatarUrl = (jsonDocData['avatarUrl'] ?? "") as String;
  final firstName = (jsonDocData['firstName'] ?? "") as String;
  final lastName = (jsonDocData['lastName'] ?? "") as String;

  final user = types.User(
    avatarUrl: avatarUrl,
    firstName: firstName,
    id: doc.id,
    lastName: lastName,
  );

  return user;
}
