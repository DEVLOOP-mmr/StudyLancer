import 'package:elite_counsel/models/document.dart';
import 'package:elite_counsel/models/review.dart';
import 'package:elite_counsel/models/student.dart';

class Country {
  String id, countryName;
  List<CountryImage> images;
  Country({
    this.countryName,
    this.images,
    this.id,
  });
}

class CountryImage {
  String description, image;

  CountryImage(this.description, this.image);
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
