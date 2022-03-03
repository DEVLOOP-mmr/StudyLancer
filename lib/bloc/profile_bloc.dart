import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:elite_counsel/classes/classes.dart';

import 'dio.dart';

class ProfileBloc {
  static Future<void> setStudentProfile(Student student) async {
    Map body = {
      "studentID": student.id,
      "location": {"city": student.city, "country": student.country},
      "name": student.name,
      "email": student.email,
      "photo": student.photo,
      "DOB": student.dob,
      "martialStatus": student.maritalStatus,
      "phone": student.phone,
      "about": student.about,
    };
    await GetDio.getDio().put(
        "student/update/${FirebaseAuth.instance.currentUser.uid}",
        data: jsonEncode(body));
    return;
  }

  static Future<void> setAgentProfile(Agent agent) async {
    Map body = {
      "studentID": agent.id,
      "location": {"city": agent.city, "country": agent.country},
      "name": agent.name,
      "email": agent.email,
      "photo": agent.photo,
      "bio": agent.bio,
      "licenseNo": agent.licenseNo,
      "martialStatus": agent.maritalStatus,
      "phone": agent.phone,
    };
    await GetDio.getDio().put(
        "agent/update/${FirebaseAuth.instance.currentUser.uid}",
        data: jsonEncode(body));
    return;
  }
}
