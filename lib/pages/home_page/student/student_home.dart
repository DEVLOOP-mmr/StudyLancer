import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite_counsel/bloc/country_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/pages/agent_list_page.dart';
import 'package:elite_counsel/pages/document_page/student/student_document_page.dart';

import 'package:elite_counsel/pages/profile_page/student/student_profile_page.dart';
import 'package:elite_counsel/variables.dart';
import 'package:elite_counsel/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../agent_details_page_view.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({
    Key key,
  }) : super(key: key);

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PageController _countryPageController;
  Country country = Country();
  @override
  void initState() {
    super.initState();
    _countryPageController = PageController();
    if (country.images == null) {
      CountryBloc.getCountries().then((countries) {
        if (countries.isEmpty) {
          countries = [
            Country(id: 'CA', countryName: 'Canada'),
            Country(id: 'AU', countryName: 'Australia')
          ];
        }

        if (mounted) {
          setState(() {
            country = countries.firstWhere((element) =>
                element.id ==
                Variables.sharedPreferences.get(
                  Variables.countryCode,
                  defaultValue: 'CA',
                ));
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Variables.backgroundColor,
      endDrawer: MyDrawer(),
      appBar: AppBar(
        leading: null,
        backgroundColor: Variables.backgroundColor,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const StudentProfilePage()));
            },
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is InitialHomeState) {
                  return Container();
                }
                StudentHomeState studentHomeState = state as StudentHomeState;
                return state.loadState == LoadState.loading ||
                        studentHomeState.student == null
                    ? Container()
                    : Container(
                        height: 25,
                        width: 25,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.network(
                          studentHomeState.student.photo ??
                              "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg",
                          fit: BoxFit.contain,
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
                ..shader = const LinearGradient(
                  colors: <Color>[Color(0xffFF8B86), Color(0xffAE78BE)],
                ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))),
        ),
      ),
      body: Container(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is InitialHomeState) {
              return Center(
                child: Container(
                  child: const CircularProgressIndicator(),
                ),
              );
            }
            final studentHomeState = state as StudentHomeState;
            if (studentHomeState.student == null) {
              return Center(
                child: Container(
                  child: const CircularProgressIndicator(),
                ),
              );
            }
            return state.loadState == LoadState.loading
                ? Center(
                    child: Container(
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : ListView(
                    children: [
                      CountryImages(),
                      // (studentHomeState.self.otherDoc ?? []).length < 3
                      //     ?
                      if (!(state as StudentHomeState).student.verified)
                        const UploadRequiredDocumentsPrompt(),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Our Expert Agents",
                          style: TextStyle(
                            fontSize: 18,
                            color: Variables.accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 240,
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xff131618),
                              spreadRadius: -10,
                              blurRadius: 45.0,
                            ),
                            BoxShadow(
                              color: Color(0xff131618),
                              offset: Offset(-6, -5),
                              spreadRadius: 0,
                              blurRadius: 45.0,
                            ),
                          ],
                          border: Border.all(
                            width: 10,
                            color: const Color(0xff1C1F22),
                          ),
                          // color: Color(0xff1E2022),
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: min(
                              (studentHomeState.agents ?? []).length + 1, 6),
                          itemBuilder: (context, index) {
                            if (index ==
                                min((studentHomeState.agents ?? []).length,
                                    5)) {
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: NeumorphicButton(
                                  provideHapticFeedback: false,
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return AgentListPage(
                                        agents: studentHomeState.agents,
                                      );
                                    }));
                                  },
                                  style: NeumorphicStyle(
                                    shadowLightColor:
                                        Colors.white.withOpacity(0.6),
                                    color: Colors.transparent,
                                    depth: 2,
                                  ),
                                  child: Container(
                                    height: 220,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      color: Variables.backgroundColor,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Neumorphic(
                                            style: NeumorphicStyle(
                                                shadowLightColor: Colors.white
                                                    .withOpacity(0.6),
                                                color:
                                                    Variables.backgroundColor,
                                                boxShape:
                                                    const NeumorphicBoxShape
                                                        .circle()),
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.arrow_forward,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            "See all",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                  depth: 0,
                                  shadowLightColor:
                                      Colors.white.withOpacity(0.6),
                                  color: Colors.transparent,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    //this one
                                    Future.delayed(const Duration(seconds: 0),
                                        () {
                                      if (studentHomeState.agents[index] !=
                                          null) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AgentDetailsPageView(
                                                      agents: studentHomeState
                                                          .agents,
                                                      pageNumber: index,
                                                    )));
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 180,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      // borderRadius: BorderRadius.circular(16),
                                      image: DecorationImage(
                                        image: NetworkImage(studentHomeState
                                                .agents[index].photo ??
                                            "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        // borderRadius: BorderRadius.circular(16),
                                        gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              Colors.black
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Spacer(),
                                            Text(
                                              studentHomeState
                                                      .agents[index].name ??
                                                  "",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              (studentHomeState.agents[index]
                                                          .applicationsHandled ??
                                                      "0") +
                                                  " Students",
                                              style: const TextStyle(
                                                fontSize: 7,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .star_border_purple500_sharp,
                                                  color: Colors.white
                                                      .withOpacity(0.6),
                                                  size: 10,
                                                ),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                Text(
                                                  (studentHomeState
                                                              .agents[index]
                                                              .reviewsAvg ??
                                                          "") +
                                                      " (" +
                                                      (studentHomeState
                                                              .agents[index]
                                                              .reviewCount ??
                                                          "0") +
                                                      " Reviews)",
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    color: Colors.white
                                                        .withOpacity(0.6),
                                                    fontWeight: FontWeight.w200,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  Widget CountryImages() {
    return SizedBox(
      height: 354,
      child: PageView.builder(
        controller: _countryPageController,
        itemCount: (country.images ?? []).length,
        itemBuilder: (context, index) {
          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            backgroundColor: Variables.backgroundColor,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Description",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  country.images[index].description,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Container(
                    height: 354,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                        ),
                        BoxShadow(
                          color: Colors.black,
                          spreadRadius: -12.0,
                          blurRadius: 12.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: CachedNetworkImage(
                      imageUrl: country.images[index].image,
                      cacheKey: country.images[index].image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _countryPageController.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.33),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.keyboard_arrow_left_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        _countryPageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.33),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.keyboard_arrow_right_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class UploadRequiredDocumentsPrompt extends StatelessWidget {
  const UploadRequiredDocumentsPrompt({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const StudentDocumentPage();
          }));
        },
        child: Container(
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 16),
            child: Text(
              "Please upload your documents in order to proceed further",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              image: const DecorationImage(
                  image: AssetImage("assets/images/back_texture.png")),
              color: const Color(0xff59B298)),
        ),
      ),
    );
  }
}
