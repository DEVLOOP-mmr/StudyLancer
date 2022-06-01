import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:elite_counsel/chat/type/flutter_chat_types.dart';
import 'package:elite_counsel/models/document.dart';

class ProfileDocumentsState extends Equatable {
  final String userType;
  final Map<Room, List<Document>> chatDocuments;
  ProfileDocumentsState({
    required this.userType,
    required this.chatDocuments,
  });

  ProfileDocumentsState copyWith({
    String? userType,
    Map<Room, List<Document>>? chatDocuments,
  }) {
    return ProfileDocumentsState(
      userType: userType ?? this.userType,
      chatDocuments: chatDocuments ?? this.chatDocuments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userType': userType,
      'chatDocuments': chatDocuments,
    };
  }

  factory ProfileDocumentsState.fromMap(Map<String, dynamic> map) {
    return ProfileDocumentsState(
      userType: map['userType'] ?? '',
      chatDocuments: Map<Room, List<Document>>.from(map['chatDocuments']),
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'ProfileDocumentsState(userType: $userType, chatDocuments: $chatDocuments)';

  @override
  List<Object> get props => [userType, chatDocuments];
}
