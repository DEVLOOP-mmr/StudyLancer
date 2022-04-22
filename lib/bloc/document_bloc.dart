import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:elite_counsel/models/document.dart';

import 'dio.dart';

class DocumentBloc {
  String userType = '';
  DocumentBloc({
    this.userType,
  });
  Future<void> parseAndUploadFilePickerResult(FilePickerResult result,
      {String requiredDocType,}) async {
    for (var x in result.files) {
      final fileName = x.path.split("/").last;
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
                FirebaseAuth.instance.currentUser.uid,)
            .then((value) {
          EasyLoading.showSuccess("Uploaded Successfully");
        });
      } on Exception {
        if (kDebugMode) {
          rethrow;
        }
        EasyLoading.showSuccess("Something went Wrong");
      }
    }
  }

  Future<Response> postDocument(
    Document document,
    String uid,
  ) async {
    Map body = {
      '${userType}ID': uid,
      "documents": {
        "link": document.link.toString(),
        "name": document.name.toString(),
        "type": document.type.toString() ?? "",
      },
    };

    return await GetDio.getDio()
        .post("$userType/createDoc", data: jsonEncode(body));
  }

  Future<Response> updateDocument(
    String documentID,
    String uid,
    String newName,
  ) async {
    Map body = {
      "${userType}ID": uid,
      "documentID": documentID,
      "name": newName,
    };

    final response = await GetDio.getDio()
        .put("$userType/updateDoc", data: jsonEncode(body));

    if (response.statusCode == 200) {
      if (kDebugMode) {
        return response;
      }
      EasyLoading.showInfo('Updated Successfully');
    }
    
    return response;
  }

  Future<Response> deleteDocument(
    String docName,
    String documentID,
    String uid,
  ) async {
    Map body = {
      "${userType}ID": uid,
      "documentID": documentID,
    };

    return await GetDio.getDio()
        .delete("$userType/deleteDoc", data: jsonEncode(body));
  }
}

/// TODO: prompt to ask user to delete as ios
