

import 'package:elite_counsel/models/review.dart';

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

class AgentReviews {
  List<Review> reviews;
  bool studentHasReviewed;
}

class Application {
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
  Map<String, String> location; //city, country
  int status;
  bool accepted;
  Application({
    this.accepted,
  });
  factory Application.parseApplication(offerData) {
    Application offer = Application();
    
    offer.country = offerData["location"]["country"];
    offer.offerId = offerData["_id"];
    offer.city = offerData["location"]["city"];
    offer.description = offerData["description"];
    offer.accepted = offerData["accepted"];
    offer.universityName = offerData["universityName"];
    offer.applicationFees = offerData["applicationFees"].toString();
    offer.courseFees = offerData["courseFees"].toString();
    offer.courseName = offerData["courseName"];
    offer.courseLink = offerData["courseLink"];
    offer.agentID = offerData["agent"];
 
    offer.color = offerData["color"];
    offer.status = offerData['status'];
    return offer;
  }
}
