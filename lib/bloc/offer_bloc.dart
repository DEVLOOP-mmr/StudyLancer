import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:elite_counsel/classes/classes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dio.dart';

class OfferBloc {
  static Future<Response> addOffer(
      Application application, String agentID) async {
    application.agentID = agentID;
    Map body = {
      "studentID": application.studentID,
      "agentID": application.agentID,
      "universityName": application.universityName,
      "location": {"city": application.city, "country": application.country},
      "courseFees": int.parse(application.courseFees),
      "applicationFees": int.parse(application.applicationFees),
      "courseName": application.courseName,
      "courseLink": application.courseLink,
      "description": application.description,
    };
    var request = await GetDio.getDio()
        .post("application/create", data: jsonEncode(body));
    if (request.statusCode == 200) {
      EasyLoading.showError("Offer sent");
    }
    return request;
  }

  static Future<void> acceptOffer(
      String applicationID, String agentID, String studentID) async {
    Map body = {
      "studentID": studentID,
      "agentID": agentID,
      "applicationID": applicationID,
    };
    await GetDio.getDio()
        .post("student/application/add", data: jsonEncode(body));
    return;
  }
}
