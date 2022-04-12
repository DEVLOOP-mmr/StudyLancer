import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/models/review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dio.dart';

class ReviewBloc {
  static Future<AgentReviews> getAgentReview(
      String agentId, String studentID) async {
    AgentReviews agentReviews = AgentReviews();
    agentReviews.reviews = [];

    Map body = {"studentID": studentID, "agentID": agentId};
    try {
      var result = await GetDio.getDio()
          .post("agent/reviews/all", data: jsonEncode(body));
      if (result.statusCode == 200) {
        var data = result.data;
        List reviewList = data["data"];
        agentReviews.studentHasReviewed = data["studentHasReviewed"];
        reviewList.forEach((reviewData) {
          agentReviews.reviews.add(parseReviewData(reviewData));
        });
      } else {
        return null;
      }
    } on DioError catch (e) {
      log(e.toString());
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
    try {
      var result = await GetDio.getDio()
          .post("agent/reviews/create", data: jsonEncode(body));
      if (result.statusCode == 201) {
        return true;
      } else if (result.statusCode == 500) {
        log(result.data['message']);
        if (kReleaseMode) {
          EasyLoading.showToast('Review already added');
        }

        return false;
      } else {
        log(result.statusCode.toString() + ' ' + result.statusMessage);
        // EasyLoading.showToast(result.data['error']);
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  static Review parseReviewData(reviewData) {
    Review review = Review();
    review.id = reviewData["_id"];
    review.agentId = reviewData["agent"];
    review.studentId = reviewData["reviewerID"];
    review.starsRated = reviewData["starsRated"].toString();
    review.reviewerName = reviewData["reviewerName"];
    review.reviewContent = reviewData["reviewContent"];
    review.createdAt = reviewData["createdAt"];
    return review;
  }
}
