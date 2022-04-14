import 'dart:convert';
import 'dart:developer';

import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/models/document.dart';
import 'package:flutter/material.dart';

class Student {
  String name;
  String email;
  String photo;
  String dob;
  String maritalStatus;
  String id;
  String phone;
  String countryLookingFor;
  String city;
  String course;
  String year;
  String applyingFor;
  String about;
  String country;
  int optionStatus=1;
  int timeline;
  bool verified;
  Map<String, dynamic> marksheet;
  List<Offer> previousOffers;
  List<Document> documents;
  List<Document> requiredDocuments;
  Student({
    this.name,
    this.email,
    this.photo,
    this.dob,
    this.maritalStatus,
    this.id,
    this.phone,
    this.countryLookingFor,
    this.city,
    this.course,
    this.year,
    this.applyingFor,
    this.about,
    this.country,
    this.optionStatus,
    this.timeline,
    this.verified,
    this.marksheet,
    this.previousOffers,
    this.documents,
  });
  bool isValid() {
    try {
      assert(this is! Null);
      assert(id.isNotEmpty);
      assert(name.isNotEmpty);
      assert(countryLookingFor.isNotEmpty);
      return true;
    } on AssertionError catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photo': photo,
      'dob': dob,
      'maritalStatus': maritalStatus,
      'id': id,
      'phone': phone,
      'countryLookingFor': countryLookingFor,
      'city': city,
      'course': course,
      'year': year,
      'applyingFor': applyingFor,
      'about': about,
      'country': country,
      'optionStatus': optionStatus,
      'timeline': timeline,
      'verified': verified,
      'marksheet': marksheet,
      'previousOffers': previousOffers,
      'otherDoc': documents,
    };
  }

   factory Student.parseStudentData(studentData) {
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
      if (element is Map) student.previousOffers.add(Offer.parseOffer(element));
    });
    student.documents = [];
    List documents = studentData["documents"];
    documents.forEach((element) {
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

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Student(name: $name, email: $email, photo: $photo, dob: $dob, maritalStatus: $maritalStatus, id: $id, phone: $phone, countryLookingFor: $countryLookingFor, city: $city, course: $course, year: $year, applyingFor: $applyingFor, about: $about, country: $country, optionStatus: $optionStatus, timeline: $timeline, verified: $verified, marksheet: $marksheet, previousOffers: $previousOffers, otherDoc: $documents)';
  }
}
/// TODO: parse required docs data