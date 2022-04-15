import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/pages/profile_page/agent/agent_profile_page.dart';
import 'package:elite_counsel/pages/student_detail_page.dart';
import 'package:elite_counsel/variables.dart';
import 'package:elite_counsel/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:accordion/accordion.dart';

class AgentHomePage extends StatefulWidget {
  const AgentHomePage({Key key}) : super(key: key);

  @override
  _AgentHomePageState createState() => _AgentHomePageState();
}

class Country {
  final String image;
  final String name;

  Country(this.image, this.name);
}

class _AgentHomePageState extends State<AgentHomePage>
    with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String country;

  TabController _tabController;

  List<Country> data = [
    Country("assets/images/taj.png", "India"),
    Country("assets/images/pakistan.png", "Pakistan"),
    Country("assets/images/nepal.png", "Nepal"),
    Country("assets/images/bangladesh.png", "Bangladesh"),
  ];
  Student selfData = Student();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Variables.backgroundColor,
      endDrawer: MyDrawer(),
      appBar: AppBar(
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
        backgroundColor: Variables.backgroundColor,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AgentProfilePage()));
            },
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is! AgentHomeState) {
                  return Container();
                }
                final agentHomePageState = state as AgentHomeState;
                final agent = agentHomePageState.agent;
                return agent == null
                    ? Container()
                    : Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: CachedNetworkImage(
                          imageUrl: agent.photo ??
                              "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg",
                          fit: BoxFit.cover,
                          height: 25,
                          width: 25,
                        ),
                      );
              },
            ),
          ),
          GestureDetector(
            child: Image.asset("assets/images/menu.png"),
            onTap: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
          )
        ],
        title: Text(
          "Study Lancer",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: <Color>[Color(0xffFF8B86), Color(0xffAE78BE)],
                ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))),
        ),
      ),
      body: Container(
        child: country == null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    color: Variables.backgroundColor,
                    shadowLightColor: Colors.white.withOpacity(0.3),
                    lightSource: LightSource.topLeft.copyWith(dx: -2, dy: -2),
                    depth: -1,
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 15,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        country = data[index].name;
                                      });
                                    },
                                    child: AspectRatio(
                                        aspectRatio: 1 / 2,
                                        child: Image.asset(
                                          data[index].image,
                                          fit: BoxFit.contain,
                                        )));
                              }),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    country = "All";
                                  });
                                },
                                child: AspectRatio(
                                  aspectRatio: 324 / 177,
                                  child: Image.asset(
                                    "assets/images/seeall.png",
                                    fit: BoxFit.contain,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : AllCountryWidget(context),
      ),
    );
  }

  Widget AllCountryWidget(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is! AgentHomeState) {
          return Container(
            child: CircularProgressIndicator(),
          );
        }
        final agentHomePageState = state as AgentHomeState;
        final agent = agentHomePageState.agent;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                setState(() {
                  country = null;
                });
              },
            ),
            actions: [
              InkWell(
                onTap: () async {
                  var result = await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => Container(
                            height: 300,
                            child: Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: Variables.backgroundColor,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Accordion(
                                    maxOpenSections: 1,
                                    headerBackgroundColor:
                                        Variables.backgroundColor,
                                    contentBackgroundColor:
                                        Variables.backgroundColor,
                                    children: [
                                      AccordionSection(
                                          header: Text(
                                            "Sort by Courses Fees",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontStyle: FontStyle.normal,
                                                fontFamily: "roboto"),
                                          ),
                                          content: Column(
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop("asc");
                                                },
                                                child: Text(
                                                  "Ascending",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop("desc");
                                                },
                                                child: Text(
                                                  "Descending",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                      AccordionSection(
                                          header: Text(
                                            "Sort by Tuition Fees",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontStyle: FontStyle.normal,
                                                fontFamily: "roboto"),
                                          ),
                                          content: Column(
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop("asc");
                                                },
                                                child: Text(
                                                  "Ascending",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop("desc");
                                                },
                                                child: Text(
                                                  "Descending",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                      AccordionSection(
                                          header: Text(
                                            "Sort by Application Fees",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontStyle: FontStyle.normal,
                                                fontFamily: "roboto"),
                                          ),
                                          content: Column(
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop("asc");
                                                },
                                                child: Text(
                                                  "Ascending",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop("desc");
                                                },
                                                child: Text(
                                                  "Descending",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ));
                  if (result != null) {
                    if (result == "asc") {
                      setState(() {
                        selfData.previousOffers.sort((a, b) =>
                            (int.parse(a.courseFees))
                                .compareTo((int.parse(b.courseFees))));
                      });
                    } else if (result == "desc") {
                      setState(() {
                        selfData.previousOffers.sort((b, a) =>
                            (int.parse(a.courseFees))
                                .compareTo((int.parse(b.courseFees))));
                      });
                    }
                  }
                },
                child: Row(
                  children: [
                    InkWell(
                      child: Container(
                        child: Image.asset(
                          "assets/images/Sort.png",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 25,
                        left: 08,
                      ),
                      child: InkWell(
                        child: Container(
                          child: Text(
                            "Sort",
                            style: TextStyle(
                                color: Color(0xffFFAC97),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
            backgroundColor: Variables.backgroundColor,
            centerTitle: false,
            title: Text(
              country.toUpperCase(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            bottom: TabBar(
              labelColor: Variables.accentColor,
              indicatorColor: Colors.transparent,
              unselectedLabelColor: Colors.white.withOpacity(0.6),
              isScrollable: true,
              controller: _tabController,
              tabs: [
                Tab(
                  text: "Awaiting",
                ),
                Tab(
                  text: "Options Provided",
                ),
                Tab(
                  text: "Ongoing",
                ),
              ],
            ),
          ),
          backgroundColor: Variables.backgroundColor,
          body: TabBarView(
            controller: _tabController,
            children: [
              ListView.builder(
                  itemCount: agentHomePageState.students.where((element) {
                    if (element.optionStatus == 1) {
                      return true;
                    }
                    return false;
                  }).length,
                  itemBuilder: (context, index) {
                    var student = agentHomePageState.students.where((element) {
                      if (element.optionStatus == 1) {
                        return true;
                      }
                      return false;
                    }).toList()[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Neumorphic(
                        style: NeumorphicStyle(
                            shadowLightColor: Colors.white.withOpacity(0.6),
                            depth: -1,
                            lightSource:
                                LightSource.topLeft.copyWith(dx: -2, dy: -2),
                            shadowDarkColor: Colors.black,
                            color: Variables.backgroundColor),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return StudentDetailPage(
                                student: student,
                              );
                            }));
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.all(8),
                                leading: Container(
                                  height: 70,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: NetworkImage(student.photo ??
                                          "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  (student.name ?? "") != ""
                                      ? (student.name.trim() ?? "")
                                      : "No name",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      student.course + " . " + student.year,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.4),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color:
                                              Colors.white.withOpacity(0.04)),
                                      child: Text(
                                        "Applying for " + student.applyingFor,
                                        style: TextStyle(
                                            color: Variables.accentColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (student.marksheet != null)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GridView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: student.marksheet.length * 2,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  student.marksheet.length,
                                              childAspectRatio: 2),
                                      itemBuilder: (context, index) {
                                        var markData = student.marksheet.keys
                                            .toList(growable: true);
                                        student.marksheet.values
                                            .forEach((element) {
                                          markData.add(element.toString());
                                        });
                                        return Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Variables.accentColor
                                                    .withOpacity(0.2)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              markData[index],
                                              style: TextStyle(
                                                  color: Variables.accentColor),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              ListView.builder(
                  itemCount: agentHomePageState.students.where((element) {
                    if (element.optionStatus == 0) {
                      return true;
                    }
                    return false;
                  }).length,
                  itemBuilder: (context, index) {
                    var student = agentHomePageState.students.where((element) {
                      if (element.optionStatus == 0) {
                        return true;
                      }
                      return false;
                    }).toList()[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Neumorphic(
                        style: NeumorphicStyle(
                            shadowLightColor: Colors.white.withOpacity(0.6),
                            color: Variables.backgroundColor),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return StudentDetailPage(
                                student: student,
                              );
                            }));
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.all(8),
                                leading: Container(
                                  height: 70,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: NetworkImage(student.photo ??
                                          "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  (student.name ?? "") != ""
                                      ? (student.name.trim() ?? "")
                                      : "No name",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      student.course + " . " + student.year,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.4),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color:
                                              Colors.white.withOpacity(0.04)),
                                      child: Text(
                                        "Applying for " + student.applyingFor,
                                        style: TextStyle(
                                            color: Variables.accentColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (student.marksheet != null)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GridView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: student.marksheet.length * 2,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  student.marksheet.length,
                                              childAspectRatio: 2),
                                      itemBuilder: (context, index) {
                                        var markData = student.marksheet.keys
                                            .toList(growable: true);
                                        student.marksheet.values
                                            .forEach((element) {
                                          markData.add(element.toString());
                                        });
                                        return Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Variables.accentColor
                                                    .withOpacity(0.2)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              markData[index],
                                              style: TextStyle(
                                                  color: Variables.accentColor),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              ListView.builder(
                  itemCount: agentHomePageState.students.where((element) {
                    if (element.optionStatus == 2) {
                      return true;
                    }
                    return false;
                  }).length,
                  itemBuilder: (context, index) {
                    var student = agentHomePageState.students.where((element) {
                      if (element.optionStatus == 2) {
                        return true;
                      }
                      return false;
                    }).toList()[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Neumorphic(
                        style: NeumorphicStyle(
                            shadowLightColor: Colors.white.withOpacity(0.6),
                            color: Variables.backgroundColor),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return StudentDetailPage(
                                student: student,
                              );
                            }));
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.all(8),
                                leading: Container(
                                  height: 70,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: NetworkImage(student.photo ??
                                          "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  (student.name ?? "") != ""
                                      ? (student.name.trim() ?? "")
                                      : "No name",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      student.course + " . " + student.year,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.4),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color:
                                              Colors.white.withOpacity(0.04)),
                                      child: Text(
                                        "Applying for " + student.applyingFor,
                                        style: TextStyle(
                                            color: Variables.accentColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (student.marksheet != null)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GridView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: student.marksheet.length * 2,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  student.marksheet.length,
                                              childAspectRatio: 2),
                                      itemBuilder: (context, index) {
                                        var markData = student.marksheet.keys
                                            .toList(growable: true);
                                        student.marksheet.values
                                            .forEach((element) {
                                          markData.add(element.toString());
                                        });
                                        return Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Variables.accentColor
                                                    .withOpacity(0.2)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              markData[index],
                                              style: TextStyle(
                                                  color: Variables.accentColor),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        );
      },
    );
  }
}
