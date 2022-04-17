import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:elite_counsel/models/agent.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elite_counsel/classes/classes.dart';

import 'dio.dart';

class ProfileBloc {
  static Future<Response> updateStudentProfile(Student student) async {
    Map body = {
      "studentID": student.id,
      "location": {"city": student.city, "country": student.country},
      "name": student.name,
      "email": student.email,
      "photo": student.photo,
      "DOB": student.dob,
      "martialStatus": student.maritalStatus,
      "about": student.about,
    };
    return await GetDio.getDio().put("student/update/", data: jsonEncode(body));
    
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
        await GetDio.getDio().put("agent/update/", data: jsonEncode(body));
    log(response.statusCode.toString());
    return response;
  }
}

/// TODO: add Tests for profile update