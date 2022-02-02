import 'dart:async';
import 'dart:math';

import 'package:elite_counsel/bloc/country_bloc.dart';
import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/pages/agent_list_page.dart';
import 'package:elite_counsel/pages/student_document_page.dart';
import 'package:elite_counsel/pages/student_profile_page.dart';
import 'package:elite_counsel/variables.dart';
import 'package:elite_counsel/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ripple_navigation/ripple_navigation.dart';
import 'agent_details_page_view.dart';

class StudentHomePage extends StatefulWidget {
  final StudentHome homeData;
  const StudentHomePage({Key key, @required this.homeData}) : super(key: key);

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //new


  //
  //
  //
  //
  //   );
  // }


  //new
  PageController _countryPageController;
  Country country = Country();
  @override
  void initState() {

    super.initState();
    _countryPageController = PageController();
    CountryBloc.getSelfCountry().then((value) {
      if (mounted)
        setState(() {
          country = value;
        });
    });
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => StudentProfilePage()));
            },
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                widget.homeData.self.photo ??
                    "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg",
                fit: BoxFit.contain,
                height: 25,
                width: 25,
              ),
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
        child: ListView(
          children: [
            Container(
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
                                        Text(
                                          "Description",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          country.images[index].description,
                                          style: TextStyle(
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
                              boxShadow: [
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
                            child: Image.network(
                              country.images[index].image,
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
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeIn);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.33),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.keyboard_arrow_left_sharp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () {
                                _countryPageController.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeIn);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.33),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.keyboard_arrow_right_sharp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 24,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // (widget.homeData.self.otherDoc ?? []).length < 3
            //     ?
            if (!widget.homeData.self.verified)
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return StudentDocumentPage();
                    }));
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35.0, vertical: 16),
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
                        image: DecorationImage(
                            image:
                                AssetImage("assets/images/back_texture.png")),
                        color: Color(0xff59B298)),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20.0),
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
              margin: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                boxShadow: [
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
                  color: Color(0xff1C1F22),
                ),
                // color: Color(0xff1E2022),
                borderRadius: BorderRadius.circular(22.0),
              ),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics (),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: min((widget.homeData.agents ?? []).length + 1, 6),
                itemBuilder: (context, index) {
                  if (index == min((widget.homeData.agents ?? []).length, 5)) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: NeumorphicButton(
                        provideHapticFeedback: false,
                        padding: EdgeInsets.zero,

                        onPressed:(){

                          Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return AgentListPage(
                            agents: widget.homeData.agents,
                          );
                        }));},

                        style: NeumorphicStyle(
                          shadowLightColor: Colors.white.withOpacity(0.6),
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
                                      shadowLightColor:
                                          Colors.white.withOpacity(0.6),
                                      color: Variables.backgroundColor,
                                      boxShape: NeumorphicBoxShape.circle()),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
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
                    padding: EdgeInsets.all(10),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: 0,
                        shadowLightColor: Colors.white.withOpacity(0.6),
                        color: Colors.transparent,
                      ),
                      child: InkWell(
                        onTap: () {
                          //this one
                          Future.delayed(const Duration(seconds: 0),(){
                          if (widget.homeData.agents[index] != null) {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context)=>
                                AgentDetailsPageView(
                                agents: widget.homeData.agents,
                                pageNumber: index,
                              )
                            ));
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
                              image: NetworkImage(widget
                                      .homeData.agents[index].photo ??
                                  "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                  colors: [Colors.transparent, Colors.black],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Spacer(),
                                  Text(
                                    widget.homeData.agents[index].name ?? "",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    (widget.homeData.agents[index]
                                                .applicationsHandled ??
                                            "0") +
                                        " Students",
                                    style: TextStyle(
                                      fontSize: 7,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star_border_purple500_sharp,
                                        color: Colors.white.withOpacity(0.6),
                                        size: 10,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        (widget.homeData.agents[index]
                                                    .reviewsAvg ??
                                                "") +
                                            " (" +
                                            (widget.homeData.agents[index]
                                                    .reviewCount ??
                                                "0") +
                                            " Reviews)",
                                        style: TextStyle(
                                          fontSize: 8,
                                          color: Colors.white.withOpacity(0.6),
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
        ),
      ),
    );
  }
}
