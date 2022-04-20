import 'package:elite_counsel/bloc/review_bloc.dart';
import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/models/agent.dart';
import 'package:elite_counsel/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class AgentDetailPage extends StatefulWidget {
  final Agent agent;
  const AgentDetailPage({Key key, this.agent}) : super(key: key);

  @override
  _AgentDetailPageState createState() => _AgentDetailPageState();
}

class _AgentDetailPageState extends State<AgentDetailPage> {
  PaletteGenerator paletteGenerator;

  @override
  void initState() {
    super.initState();
    PaletteGenerator.fromImageProvider(
      NetworkImage(widget.agent.photo ??
          "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg"),
      maximumColorCount: 20,
    ).then((value) {
      setState(() {
        paletteGenerator = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return paletteGenerator == null
        ? Container()
        : Scaffold(
            appBar: AppBar(
              leading: Navigator.of(context).canPop()
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  : null,
              backgroundColor: Colors.transparent,
            ),
            extendBodyBehindAppBar: true,
            body: Stack(
              children: [
                FractionallySizedBox(
                  heightFactor: 0.7,
                  child: Container(
                    decoration: BoxDecoration(
                      color: paletteGenerator.dominantColor.color,
                      // borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(widget.agent.photo ??
                            "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(colors: [
                      Colors.transparent,
                      paletteGenerator.dominantColor.color.withOpacity(0.1),
                      paletteGenerator.dominantColor.color,
                      paletteGenerator.dominantColor.color,
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 32.0, bottom: 46.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor: 0.8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.agent.name ?? "",
                                        style: TextStyle(
                                          fontSize: 35,
                                          color: paletteGenerator
                                              .dominantColor.titleTextColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.pin_drop_outlined,
                                            color: paletteGenerator
                                                .dominantColor.titleTextColor,
                                            size: 14,
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            (widget.agent.city ?? "") +
                                                ", " +
                                                (widget.agent.country ?? ""),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: paletteGenerator
                                                  .dominantColor.titleTextColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: FractionallySizedBox(
                                  widthFactor: 0.2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: paletteGenerator
                                            .dominantColor.titleTextColor
                                            .withOpacity(0.3),
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.star_border_purple500_sharp,
                                            color: paletteGenerator
                                                .dominantColor.titleTextColor,
                                            size: 20,
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            (widget.agent.reviewsAvg ?? ""),
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: paletteGenerator
                                                  .dominantColor.titleTextColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 32.0),
                            child: Text(
                              widget.agent.bio ?? "",
                              style: TextStyle(
                                fontSize: 14,
                                color: paletteGenerator
                                    .dominantColor.titleTextColor
                                    .withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: paletteGenerator
                                        .dominantColor.titleTextColor
                                        .withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: paletteGenerator
                                            .dominantColor.titleTextColor
                                            .withOpacity(0.7),
                                        size: 14,
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        "Since " +
                                            (widget.agent.agentSince == null
                                                ? "2021"
                                                : DateTime.parse(
                                                        widget.agent.agentSince)
                                                    .year
                                                    .toString()),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: paletteGenerator
                                              .dominantColor.titleTextColor
                                              .withOpacity(0.7),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: paletteGenerator
                                        .dominantColor.titleTextColor
                                        .withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.person_outline,
                                        color: paletteGenerator
                                            .dominantColor.titleTextColor
                                            .withOpacity(0.7),
                                        size: 14,
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        (widget.agent.applicationsHandled ??
                                                "0") +
                                            " Students",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: paletteGenerator
                                              .dominantColor.titleTextColor
                                              .withOpacity(0.7),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 32.0),
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(40),
                                            topRight: Radius.circular(40))),
                                    backgroundColor: Colors.transparent,
                                    isDismissible: true,
                                    enableDrag: true,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.62,
                                        child: FutureBuilder<AgentReviews>(
                                            future: ReviewBloc.getAgentReview(
                                                widget.agent.id,
                                                FirebaseAuth
                                                    .instance.currentUser.uid),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return DraggableScrollableSheet(
                                                    initialChildSize: 1,
                                                    builder: (context,
                                                        scrollController) {
                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.9),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          50),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          50),
                                                                )),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(32.0),
                                                          child: Stack(
                                                              children: [
                                                                ListView
                                                                    .builder(
                                                                        // shrinkWrap: true,
                                                                        controller:
                                                                            scrollController,
                                                                        itemCount:
                                                                            snapshot.data.reviews.length +
                                                                                1,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          if (index ==
                                                                              0) {
                                                                            return Column(
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      snapshot.data.reviews.length.toString() + " Reviews",
                                                                                      style: const TextStyle(color: Color(0xff919191), fontSize: 21, fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                    const Spacer(),
                                                                                    StarRating(
                                                                                      rating: double.parse(widget.agent.reviewsAvg),
                                                                                      starCount: 5,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                    Text(
                                                                                      " (" + widget.agent.reviewsAvg + ")",
                                                                                      style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Divider(
                                                                                  color: Variables.backgroundColor.withOpacity(0.6),
                                                                                )
                                                                              ],
                                                                            );
                                                                          }
                                                                          var review = snapshot
                                                                              .data
                                                                              .reviews[index - 1];
                                                                          return ListTile(
                                                                            contentPadding:
                                                                                EdgeInsets.zero,
                                                                            title:
                                                                                Text(review.reviewerName),
                                                                            subtitle:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                const SizedBox(
                                                                                  height: 8,
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    StarRating(
                                                                                      rating: double.parse(widget.agent.reviewsAvg),
                                                                                      starCount: 5,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 8,
                                                                                    ),
                                                                                    Text(Variables.fullMonthDateformat.format(DateTime.parse(review.createdAt))),
                                                                                  ],
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 8,
                                                                                ),
                                                                                Text(review.reviewContent),
                                                                                Divider(
                                                                                  color: Variables.backgroundColor.withOpacity(0.6),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        }),
                                                                // if (!snapshot.data
                                                                //     .studentHasReviewed)
                                                                //   Align(
                                                                //     alignment: Alignment
                                                                //         .bottomCenter,
                                                                //     child: ,
                                                                //   ),
                                                              ]),
                                                        ),
                                                      );
                                                    });
                                              }
                                              return Container(
                                                color: Colors.white,
                                                child: const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              );
                                            }),
                                      );
                                    });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: paletteGenerator
                                        .dominantColor.titleTextColor,
                                    borderRadius: BorderRadius.circular(40)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Text(
                                      "Reviews (" +
                                          (widget.agent.reviewCount ?? "0") +
                                          ")",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: paletteGenerator
                                            .dominantColor.titleTextColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

typedef RatingChangeCallback = void Function(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;
  final double starSize;

  const StarRating(
      {this.starCount = 5,
      this.rating = .0,
      this.onRatingChanged,
      this.color,
      this.starSize = 15});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
        size: starSize,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
        size: starSize,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
        size: starSize,
      );
    }
    return InkResponse(
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children: List.generate(
            starCount, (index) => Container(child: buildStar(context, index))));
  }
}
