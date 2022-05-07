import 'package:elite_counsel/models/document.dart';
import 'package:elite_counsel/models/study_lancer_user.dart';
import 'package:equatable/equatable.dart';

class Agent extends StudyLancerUser with EquatableMixin {
  static final requiredDocNames = [
    'license',
    'registrationCertificate',
    'personalID',
  ];

  String? licenseNo;
  String? agentSince;

  String? applicationsHandled;

  String? reviewsAvg;

  String? reviewCount;

  Agent();
  @override
  factory Agent.fromMap(Map<String, dynamic> agentData) {
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
    agent.city =
        agentData["location"] != null ? agentData['location']['city'] : '';
    agent.country =
        agentData["location"] != null ? agentData['location']['country'] : '';
    agent.documents = [];
    List otherDoc = agentData["documents"] ?? [];
    agent.documents = [];
    agent.requiredDocuments = {};
    agent = _parseAgentDocuments(otherDoc, agent);

    return _validateParsedAgent(agent, agentData);
  }

  static Agent _validateParsedAgent(
    Agent agent,
    Map<String, dynamic> agentData,
  ) {
    return agent;
    if (agent.isValid() is bool) {
      return agent;
    } else {
      throw Exception(
          (agent.isValid() as AssertionError).toString() + "for :$agentData");
    }
  }

  dynamic isValid() {
    try {
      assert((name ?? '').isNotEmpty);
      assert((id ?? '').isNotEmpty);
      assert((phone ?? '').isNotEmpty);

      return true;
    } on AssertionError catch (e) {
      return e;
    }
  }

  static Agent _parseAgentDocuments(List<dynamic> otherDoc, Agent agent) {
    for (var element in otherDoc) {
      if (element is Map) {
        var document = Document();
        document
          ..name = element["name"]
          ..id = element["_id"]
          ..link = element["link"]
          ..type = element["type"];
        if (Agent.requiredDocNames.contains(document.name)) {
          agent.requiredDocuments![document.name] = document;
        } else {
          agent.documents!.add(document);
        }
      }
    }

    return agent;
  }

  @override
  List<Object?> get props {
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
