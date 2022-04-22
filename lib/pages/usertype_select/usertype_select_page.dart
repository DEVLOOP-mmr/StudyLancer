import 'package:elite_counsel/pages/phone_login.dart';
import 'package:elite_counsel/pages/terms_page.dart';
import 'package:elite_counsel/pages/usertype_select/student_select_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../variables.dart';

class UserTypeSelectPage extends StatelessWidget {
  const UserTypeSelectPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/user_select_back.png",
                ),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  "Study Lancer",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 16),
                child: Text(
                  "It’s never been so easy!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Variables.backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Variables.backgroundColor,
                        spreadRadius: 15,
                        blurRadius: 20,
                      ),
                    ]),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const StudentSelectButton(),
                        InkWell(
                          onTap: () {
                            Variables.sharedPreferences.put(
                              Variables.userType,
                              Variables.userTypeAgent,
                            );
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return const PhonePage();
                            }));
                          },
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Image.asset(
                                "assets/agent.png",
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width / 2.2,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(45),
                                child: Text(
                                  "Agent",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return TermsPage();
                            }));
                            // Respond to button press
                          },
                          child: Text(
                            'Terms and Conditions',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                fontFamily: 'Roboto',
                                fontSize: 12),
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
