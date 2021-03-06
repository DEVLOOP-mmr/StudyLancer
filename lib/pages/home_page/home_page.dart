import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/bloc/notification_bloc/notification_bloc.dart';
import 'package:elite_counsel/chat/backend/firebase_chat_bloc/firebase_chat_bloc.dart';
import 'package:elite_counsel/chat/backend/firebase_chat_bloc/firebase_chat_state.dart';
import 'package:elite_counsel/chat/rooms.dart';
import 'package:elite_counsel/pages/home_page/agent/agent_home.dart';
import 'package:elite_counsel/pages/home_page/agent/student_list_view/student_tabbed_list.dart';
import 'package:elite_counsel/pages/profile_page/agent/agent_profile_page.dart';
import 'package:elite_counsel/pages/applications_page/applications_page.dart';
import 'package:elite_counsel/pages/home_page/student/student_home.dart';
import 'package:elite_counsel/pages/profile_page/student/student_profile_page.dart';
import 'package:elite_counsel/pages/tutorial_pages.dart';
import 'package:elite_counsel/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum _SelectedTab { home, docs, message, profile }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
  void initState() {
    super.initState();
    if (Variables.sharedPreferences.get(Variables.userType) ==
        Variables.userTypeStudent) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        var bloc = BlocProvider.of<HomeBloc>(context, listen: false);
        await bloc.getStudentHome(context: context);
        var isStudentVerified =
            ((bloc.state.studentHomeState().student?.verified) ?? false);
        if (bloc.state is StudentHomeState && (!isStudentVerified)) {
          NotificationCubit.sendNotificationToUser(
            'Upload Required Documents',
            'Get verified to start applying',
            FirebaseAuth.instance.currentUser!.uid,
          );
        }
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        BlocProvider.of<HomeBloc>(context, listen: false)
            .getAgentHome(context: context);
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
        ? buildStudentHomePage(context)
        : buildAgentHomePage(context);
  }

  Widget buildAgentHomePage(BuildContext context) {
    var views = [
      AgentHomePage(
        key: UniqueKey(),
      ),
      const StudentTabbedList(
        showOnlyOngoingApplications: true,
      ),
      const RoomsPage(),
      const AgentProfilePage(),
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
  }

  Widget buildStudentHomePage(BuildContext context) {
    var views = [
      const StudentHomePage(),
      const ApplicationPage(),
      const RoomsPage(),
      const StudentProfilePage(),
    ];

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
  }

  FloatingNavbar buildDotNavigationBar() {
    Color selected = const Color(0xffFFAC97);

    return FloatingNavbar(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      currentIndex: _SelectedTab.values.indexOf(_selectedTab),
      onTap: _handleIndexChanged,
      selectedBackgroundColor: Colors.transparent,
      selectedItemColor: selected,
      unselectedItemColor: Colors.transparent,
      backgroundColor: const Color(0xff1C1F22),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
            customWidget: Container(
              height: 50,
              width: 70,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      "assets/images/chat_icon.svg",
                      height: 25,
                      width: 30,
                      color: Variables.accentColor,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                      right: 15,
                      top: 10,
                      child: BlocBuilder<FirebaseChatBloc, FirebaseChatState>(
                        builder: (context, state) {
                          return state.totalUnreadMessageCount == 0
                              ? Container()
                              : CircleAvatar(
                                  radius: 6,
                                  backgroundColor: Colors.black,
                                  child: Center(
                                      child: Text(
                                    state.totalUnreadMessageCount == 0
                                        ? ''
                                        : state.totalUnreadMessageCount
                                            .toString(),
                                    style: TextStyle(
                                        color: Variables.accentColor,
                                        fontSize: 10),
                                  )),
                                );
                        },
                      ))
                ],
              ),
            ),
            title: "Chats"),

        /// Profile
        FloatingNavbarItem(
            customWidget: Image.asset(
              "assets/images/newprofile.png",
              height: 20,
              width: 20,
            ),
            title: 'Profile'),
      ],
    );
  }
}
