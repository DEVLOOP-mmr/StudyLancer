// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:elite_counsel/models/document.dart';

/// Abstract parent class for [Student] and [Agent]
class StudyLancerUser {
  String name;
  String email;
  String photo;

  String maritalStatus;
  String id;
  String phone;
  String countryLookingFor;
  String city;

  String bio;
  String country;

  bool verified;

  List<Document> documents;
  Map<String, Document> requiredDocuments;
  StudyLancerUser({
    this.name,
    this.email,
    this.photo,
    this.maritalStatus,
    this.id,
    this.phone,
    this.countryLookingFor,
    this.city,
    this.bio,
    this.country,
    this.verified,
    this.documents,
    this.requiredDocuments,
  });

  factory StudyLancerUser.fromMap(Map<String, dynamic> map) {
    throw UnimplementedError('Use either Student or Agent Model');
  }
}
