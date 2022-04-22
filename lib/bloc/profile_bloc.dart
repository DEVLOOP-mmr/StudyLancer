import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:elite_counsel/models/agent.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/models/study_lancer_user.dart';
import 'package:elite_counsel/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elite_counsel/classes/classes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import 'dio.dart';

class ProfileBloc {
  static Future<StudyLancerUser> getUserProfile({
    String uid,
    String userType,
  }) async {
    Map<String, String> body = {
      "${userType}ID": uid,
      "countryLookingFor": "CA",
      "phone": "0",
    };
    var result = await GetDio.getDio().post(
      "$userType/home",
      data: jsonEncode(body),
    );

    if (result.statusCode < 299) {
      var data = result.data;
      StudyLancerUser profile;
      profile = userType == 'student'
          ? Student.fromMap(data['student'])
          : Agent.fromMap(data['agent']);

      return profile;
    } else if (result.statusCode == 403) {
      /// Retry if /home is fetched for the wrong user type
      return userType == 'student'
          ? await getUserProfile(uid: uid, userType: 'agent')
          : await getUserProfile(uid: uid, userType: 'student');
    } else {
      if (kDebugMode) {
        throw Exception('Profile:' + result.statusCode.toString());
      }
      var data = result.data;
      if (data.containsKey('message')) {
        EasyLoading.showError(data['message']);
      } else {
        EasyLoading.showError('Something Went Wrong');
      }
    }
  }

  static Future<Response> updateStudentProfile(Student student) async {
    String dob = student.dob;
    var dateTime = DateTime.tryParse(dob) ?? Variables.dateFormat.parse(dob);
    Map body = {
      "studentID": student.id,
      "location": {"city": student.city, "country": student.country},
      "name": student.name,
      "email": student.email,
      "photo": student.photo,
      "DOB": dateTime.toIso8601String(),
      "martialStatus": student.maritalStatus,
      "bio": student.bio,
    };

    return await GetDio.getDio().put("student/update", data: jsonEncode(body));
  }

  static Future<Response> setAgentProfile(Agent agent) async {
    Map body = {
      "agentID": agent.id,
      "location": {"city": agent.city, "country": agent.country},
      "name": agent.name,
      "email": agent.email,
      "photo": agent.photo,
      "bio": agent.bio,
      "licenseNo": agent.licenseNo,
      "martialStatus": agent.maritalStatus,
    };
    final response =
        await GetDio.getDio().put("agent/update", data: jsonEncode(body));
    log(response.statusCode.toString());

    return response;
  }
}
