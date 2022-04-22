import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/chat/backend/firebase_chat_bloc/firebase_chat_bloc.dart';
import 'package:elite_counsel/pages/about_us_page.dart';
import 'package:elite_counsel/pages/accomodation.dart';
import 'package:elite_counsel/pages/faq_page.dart';
import 'package:elite_counsel/pages/home_page/home_page.dart';
import 'package:elite_counsel/pages/progress_page.dart';
import 'package:elite_counsel/pages/scholarship_page.dart';
import 'package:elite_counsel/pages/usertype_select/usertype_select_page.dart';
import 'package:elite_counsel/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:salesiq_mobilisten/salesiq_mobilisten.dart';

import 'package:store_redirect/store_redirect.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  //new

  @override
  void initState() {
    super.initState();

    ZohoSalesIQ.init("Z1vo2KMwVNQqUwCGsAgqhTyNDXamuReL_in",
        "79YYpdjt9qzHu5jgOkOZDTDS2dPa8FG1TcOr2O6gNvQ2HEfKHJc2jYA5aDZqV%2F4u4Omh2YM%2BoWVVkdE0ZV9WNoHNRclocYWLBtYPa%2FT5dO252yG183hcTFS9kTIft%2BcRBw0AGGZRO%2FOV5t6YUZC%2FGZ75C4eZBqoN");
  }

  void chatButton() async {
    ZohoSalesIQ.openNewChat();
  }

  //new

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Variables.backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    "assets/logo.png",
                    height: 100,
                  ),
                ),
              ),
            ),
            InkWell(
              child: ListTile(
                trailing: const Icon(
                  FeatherIcons.home,
                  color: Variables.accentColor,
                ),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) {
                    return const HomePage();
                  }), (route) => false);
                },
                title: const Text(
                  "Home",
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                      fontSize: 16),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            if (Variables.sharedPreferences.get(Variables.userType) ==
                Variables.userTypeStudent)
              InkWell(
                child: ListTile(
                  trailing: const Icon(
                    FeatherIcons.loader,
                    color: Variables.accentColor,
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return ProgressPage();
                    }));
                  },
                  title: const Text(
                    "Progress",
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Roboto',
                        fontSize: 16),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            InkWell(
              child: ListTile(
                trailing: const Icon(
                  Icons.school_outlined,
                  color: Variables.accentColor,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return ScholarshipPage();
                  }));
                },
                title: const Text(
                  "Scholarship",
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                      fontSize: 16),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            InkWell(
              child: ListTile(
                trailing: const Icon(
                  Icons.bed_outlined,
                  color: Variables.accentColor,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return Accommodation();
                  }));
                },
                title: const Text(
                  "Accommodation",
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                      fontSize: 16),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            InkWell(
              child: ListTile(
                trailing: const Icon(
                  FeatherIcons.mousePointer,
                  color: Variables.accentColor,
                ),
                onTap: () async {
                  await canLaunch("https://studylancer.co") == true
                      ? launch("https://studylancer.co")
                      : print("Cannot open website");
                },
                title: const Text(
                  "Website",
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                      fontSize: 16),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            InkWell(
              child: ListTile(
                trailing: const Icon(
                  FeatherIcons.info,
                  color: Variables.accentColor,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return AboutUsPage();
                  }));
                },
                title: const Text(
                  "About Us",
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                      fontSize: 16),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            InkWell(
              child: ListTile(
                trailing: const Icon(
                  FeatherIcons.helpCircle,
                  color: Variables.accentColor,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return FaqPage();
                  }));
                },
                title: const Text(
                  "FAQ",
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                      fontSize: 16),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Share.share(
                    'Check out Study Lancer at https://play.google.com/store/apps/details?id=com.elite_counsel');
              },
              child: const ListTile(
                trailing: Icon(
                  FeatherIcons.share2,
                  color: Variables.accentColor,
                ),
                title: Text(
                  "Share with Friends",
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                      fontSize: 16),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                final InAppReview inAppReview = InAppReview.instance;
                if (await inAppReview.isAvailable()) {
                  inAppReview.requestReview();
                }
              },
              child: ListTile(
                trailing: const Icon(
                  FeatherIcons.star,
                  color: Variables.accentColor,
                ),
                title: InkWell(
                  onTap: () {
                    StoreRedirect.redirect(
                        androidAppId: 'com.elite_counsel',
                        iOSAppId: "com.elitecounsel");
                  },
                  child: const Text(
                    "Rate Us",
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Roboto',
                        fontSize: 16),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: chatButton,
              // onTap: () async {
              //   const url = 'mailto:helpdesk@studylancer.com';
              //   if (await canLaunch(url)) {
              //     await launch(url);
              //   } else {
              //     throw 'Could not launch $url';
              //   }
              // },
              child: const ListTile(
                trailing: Icon(
                  FeatherIcons.messageCircle,
                  color: Variables.accentColor,
                ),
                title: Text(
                  "Helpdesk",
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                      fontSize: 16),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            InkWell(
              child: ListTile(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Variables.sharedPreferences.clear();
                  BlocProvider.of<HomeBloc>(context, listen: false).reset();
                  BlocProvider.of<FirebaseChatBloc>(context, listen: false)
                      .resetLoginData();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const UserTypeSelectPage();
                    }),
                  );
                },
                trailing: const Icon(
                  FeatherIcons.logOut,
                  color: Variables.accentColor,
                ),
                title: const Text(
                  "Log Out",
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                      fontSize: 16),
                  textAlign: TextAlign.right,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
