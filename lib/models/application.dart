import 'package:elite_counsel/models/agent.dart';
import 'package:equatable/equatable.dart';

class Application extends Equatable {
  String? studentID;
  Agent? agent;
  String? universityName;
  String? city;
  String? applicationID;
  String? country;
  String? courseName;
  String? description;
  String? courseFees;
  String? courseLink;
  String? color;
  String? applicationFees;
  Map<String, String>? location; //city, country
  int? status;
  bool? accepted;
  Application({
    this.accepted,
  });
  bool isValid() {
    try {
      assert(studentID != null && studentID!.isNotEmpty);

      assert(universityName != null && universityName!.isNotEmpty);
      assert(courseFees != null && courseFees!.isNotEmpty);
      assert(applicationFees != null && applicationFees!.isNotEmpty);
      assert(courseName != null && courseName!.isNotEmpty);
      assert(courseLink != null && courseLink!.isNotEmpty);
      assert(description != null && description!.isNotEmpty);
      return true;
    } on AssertionError {
      return false;
    }
  }

  factory Application.parseApplication(Map<String, dynamic> offerData) {
    Application application = Application();

    application.country = offerData["location"]["country"];
    application.applicationID = offerData["_id"];
    application.city = offerData["location"]["city"];
    application.description = offerData["description"];
    application.accepted = offerData["accepted"];
    application.universityName = offerData["universityName"];
    application.applicationFees = offerData["applicationFees"].toString();
    application.courseFees = offerData["courseFees"].toString();
    application.courseName = offerData["courseName"];
    application.courseLink = offerData["courseLink"];

    application.agent = offerData.containsKey('agent')
        ? offerData['agent'] == null
            ? null
            : Agent.fromMap(offerData['agent'])
        : null;
    application.studentID = offerData['student'];
    application.color = offerData["color"];
    application.status = offerData['status'];

    return application;
  }

  @override
  List<Object?> get props {
    return [
      studentID,
      agent,
      universityName,
      city,
      applicationID,
      country,
      courseName,
      description,
      courseFees,
      courseLink,
      color,
      applicationFees,
      location,
      status,
      accepted,
    ];
  }
}
