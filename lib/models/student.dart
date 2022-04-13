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
  int optionStatus;
  int timeline;
  bool verified;
  Map<String, dynamic> marksheet;
  List<Offer> previousOffers;
  List<Document> documents;
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

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photo: map['photo'] ?? '',
      dob: map['dob'] ?? '',
      maritalStatus: map['maritalStatus'] ?? '',
      id: map['id'] ?? '',
      phone: map['phone'] ?? '',
      countryLookingFor: map['countryLookingFor'] ?? '',
      city: map['city'] ?? '',
      course: map['course'] ?? '',
      year: map['year'] ?? '',
      applyingFor: map['applyingFor'] ?? '',
      about: map['about'] ?? '',
      country: map['country'] ?? '',
      optionStatus: map['optionStatus']?.toInt() ?? 0,
      timeline: map['timeline']?.toInt() ?? 0,
      verified: map['verified'] ?? false,
      marksheet: Map<String, dynamic>.from(map['marksheet'] ?? const {}),
      previousOffers:
          List<Offer>.from(map['previousOffers']?.map((x) => (x)) ?? const []),
      documents:
          List<Document>.from(map['otherDoc']?.map((x) => (x)) ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Student(name: $name, email: $email, photo: $photo, dob: $dob, maritalStatus: $maritalStatus, id: $id, phone: $phone, countryLookingFor: $countryLookingFor, city: $city, course: $course, year: $year, applyingFor: $applyingFor, about: $about, country: $country, optionStatus: $optionStatus, timeline: $timeline, verified: $verified, marksheet: $marksheet, previousOffers: $previousOffers, otherDoc: $documents)';
  }
}
