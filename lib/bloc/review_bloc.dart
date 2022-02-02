import 'dart:convert';

import 'package:elite_counsel/classes/classes.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  static Review parseReviewData(reviewData) {
    Review review = Review();
    review.id = reviewData["_id"];
    review.agentId = reviewData["agentID"];
    review.reviewerId = reviewData["reviewerID"];
    review.starsRated = reviewData["starsRated"].toString();
    review.reviewerName = reviewData["reviewerName"];
    review.reviewContent = reviewData["reviewContent"];
    review.createdAt = reviewData["createdAt"];
    return review;
  }
}
