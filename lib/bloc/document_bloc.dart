import 'dart:convert';
import 'dart:io';

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
        DocumentBloc.postDocument(uri, fileName, x.extension ?? "")
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

  static Future<void> postDocument(
    String link,
    String name,
    String type,
  ) async {
    final userType =
        (await Variables.sharedPreferences.get(Variables.userType)).toString();
    final idKey = userType == Variables.userTypeAgent ? 'agentID' : 'studentID';
    final parentUrl = userType == Variables.userTypeAgent ? 'agent' : 'student';
    Map body = {
      idKey: FirebaseAuth.instance.currentUser.uid,
      "documents": {
        "link": link.toString(),
        "name": name.toString(),
        "type": type.toString() ?? "",
      }
    };

    await GetDio.getDio().post("$parentUrl/doc", data: jsonEncode(body));
    return;
  }
}
