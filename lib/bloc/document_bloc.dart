import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

import 'dio.dart';

class DocumentBloc {
  static Future<void> postStudentDocument(
      String link, String name, String type) async {
    Map body = {
      "studentID": FirebaseAuth.instance.currentUser.uid,
      "documents": {
        "link": link.toString(),
        "name": name.toString(),
        "type": type.toString() ?? "",
      }
    };
    var result =
        await GetDio.getDio().post("student/doc", data: jsonEncode(body));
    return;
  }

  static Future<void> postAgentDocument(
      String link, String name, String type) async {
    Map body = {
      "agentID": FirebaseAuth.instance.currentUser.uid,
      "documents": {
        "link": link.toString(),
        "name": name.toString(),
        "type": type.toString() ?? "",
      }
    };
    await GetDio.getDio().post("agent/doc", data: jsonEncode(body));
    return;
  }
}
