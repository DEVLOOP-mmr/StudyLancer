import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elite_counsel/bloc/document_bloc/documents_state.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/chat/backend/firebase_chat_bloc/firebase_chat_bloc.dart';
import 'package:elite_counsel/chat/type/flutter_chat_types.dart';
import 'package:elite_counsel/variables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:elite_counsel/models/document.dart';
import 'package:uuid/uuid.dart';

import '../dio.dart';

class DocumentBloc extends Cubit<ProfileDocumentsState> {
  final HomeBloc homeBloc;
  final FirebaseChatBloc chatBloc;
  DocumentBloc({
    required this.homeBloc,
    required this.chatBloc,
  }) : super(ProfileDocumentsState(
            userType: '',
            chatDocuments: {},
            nonce: 'njenjd',
            loadState: LoadState.initial)) {
    syncDocumentsFromChatDocuments();
    homeBloc.stream.asBroadcastStream().listen((event) {
      if (event is AgentHomeState) {
        emit(state.copyWith(userType: Variables.userTypeAgent));
      } else if (event is StudentHomeState) {
        emit(state.copyWith(userType: Variables.userTypeStudent));
      }
    });
  }
  Future<String> parseAndUploadFilePickerResult(
    FilePickerResult result, {
    String? requiredDocType,
  }) async {
    for (var x in result.files) {
      final fileName = x.path!.split("/").last;
      final filePath = x.path;
      final file = File(filePath ?? '');

      try {
        final reference = FirebaseStorage.instance.ref(fileName);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();
        postDocument(
          Document(
            link: uri,
            name: requiredDocType ?? fileName,
            type: x.extension ?? "",
          ),
          FirebaseAuth.instance.currentUser!.uid,
        ).then((value) {
          EasyLoading.showSuccess("Uploaded Successfully");
        });
        return uri;
      } on Exception {
        if (kDebugMode) {
          rethrow;
        }
        EasyLoading.showSuccess("Something went Wrong");
        return '';
      }
    }
    return '';
  }

  void syncDocumentsFromChatDocuments() {
    chatBloc.stream.asBroadcastStream().listen((chatState) async {
      if (chatState.rooms != null) {
        for (var room in chatState.rooms!) {
          await getChatDocs(room);
        }
      }
    });
  }

  Future<void> postChatDocument(
    Document document,
    String chatID,
  ) async {
    Map body = {
      'chatId': chatID,
      "docData": {
        "link": document.link.toString(),
        "name": document.name.toString(),
        "type": document.type.toString(),
      },
    };

    final response =
        await GetDio.getDio().post("chat/addChatDoc", data: jsonEncode(body));
    switch (response.statusCode) {
      case 200:
        break;
      case 500:
        if (kDebugMode) {
          throw Exception('addChatDoc:500');
        }
        EasyLoading.showError('Something Went Wrong Please Try Agin');

        break;

      default:
        throw Exception(
          "addChatDoc: ${response.statusCode}, ${response.data} ",
        );
    }
  }

  Future<List<Document>?> getChatDocs(Room room) async {
    Map body = {'chatId': room.id};
    emit(state.copyWith(loadState: LoadState.loading));
    final response =
        await GetDio.getDio().post("chat/getChatDoc", data: jsonEncode(body));
    List<Document> docs = [];
    if (response.statusCode == 200) {
      final data = response.data;
      List? docData = data['data'];
      if (docData != null) {
        for (var doc in docData) {
          docs.add(Document.fromMap(doc));
        }
      }
      var map = state.chatDocuments;
      map[room.name ?? 'Chat Room'] = docs;
      emit(state.copyWith(
        chatDocuments: map,
        nonce: Uuid().v4(),
        loadState: LoadState.done,
      ));
      return docs;
    } else {
      if (kDebugMode) {
        return null;
      }
      EasyLoading.showError('Something Went Wrong Please Try Agin');
    }

    return null;
  }

  Future<Response> postDocument(
    Document document,
    String uid,
  ) async {
    Map body = {
      '${state.userType}ID': uid,
      "documents": {
        "link": document.link.toString(),
        "name": document.name.toString(),
        "type": document.type.toString(),
      },
    };

    return await GetDio.getDio()
        .post("${state.userType}/createDoc", data: jsonEncode(body));
  }

  Future<Response> updateDocument(
    String? documentID,
    String uid,
    String newName,
  ) async {
    Map body = {
      "${state.userType}ID": uid,
      "documentID": documentID,
      "name": newName,
    };

    final response = await GetDio.getDio()
        .put("${state.userType}/updateDoc", data: jsonEncode(body));

    if (response.statusCode == 200) {
      if (kDebugMode) {
        return response;
      }
      EasyLoading.showInfo('Updated Successfully');
    }

    return response;
  }

  Future<Response> deleteDocument(
    String? docName,
    String? documentID,
    String? uid,
  ) async {
    Map body = {
      "${state.userType}ID": uid,
      "documentID": documentID,
    };

    return await GetDio.getDio()
        .delete("${state.userType}/deleteDoc", data: jsonEncode(body));
  }
}

/// TODO: prompt to ask user to delete as ios
