import 'package:flutter/material.dart';

import 'package:timelines/timelines.dart';

import 'package:elite_counsel/models/application.dart';
import 'package:elite_counsel/variables.dart';

import 'NewVideo.dart';

class ProgressPage extends StatefulWidget {
  final Application? application;
  const ProgressPage({
    Key? key,
    required this.application,
  }) : super(key: key);
  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  List<String> ausEvents = [
    "Apply offer letter",
    "Prepare GTE docs",
    "Pay tuition fees, Buy OSHC,Book medical",
    "Lodge visa",
    "Visa approved"
  ];

  List<String> canadaEvents = [
    "Apply offer letter\n\nPay tuition fees\n\nOpen Gic account\n\nOpen Gic account\n\nBook medical exam",
    "Lodge visa",
    "Book Biometric",
    "Visa approved",
    "Send passport for stamping.",
    "Prepare to fly."
  ];

  bool play = true;
  List videos = [
    "assets/vid.mp4",
    "assets/video1.mp4",
    "assets/vid.mp4",
    "assets/video1.mp4",
  ];

  bool viewVisible = false;
  Application? application;
  //video
  @override
  void initState() {
    super.initState();
    application = widget.application;
  }

  void showWidget() {
    setState(() {
      viewVisible = true;
    });
  }

  void hideWidget() {
    setState(() {
      viewVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Variables.backgroundColor,
      appBar: AppBar(
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(0),
        children: [
          Image.asset("assets/images/" +
              (Variables.sharedPreferences.get(Variables.countryCode) == "AU"
                  ? "aus_timeline.jpg"
                  : "canada_timeline.jpg")),
          const SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Image.asset(
                "assets/images/plane.png",
                height: 20,
                width: 20,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Timeline.tileBuilder(
              key: UniqueKey(),
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              theme: TimelineThemeData(
                nodePosition: 0,
                connectorTheme: const ConnectorThemeData(
                  thickness: 3.0,
                  color: Color(0xffd3d3d3),
                ),
                indicatorTheme: const IndicatorThemeData(
                  size: 15.0,
                  color: Colors.blue,
                ),
              ),
              builder: TimelineTileBuilder.fromStyle(
                contentsAlign: ContentsAlign.basic,
                connectorStyle: ConnectorStyle.dashedLine,
                indicatorStyle: IndicatorStyle.outlined,
                endConnectorStyle: ConnectorStyle.solidLine,
                contentsBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: viewVisible == false ? showWidget : hideWidget,
                        child: Text(
                          (Variables.sharedPreferences
                                      .get(Variables.countryCode) ==
                                  "AU")
                              ? ausEvents[index]
                              : canadaEvents[index],
                          style: TextStyle(
                              color: index <= application!.progress!
                                  ? Colors.white
                                  : Colors.white38,
                              fontWeight: index <= application!.progress!
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Visibility(
                          visible: viewVisible,
                          child: viewVisible == true
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                      height: 150,
                                      width: 230,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: const Videos()),
                                )
                              : Container())
                    ],
                  ),
                ),
                itemCount:
                    (Variables.sharedPreferences.get(Variables.countryCode) ==
                            "AU")
                        ? ausEvents.length
                        : canadaEvents.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
