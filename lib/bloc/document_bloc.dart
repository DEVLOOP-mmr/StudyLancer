import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elite_counsel/models/document.dart';
import 'package:elite_counsel/variables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dio.dart';

class DocumentBloc {
  static Future<void> parseAndUploadFilePickerResult(
    FilePickerResult result,
  ) async {
    for (var x in result.files) {
      final fileName = x.path.split("/").last;
      final filePath = x.path;
      final file = File(filePath ?? '');

      try {
        final reference = FirebaseStorage.instance.ref(fileName);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();
        DocumentBloc.postDocument(
                Document(
                  link: uri,
                  name: fileName,
                  type: x.extension ?? "",
                ),
                FirebaseAuth.instance.currentUser.uid)
            .then((value) {
          EasyLoading.showSuccess("Uploaded Successfully");
        });
      } on Exception catch (e) {
        EasyLoading.showError(e.toString());
        if (kDebugMode) {
          rethrow;
        }
      }
    }
  }

  static Future<Response> postDocument(Document document, String uid,
      {String overrideUserType}) async {
    final userType = overrideUserType ?? (await Variables.sharedPreferences.get(Variables.userType)).toString();

    Map body = {
      '${userType}ID': uid,
      "documents": {
        "link": document.link.toString(),
        "name": document.name.toString(),
        "type": document.type.toString() ?? "",
      }
    };

    return await GetDio.getDio().post("$userType/doc", data: jsonEncode(body));
  }

  static Future<Response> deleteDocument(String document, String uid,
      {String overrideUserType}) async {
    final userType = overrideUserType ?? (await Variables.sharedPreferences.get(Variables.userType)).toString();

    Map body = {
      "${userType}ID": uid,
      "documentID": document,
    };

    return await GetDio.getDio()
        .delete("$userType/doc", data: jsonEncode(body));
  }
}
