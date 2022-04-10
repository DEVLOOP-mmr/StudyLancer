import 'dart:convert';
import 'dart:developer';

import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/models/review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dio.dart';

class ReviewBloc {
  static Future<AgentReviews> getAgentReview(String agentId) async {
    AgentReviews agentReviews = AgentReviews();
    agentReviews.reviews = [];
    print(agentId);
    Map body = {
      "studentID": FirebaseAuth.instance.currentUser.uid,
      "agentID": agentId
    };
    var result =
        await GetDio.getDio().post("agent/reviews/all", data: jsonEncode(body));
    if (result.statusCode < 300) {
      var data = result.data;
      List reviewList = data["data"];
      agentReviews.studentHasReviewed = data["studentHasReviewed"];
      reviewList.forEach((reviewData) {
        agentReviews.reviews.add(parseReviewData(reviewData));
      });
    }
    return agentReviews;
  }

  static Future<bool> postAgentReview(Review review, String studentName) async {
    Map body = {
      "studentID": review.studentId,
      "agentID": review.agentId,
      "content": review.reviewContent,
      "stars": review.starsRated,
      "studentName": studentName,
    };
    var result = await GetDio.getDio()
        .post("agent/reviews/create", data: jsonEncode(body));
    if (result.statusCode == 200) {
      return true;
    } else if (result.statusCode == 500) {
      log(result.data['message']);
      EasyLoading.showToast(result.data['message']);
      return false;
    } else {
      log(result.statusCode.toString() + ' ' + result.statusMessage);
      // EasyLoading.showToast(result.data['error']);
    }
  }

  static Review parseReviewData(reviewData) {
    Review review = Review();
    review.id = reviewData["_id"];
    review.agentId = reviewData["agentID"];
    review.studentId = reviewData["reviewerID"];
    review.starsRated = reviewData["starsRated"].toString();
    review.reviewerName = reviewData["reviewerName"];
    review.reviewContent = reviewData["reviewContent"];
    review.createdAt = reviewData["createdAt"];
    return review;
  }
}
