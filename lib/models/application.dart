class Application {
  String studentID,
      agentID,
      agentName,
      agentImage,
      universityName,
      city,
      applicationID,
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
  bool isValid() {
    try {
      assert(studentID != null && studentID.isNotEmpty);
      assert(agentID != null && agentID.isNotEmpty);
      assert(universityName != null && universityName.isNotEmpty);
      assert(courseFees != null && courseFees.isNotEmpty);
      assert(applicationFees != null && applicationFees.isNotEmpty);
      assert(courseName != null && courseName.isNotEmpty);
      assert(courseLink != null && courseLink.isNotEmpty);
      assert(description != null && description.isNotEmpty);
      return true;
    } on AssertionError {
      return false;
    }
  }

  factory Application.parseApplication(Map<String, dynamic> offerData) {
    Application offer = Application();

    offer.country = offerData["location"]["country"];
    offer.applicationID = offerData["_id"];
    offer.city = offerData["location"]["city"];
    offer.description = offerData["description"];
    offer.accepted = offerData["accepted"];
    offer.universityName = offerData["universityName"];
    offer.applicationFees = offerData["applicationFees"].toString();
    offer.courseFees = offerData["courseFees"].toString();
    offer.courseName = offerData["courseName"];
    offer.courseLink = offerData["courseLink"];

    offer.agentID = offerData.containsKey('agent')
        ? offerData['agent'] == null
            ? null
            : offerData["agent"]['agentID']
        : null;
    offer.studentID = offerData['student'];
    offer.color = offerData["color"];
    offer.status = offerData['status'];
    return offer;
  }
}
