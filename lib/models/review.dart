import 'dart:convert';

class Review {
  String id;
  String agentId;
  String studentId;
  String starsRated;
  String createdAt;
  String reviewerName;
  String reviewContent;
  Review({
    this.id,
    this.agentId,
    this.studentId,
    this.starsRated,
    this.createdAt,
    this.reviewerName,
    this.reviewContent,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'agentId': agentId,
      'reviewerId': studentId,
      'starsRated': starsRated,
      'createdAt': createdAt,
      'reviewerName': reviewerName,
      'reviewContent': reviewContent,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] ?? '',
      agentId: map['agentId'] ?? '',
      studentId: map['reviewerId'] ?? '',
      starsRated: map['starsRated'] ?? '',
      createdAt: map['createdAt'] ?? '',
      reviewerName: map['reviewerName'] ?? '',
      reviewContent: map['reviewContent'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
}
