import 'dart:developer';

import 'package:elite_counsel/bloc/home_bloc.dart';
import 'package:elite_counsel/chat/rooms.dart';
import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/pages/agent_document_page.dart';
import 'package:elite_counsel/pages/agent_home.dart';
import 'package:elite_counsel/pages/agent_profile_page.dart';
import 'package:elite_counsel/pages/applications_page.dart';
import 'package:elite_counsel/pages/student_home.dart';
import 'package:elite_counsel/pages/student_profile_page.dart';
import 'package:elite_counsel/pages/tutorial_pages.dart';
import 'package:elite_counsel/variables.dart';
import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _SelectedTab _selectedTab = _SelectedTab.home;

  void _handleIndexChanged(int i) {
    if (_selectedTab == _SelectedTab.values[i]) {
    } else {
      if (mounted)
        setState(() {
          _selectedTab = _SelectedTab.values[i];
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Variables.sharedPreferences
            .get(Variables.isFirstTime, defaultValue: true) &&
        (Variables.sharedPreferences.get(Variables.userType) ==
            Variables.userTypeStudent)) {
      Future.delayed(Duration.zero, () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return TutorialPage();
        })).then((value) {
          setState(() {});
        });
      });
    }
    return Variables.sharedPreferences.get(Variables.userType) ==
            Variables.userTypeStudent
        ? FutureBuilder<StudentHome>(
            future: HomeBloc.getStudentHome(context: context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.self is Null) {
                  return Container(
                    color: Variables.backgroundColor,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (!snapshot.data.self.isValid()) {
                  return Container(
                    color: Variables.backgroundColor,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                var views = [
                  StudentHomePage(
                    homeData: snapshot.data,
                  ),
                  ApplicationPage(),
                  RoomsPage(),
                  StudentProfilePage(),
                ];
                return Scaffold(
                  backgroundColor: Variables.backgroundColor,
                  body: views[_selectedTab.index],
                  bottomNavigationBar: Container(
                    color: Color(0xff1C1F22),
                    child: SafeArea(
                      child: buildDotNavigationBar(),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                EasyLoading.showError(snapshot.error.toString());
                return Container(
                  color: Variables.backgroundColor,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return Container(
                    color: Variables.backgroundColor,
                    child: Center(child: CircularProgressIndicator()));
              }
            })
        : FutureBuilder<AgentHome>(
            future: HomeBloc.getAgentHome(context: context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var views = [
                  AgentHomePage(agent: snapshot.data),
                  AgentDocumentPage(),
                  RoomsPage(),
                  AgentProfilePage(),
                ];
                return Scaffold(
                  backgroundColor: Variables.backgroundColor,
                  body: views[_selectedTab.index],
                  bottomNavigationBar: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 4,
                            spreadRadius: 2,
                            color: Colors.black.withOpacity(0.4))
                      ],
                      color: Variables.backgroundColor,
                    ),
                    child: SafeArea(
                      child: buildDotNavigationBar(),
                    ),
                  ),
                );
              } else {
                return Container(
                    color: Variables.backgroundColor,
                    child: Center(child: CircularProgressIndicator()));
              }
            });
  }

  FloatingNavbar buildDotNavigationBar() {
    Color selected = Color(0xffFFAC97);
    Color notSelected = Color(0xffFFAC97);
    return FloatingNavbar(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      //itemPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      currentIndex: _SelectedTab.values.indexOf(_selectedTab),
      onTap: _handleIndexChanged,
      selectedBackgroundColor: Colors.transparent,
      selectedItemColor: selected,
      unselectedItemColor: Colors.transparent,
      backgroundColor: Color(0xff1C1F22),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),

      // dotIndicatorColor: Colors.black,
      items: [
        /// Home
        FloatingNavbarItem(
          title: "Home",
          customWidget: Image.asset(
            "assets/images/newHome.png",
            height: 20,
            width: 20,
          ),
        ),

        /// Likes
        FloatingNavbarItem(
          customWidget: Image.asset(
            "assets/images/newmenu.png",
            height: 20,
            width: 20,
          ),
          title: "Application",
        ),

        /// Search
        FloatingNavbarItem(
            customWidget: Image.asset(
              "assets/images/newchats.png",
              height: 20,
              width: 20,
            ),
            title: "chats"),

        /// Profile
        FloatingNavbarItem(
            customWidget: Image.asset(
              "assets/images/newprofile.png",
              height: 20,
              width: 20,
            ),
            title: 'profile'),
      ],
    );
  }
}

enum _SelectedTab { home, docs, message, profile }
