import 'package:equatable/equatable.dart';

import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/chat/type/flutter_chat_types.dart';
import 'package:elite_counsel/models/document.dart';

class ProfileDocumentsState extends Equatable {
  final String userType;
  final Map<String, List<Document>> chatDocuments;
  final String nonce;
  final LoadState loadState;
  ProfileDocumentsState({
    required this.userType,
    required this.chatDocuments,
    required this.nonce,
    required this.loadState,
  });

  ProfileDocumentsState copyWith({
    String? userType,
    Map<String, List<Document>>? chatDocuments,
    String? nonce,
    LoadState? loadState,
  }) {
    return ProfileDocumentsState(
      userType: userType ?? this.userType,
      chatDocuments: chatDocuments ?? this.chatDocuments,
      nonce: nonce ?? this.nonce,
      loadState: loadState ?? this.loadState,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userType': userType,
      'chatDocuments': chatDocuments,
    };
  }

  @override
  List<Object> get props => [userType, chatDocuments, nonce, loadState];
}
