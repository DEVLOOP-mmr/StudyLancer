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
  List<Document> document;
  List<Document> requiredDocuments;
  Agent();

  /// TODO: parse required docs data
  factory Agent.parseAgentData(agentData) {
    Agent agent = Agent();
    agent.name = agentData["name"];
    agent.email = agentData["email"];
    agent.photo = agentData["photo"];
    agent.phone = agentData["phone"];
    agent.licenseNo = agentData["licenseNo"];
    agent.agentSince = agentData["agentSince"];
    agent.bio = agentData["bio"];
    agent.verified = agentData["verified"];
    agent.maritalStatus = agentData["martialStatus"];
    agent.applicationsHandled = agentData["applicationsHandled"].toString();
    agent.reviewsAvg = agentData["reviewAverage"].toString();
    agent.id = agentData["agentID"];
    agent.reviewCount =
        ((agentData["reviews"] ?? []) as List).length.toString();
    agent.countryLookingFor = agentData["countryLookingFor"];
    agent.city = agentData["location"]["city"];
    agent.country = agentData["location"]["country"];
    agent.document = [];
    List otherDoc = agentData["documents"];
    otherDoc.forEach((element) {
      if (element is Map) {
        agent.document.add(Document()
          ..name = element["name"]
          ..id = element["_id"]
          ..link = element["link"]
          ..type = element["type"]);
      }
    });
    return agent;
  }
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
