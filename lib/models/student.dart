import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/models/application.dart';
import 'package:elite_counsel/models/document.dart';
import 'package:elite_counsel/models/study_lancer_user.dart';

class Student extends StudyLancerUser with EquatableMixin {
  static final requiredDocs = [
    'passport',
    'englishProficiencyTest',
    'academics'
  ];

  String dob;

  String course;
  String year;
  String applyingFor;

  int optionStatus = 1;
  int timeline;

  Map<String, dynamic> marksheet;
  List<Application> applications;

  Student();

  bool isValid() {
    try {
      assert(this != null);
      assert(id.isNotEmpty);
      assert(name.isNotEmpty);
      assert(countryLookingFor.isNotEmpty);
      return true;
    } on AssertionError catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  factory Student.fromMap(Map<String, dynamic> studentData) {
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
    student.bio = studentData["bio"];
    student.verified = studentData["verified"];
    student.optionStatus = studentData["optionStatus"] ?? 0;
    student.timeline = studentData["timeline"] ?? 1;
    student.applyingFor =
        studentData["applyingFor"] ?? "";
    student.course = studentData["course"] ?? "B.Tech from DTU (95%)";
    student.year = studentData["year"] ?? DateTime.now().year.toString();
    student.applications = [];
    for (var element in (studentData["previousApplications"] as List)) {
      if (element is Map) {
        student.applications.add(Application.parseApplication(element));
      }
    }
    student.documents = [];
    student.requiredDocuments = {};

    List documents = studentData["documents"];
    for (var element in documents) {
      if (element is Map) {
        var document = Document();
        document
          ..name = element["name"]
          ..id = element["_id"]
          ..link = element["link"]
          ..type = element["type"];
        if (Student.requiredDocs.contains(document.name)) {
          student.requiredDocuments[document.name] = document;
        } else {
          student.documents.add(document);
        }
      }
    }

    return student;
  }

  @override
  String toString() {
    return 'Student(name: $name, email: $email, photo: $photo, dob: $dob, maritalStatus: $maritalStatus, id: $id, phone: $phone, countryLookingFor: $countryLookingFor, city: $city, course: $course, year: $year, applyingFor: $applyingFor, about: $bio, country: $country, optionStatus: $optionStatus, timeline: $timeline, verified: $verified, marksheet: $marksheet, previousOffers: $applications, otherDoc: $documents)';
  }

  @override
  List<Object> get props {
    return [
      dob,
      course,
      year,
      applyingFor,
      optionStatus,
      timeline,
      marksheet,
      applications,
    ];
  }
}
