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
