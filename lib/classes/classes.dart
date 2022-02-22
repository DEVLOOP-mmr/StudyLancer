class Country {
  String id, countryName;
  List<CountryImage> images;
}

class CountryImage {
  String description, image;

  CountryImage(this.description, this.image);
}

class Student {
  String name,
      email,
      photo,
      dob,
      maritalStatus,
      id,
      phone,
      countryLookingFor,
      city,
      course,
      year,
      applyingFor,
      about,
      country;
  int optionStatus, timeline;
  bool verified;
  Map<String, dynamic> marksheet;
  List<Offer> previousOffers;
  List<Document> otherDoc;
}

class Agent {
  String name,
      id,
      phone,
      email,
      photo,
      licenseNo,
      agentSince,
      bio,
      maritalStatus,
      applicationsHandled,
      city,
      country,
      reviewsAvg,
      countryLookingFor,
      reviewCount;
  bool verified;
  List<Document> otherDoc;
}

class Document {
  String name, link, type, id, reqDocKey;
}

class Review {
  String id,
      agentId,
      reviewerId,
      starsRated,
      createdAt,
      reviewerName,
      reviewContent;
}

class AgentReviews {
  List<Review> reviews;
  bool studentHasReviewed;
}

class Offer {
  String studentID,
      agentID,
      agentName,
      agentImage,
      universityName,
      city,
      offerId,
      country,
      courseName,
      description,
      courseFees,
      courseLink,
      color,
      applicationFees;
  bool accepted;
}

class StudentHome {
  Student self;
  List<Agent> agents;
}

class AgentHome {
  Agent self;
  List<Student> students;
}
