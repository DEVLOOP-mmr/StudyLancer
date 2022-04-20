import 'package:elite_counsel/models/document.dart';
import 'package:equatable/equatable.dart';

class Agent extends Equatable {
  static final requiredDocNames = [
    'license',
    'registrationCertificate',
    'personalID'
  ];
  String name;
  String id;
  String phone;
  String email;
  String photo;
  String licenseNo;
  String agentSince;
  String bio;
  String maritalStatus;
  String applicationsHandled;
  String city;
  String country;
  String reviewsAvg;
  String countryLookingFor;
  String reviewCount;
  bool verified;
  List<Document> documents;
  Map<String, Document> requiredDocuments;
  Agent();

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
    agent.documents = [];
    List otherDoc = agentData["documents"];
    agent.documents = [];
    agent.requiredDocuments = {};
    for (var element in otherDoc) {
      if (element is Map) {
        var document = Document();
        document
          ..name = element["name"]
          ..id = element["_id"]
          ..link = element["link"]
          ..type = element["type"];
        if (Agent.requiredDocNames.contains(document.name)) {
          agent.requiredDocuments[document.name] = document;
        } else {
          agent.documents.add(document);
        }
      }
    }
    return agent;
  }

  @override
  List<Object> get props {
    return [
      name,
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
      reviewCount,
      verified,
      documents,
      requiredDocuments,
    ];
  }
}
