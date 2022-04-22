import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:elite_counsel/models/application.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dio.dart';

class OfferBloc {
  static Future<Response> addOffer(
      Application application, String agentID) async {
    try {
      application.agentID = agentID;

      Map body = {
        "studentID": application.studentID,
        "agentID": application.agentID,
        "universityName": application.universityName,
        "location": {
          "city": application.city ?? application.location['city'] ?? '',
          "country":
              application.country ?? application.location['country'] ?? '',
        },
        "courseFees": int.parse(application.courseFees),
        "applicationFees": int.parse(application.applicationFees),
        "courseName": application.courseName,
        "courseLink": application.courseLink,
        "description": application.description,
      };
      var response = await GetDio.getDio()
          .post("application/create", data: jsonEncode(body));
      if (response.statusCode < 299) {
        if (kDebugMode) {
          return response;
        }
        EasyLoading.showSuccess("Offer sent");
      } else {
        if (kDebugMode) {
          return response;
        }
        var data = response.data;
        if (data.containsKey('message')) {
          EasyLoading.showError(data['message']);
        } else {
          EasyLoading.showError('Something went wrong');
        }
      }
      return response;
    } on DioError {
      EasyLoading.showError( 'Cant connect please try again later');
    }
  }

  static Future<Response> acceptOffer(
      String applicationID, String agentID, String studentID) async {
    Map body = {
      "studentID": studentID,
      "agentID": agentID,
      "applicationID": applicationID,
    };
    try {
      final response = await GetDio.getDio()
          .post("student/application/add", data: jsonEncode(body));
      if (response.statusCode < 299) {
        if (kDebugMode) {
          return response;
        }
        EasyLoading.showError("Offer Accepted");
      } else {
        if (kDebugMode) {
          return response;
        }
        var data = response.data;
        if (data.containsKey('message')) {
          EasyLoading.show(status: data['message']);
        } else {
          EasyLoading.show(status: 'Something went wrong');
        }
      }
      return response;
    } on DioError {
      EasyLoading.show(status: 'Cant connect please try again later');
    }
  }
}
