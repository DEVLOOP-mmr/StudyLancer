import 'package:equatable/equatable.dart';

import 'package:elite_counsel/chat/type/flutter_chat_types.dart';
import 'package:elite_counsel/models/document.dart';

class ProfileDocumentsState extends Equatable {
  final String userType;
  final Map<Room, List<Document>> chatDocuments;
  final String nonce;
  ProfileDocumentsState({
    required this.userType,
    required this.chatDocuments,
    required this.nonce,
  });

  ProfileDocumentsState copyWith({
    String? userType,
    Map<Room, List<Document>>? chatDocuments,
    String? nonce,
  }) {
    return ProfileDocumentsState(
      userType: userType ?? this.userType,
      chatDocuments: chatDocuments ?? this.chatDocuments,
      nonce: nonce ?? this.nonce,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userType': userType,
      'chatDocuments': chatDocuments,
    };
  }

  @override
  List<Object> get props => [userType, chatDocuments, nonce];
}
