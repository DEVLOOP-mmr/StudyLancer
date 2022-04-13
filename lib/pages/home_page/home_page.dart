
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

enum _SelectedTab { home, docs, message, profile }

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
      if (mounted) {
        setState(() {
          _selectedTab = _SelectedTab.values[i];
        });
      }
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
        ? buildStudentHomePage(context)
        : buildAgentHomePage(context);
  }

  FutureBuilder<AgentHome> buildAgentHomePage(BuildContext context) {
    return FutureBuilder<AgentHome>(
        future: HomeBloc.getAgentHome(context: context),
        builder: (context, snapshot) {
          var views = [
            Container(
              color: Variables.backgroundColor,
              child: const Center(child: CircularProgressIndicator()),
            ),
            AgentDocumentPage(),
            const RoomsPage(),
            const AgentProfilePage(),
          ];
          if (snapshot.hasData) {
            views[0] = AgentHomePage(agent: snapshot.data);
          }
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
        });
  }

  FutureBuilder<StudentHome> buildStudentHomePage(BuildContext context) {
    return FutureBuilder<StudentHome>(
        future: HomeBloc.getStudentHome(context: context),
        builder: (context, snapshot) {
          var views = [
            Container(
              color: Variables.backgroundColor,
              child: const Center(child: CircularProgressIndicator()),
            ),
            ApplicationPage(),
            const RoomsPage(),
            const StudentProfilePage(),
          ];
          if (snapshot.hasData) {
            views[0] = StudentHomePage(
              homeData: snapshot.data,
            );
          }

          return Scaffold(
            backgroundColor: Variables.backgroundColor,
            body: views[_selectedTab.index],
            bottomNavigationBar: Container(
              color: const Color(0xff1C1F22),
              child: SafeArea(
                child: buildDotNavigationBar(),
              ),
            ),
          );
        });
  }

  FloatingNavbar buildDotNavigationBar() {
    Color selected = const Color(0xffFFAC97);

    return FloatingNavbar(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      //itemPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      currentIndex: _SelectedTab.values.indexOf(_selectedTab),
      onTap: _handleIndexChanged,
      selectedBackgroundColor: Colors.transparent,
      selectedItemColor: selected,
      unselectedItemColor: Colors.transparent,
      backgroundColor: const Color(0xff1C1F22),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

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
