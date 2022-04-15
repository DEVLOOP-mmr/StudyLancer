import 'dart:convert';

import 'package:elite_counsel/classes/classes.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dio.dart';

class OfferBloc {
  static Future<void> addOffer(Application offer) async {
    offer.agentID = FirebaseAuth.instance.currentUser.uid;
    Map body = {
      "studentID": offer.studentID,
      "agentID": offer.agentID,
      "universityName": offer.universityName,
      "location": {"city": offer.city, "country": offer.country},
      "courseFees": int.parse(offer.courseFees),
      "applicationFees": int.parse(offer.applicationFees),
      "courseName": offer.courseName,
      "courseLink": offer.courseLink,
      "description": offer.description,
    };
    var request = await GetDio.getDio()
        .post("application/create", data: jsonEncode(body));
    print(request);
    return;
  }

  static Future<void> acceptOffer(Application offer) async {
    offer.agentID = FirebaseAuth.instance.currentUser.uid;
    Map body = {
      "studentID": FirebaseAuth.instance.currentUser.uid,
      "agentID": offer.agentID,
      "applcationID": offer.offerId,
    };
    await GetDio.getDio()
        .post("student/application/add", data: jsonEncode(body));
    return;
  }
}
