import 'package:equatable/equatable.dart';

import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
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
  Offer({
    this.accepted,
  });
  factory Offer.parseOffer(offerData) {
    Offer offer = Offer();
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
    offer.agentID = offerData["agent"]["agentID"];
    offer.agentName = offerData["agent"]["name"];
    offer.agentImage = offerData["agent"]["photo"];
    offer.color = offerData["color"];
    return offer;
  }
}
