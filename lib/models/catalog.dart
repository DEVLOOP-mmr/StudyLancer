class CatalogModel {
  static final items = [
    Item(
        id: 1,
        name: "Ahmed Lawley",
        desc: "University of Waterloo",
        image: "assets/chat1.png",
        place: "Canada",
        time: "July 21"),
    Item(
        id: 2,
        name: "Delbert Ferreri",
        desc: "Monash University",
        image: "assets/chat2.png",
        place: "Canada",
        time: "March 22"),
    Item(
        id: 3,
        name: "Kristy Stach",
        desc: "McGill University",
        image: "assets/chat3.png",
        place: "Canada",
        time: "April 22"),
    Item(
        id: 4,
        name: "Judy Piano",
        desc: "UNSW Sydney",
        image: "assets/chat4.png",
        place: "Australia",
        time: "Nov 21"),
    Item(
        id: 5,
        name: "Justina Shoultz",
        desc: "The University of Queensland",
        image: "assets/chat5.png",
        place: "Australia",
        time: "Sept 21"),
    Item(
        id: 6,
        name: "Vinod Malhotra",
        desc: "University of Toronto",
        image: "assets/chat6.png",
        place: "Canada",
        time: "July 22"),
  ];
}

class Item {
  final int id;
  final String name;
  final String desc;
  final String image;
  final String place;
  final String time;

  Item({this.id, this.name, this.desc, this.image, this.place, this.time});
}
