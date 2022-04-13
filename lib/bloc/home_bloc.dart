import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';
import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/models/document.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/pages/usertype_select/usertype_select_page.dart';
import 'package:elite_counsel/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dio.dart';

class HomeBloc {
  static Future<StudentHome> getStudentHome({
    BuildContext context,
    FirebaseAuth firebaseAuth,
  }) async {
    firebaseAuth ??= FirebaseAuth.instance;
    assert(firebaseAuth.currentUser != null);
    StudentHome homeData = StudentHome();
    Map<String, String> body = {
      "studentID": firebaseAuth.currentUser.uid,
      "countryLookingFor": Variables.sharedPreferences
          .get(Variables.countryCode, defaultValue: "AU"),
      "phone": firebaseAuth.currentUser.phoneNumber,
    };
    var encode = jsonEncode(body);

    var result = await GetDio.getDio().post(
      "student/home",
      data: encode,
    );

    if (result.statusCode < 299) {
      var data = result.data;
      homeData.self = parseStudentData(data["student"]);
      homeData.agents = [];
      if (data['agents'] is! String) {
        List agentList = data["agents"];
        agentList.forEach((element) {
          homeData.agents.add(parseAgentData(element));
        });
      }
    } else {
      if (GetDio.isTestMode()) {
        return null;
      }
      await navigateToUserTypeSelectPageOnError(result, context);
    }

    return homeData;
  }

  static Future<void> navigateToUserTypeSelectPageOnError(
    Response<dynamic> result,
    BuildContext context,
  ) async {
    EasyLoading.showError('Something Went Wrong');

    if (context != null) {
      await FirebaseAuth.instance.signOut();
      Variables.sharedPreferences.clear();
      Future.delayed(Duration.zero, () {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return UserTypeSelectPage();
        }), (route) => false);
      });
    }
  }

  static Future<AgentHome> getAgentHome(
      {BuildContext context, FirebaseAuth auth}) async {
    AgentHome homeData = AgentHome();
    Map<String, String> body = {
      "agentID": auth.currentUser.uid,
      "countryLookingFor": Variables.sharedPreferences
          .get(Variables.countryCode, defaultValue: "AU"),
      "phone": auth.currentUser.phoneNumber,
    };
    var result =
        await GetDio.getDio().post("agent/home", data: jsonEncode(body));

    if (result.statusCode < 300) {
      var data = result.data;
      homeData.self = parseAgentData(data["agent"]);
      homeData.students = [];
      List studentList = data["students"];
      studentList.forEach((element) {
        homeData.students.add(parseStudentData(element["student"])
          ..optionStatus = element["optionStatus"]);
      });
    } else {
      navigateToUserTypeSelectPageOnError(result, context);
    }

    return homeData;
  }

  static Student parseStudentData(studentData) {
    Student student = Student();
    student.name = studentData["name"];
    student.email = studentData["email"];
    student.phone = studentData["phone"];
    student.photo = studentData["photo"];
    student.maritalStatus = studentData["martialStatus"];
    student.id = studentData["studentID"];
    student.countryLookingFor = studentData["countryLookingFor"];
    student.marksheet = studentData["marksheet"];
    student.city = studentData["location"]["city"];
    student.country = studentData["location"]["country"];
    student.dob = studentData["DOB"];
    student.about = studentData["about"];
    student.verified = studentData["verified"];
    student.optionStatus = studentData["optionStatus"] ?? 0;
    student.timeline = studentData["timeline"] ?? 1;
    student.applyingFor =
        studentData["applyingFor"] ?? "Masters in Computer Science";
    student.course = studentData["course"] ?? "B.Tech from DTU (95%)";
    student.year = studentData["year"] ?? DateTime.now().year.toString();
    student.previousOffers = [];
    (studentData["previousApplications"] as List).forEach((element) {
      if (element is Map) student.previousOffers.add(parseOffer(element));
    });
    student.documents = [];
    List otherDoc = studentData["documents"];
    otherDoc.forEach((element) {
      if (element is Map) {
        student.documents.add(Document()
          ..name = element["name"]
          ..id = element["_id"]
          ..link = element["link"]
          ..type = element["type"]);
      }
    });
    return student;
  }

  static Offer parseOffer(offerData) {
    Offer offer = Offer();
    offer.country = offerData["location"]["country"];
    offer.offerId = offerData["_id"];
    offer.city = offerData["location"]["city"];
    offer.description = offerData["description"];
    offer.accepted = offerData["accepted"];
    offer.universityName = offerData["universityName"];
    offer.applicationFees = offerData["applicationFees"].toString();
    offer.courseFees = offerData["courseFees"].toString();
    offer.courseName = offerData["courseName"];
    offer.courseLink = offerData["courseLink"];
    offer.agentID = offerData["agent"]["agentID"];
    offer.agentName = offerData["agent"]["name"];
    offer.agentImage = offerData["agent"]["photo"];
    offer.color = offerData["color"];
    return offer;
  }

  static Agent parseAgentData(agentData) {
    Agent agent = Agent();
    agent.name = agentData["name"];
    agent.email = agentData["email"];
    agent.photo = agentData["photo"];
    agent.phone = agentData["phone"];
    agent.licenseNo = agentData["licenseNo"];
    agent.agentSince = agentData["agentSince"];
    agent.bio = agentData["bio"];
    agent.verified = agentData["verified"];
    agent.maritalStatus = agentData["martialStatus"];
    agent.applicationsHandled = agentData["applicationsHandled"].toString();
    agent.reviewsAvg = agentData["reviewAverage"].toString();
    agent.id = agentData["agentID"];
    agent.reviewCount =
        ((agentData["reviews"] ?? []) as List).length.toString();
    agent.countryLookingFor = agentData["countryLookingFor"];
    agent.city = agentData["location"]["city"];
    agent.country = agentData["location"]["country"];
    agent.otherDoc = [];
    List otherDoc = agentData["documents"];
    otherDoc.forEach((element) {
      if (element is Map) {
        agent.otherDoc.add(Document()
          ..name = element["name"]
          ..id = element["_id"]
          ..link = element["link"]
          ..type = element["type"]);
      }
    });
    return agent;
  }
}
