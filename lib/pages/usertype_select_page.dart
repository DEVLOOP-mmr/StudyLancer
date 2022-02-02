import 'package:elite_counsel/pages/phone_login.dart';
import 'package:elite_counsel/pages/terms_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../variables.dart';

class UserTypeSelectPage extends StatelessWidget {
  const UserTypeSelectPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/user_select_back.png",
                ),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "Study Lancer",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 16),
                child: Text(
                  "It’s never been so easy!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                decoration:
                    BoxDecoration(color: Variables.backgroundColor, boxShadow: [
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
                        InkWell(
                          onTap: () {
                            Variables.sharedPreferences.put(
                                Variables.userType, Variables.userTypeStudent);
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return PhonePage();
                            }));
                          },
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Image.asset(
                                "assets/student.png",
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width / 2.2,
                              ),
                              Padding(
                                padding: EdgeInsets.all(45),
                                child: Text(
                                  "Student",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Variables.sharedPreferences.put(
                                Variables.userType, Variables.userTypeAgent);
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return PhonePage();
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
                              Padding(
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
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
