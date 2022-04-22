import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/bloc/offer_bloc.dart';
import 'package:elite_counsel/chat/backend/firebase_chat_bloc/firebase_chat_bloc.dart';
import 'package:elite_counsel/models/application.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/pages/home_page/home_page.dart';
import 'package:elite_counsel/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ionicons/ionicons.dart';

class OfferPage extends StatefulWidget {
  final Student student;
  const OfferPage({Key key, @required this.student}) : super(key: key);

  @override
  _OfferPageState createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  Application offer = Application();
  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    offer.studentID = widget.student.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Variables.backgroundColor,
      appBar: AppBar(
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
        backgroundColor: Variables.backgroundColor,
        title: const Text(
          "Create Offer",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 23, color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: Stack(
        fit: StackFit.loose,
        children: [
          Form(
            key: formKey,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: Colors.white),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/back_texture.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: SizedBox(
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: FractionallySizedBox(
                                      widthFactor: 0.6,
                                      child: Text(
                                        offer.universityName ?? "",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  // Align(
                                  //   alignment: Alignment.centerRight,
                                  //   child: FractionallySizedBox(
                                  //     widthFactor: 0.4,
                                  //     child: Container(
                                  //       decoration: BoxDecoration(
                                  //           color:
                                  //               Colors.white.withOpacity(0.4),
                                  //           borderRadius:
                                  //               BorderRadius.circular(20)),
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.all(4.0),
                                  //         child: Row(
                                  //           children: [
                                  //             CircleAvatar(
                                  //               backgroundImage: NetworkImage(),
                                  //               radius: 10,
                                  //             ),
                                  //             SizedBox(
                                  //               width: 4,
                                  //             ),
                                  //             Expanded(
                                  //               child: Text(
                                  //                 offer.agentName ?? "",
                                  //                 style: TextStyle(
                                  //                     fontWeight:
                                  //                         FontWeight.normal,
                                  //                     fontSize: 12,
                                  //                     color: Colors.white),
                                  //                 maxLines: 1,
                                  //                 overflow:
                                  //                     TextOverflow.ellipsis,
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                offer.courseName ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 14,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            backgroundColor:
                                                Variables.backgroundColor,
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
                                                  offer.description ?? "",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ));
                                },
                                child: const Text(
                                  "Additional Details",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 10,
                                      color: Colors.white),
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  const RotatedBox(
                                    quarterTurns: 3,
                                    child: Icon(
                                      Ionicons.send,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    (offer.city ?? "") + ", ",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    offer.country ?? "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "\$" + (offer.courseFees ?? "0"),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                  const Text(
                                    "/yr",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 10,
                                        color: Colors.white),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        "University Name",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            fontSize: 12),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          initialValue: offer.universityName,
                          onChanged: (value) {
                            setState(() {
                              offer.universityName = value;
                            });
                          },
                          validator: (value) {
                            if (value == "") {
                              return "Enter university name";
                            }
                            return null;
                          },
                          autocorrect: false,
                          style: const TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Roboto',
                              fontSize: 12),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'University Name',
                            hintStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.white54,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Course Name",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            fontSize: 12),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          initialValue: offer.courseName,
                          onChanged: (value) {
                            setState(() {
                              offer.courseName = value;
                            });
                          },
                          validator: (value) {
                            if (value == "") {
                              return "Enter course name";
                            }
                            return null;
                          },
                          autocorrect: false,
                          style: const TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Roboto',
                              fontSize: 12),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Course Name',
                            hintStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.white54,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Course link",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            fontSize: 12),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          initialValue: offer.courseLink,
                          onChanged: (value) {
                            setState(() {
                              offer.courseLink = value;
                            });
                          },
                          validator: (value) {
                            if (value == "") {
                              return "Enter course link";
                            }
                            return null;
                          },
                          autocorrect: false,
                          style: const TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Roboto',
                              fontSize: 12),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Course link',
                            hintStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.white54,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Description",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            fontSize: 12),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          initialValue: offer.description,
                          onChanged: (value) {
                            setState(() {
                              offer.description = value;
                            });
                          },
                          validator: (value) {
                            if (value == "") {
                              return "Enter description";
                            }
                            return null;
                          },
                          autocorrect: false,
                          minLines: 3,
                          maxLines: 3,
                          style: const TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Roboto',
                              fontSize: 12),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Description',
                            hintStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.white54,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        "City",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            fontSize: 12),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          initialValue: offer.city,
                          onChanged: (value) {
                            setState(() {
                              offer.city = value;
                            });
                          },
                          validator: (value) {
                            if (value == "") {
                              return "Enter city name";
                            }
                            return null;
                          },
                          autocorrect: false,
                          style: const TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Roboto',
                              fontSize: 12),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'City',
                            hintStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.white54,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Country",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            fontSize: 12),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: DropdownButtonFormField(
                          hint: Text(
                            'Country',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w400),
                          ),
                          value: offer.country,
                          onChanged: (value) {
                            setState(() {
                              offer.country = value;
                            });
                          },
                          validator: (value) {
                            if ((value ?? "") == "") {
                              return "Select Country";
                            }
                            return null;
                          },
                          style: const TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Roboto',
                              fontSize: 12),
                          dropdownColor: Colors.black,
                          items: Variables.countries
                              .map((label) => DropdownMenuItem(
                                    child: Container(
                                        color: Colors.black,
                                        child: Text(
                                          label,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontStyle: FontStyle.normal,
                                              fontFamily: 'Roboto',
                                              fontSize: 12),
                                        )),
                                    value: label,
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Course Fees",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            fontSize: 12),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          initialValue: offer.courseFees,
                          onChanged: (value) {
                            setState(() {
                              offer.courseFees = value;
                            });
                          },
                          validator: (value) {
                            if (value == "") {
                              return "Enter course fees";
                            }
                            if (int.tryParse(value) == null) {
                              return "Enter number only";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          style: const TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Roboto',
                              fontSize: 12),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "Course Fees",
                            hintStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.white54,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Application Fees",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            fontSize: 12),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          initialValue: offer.applicationFees,
                          onChanged: (value) {
                            setState(() {
                              offer.applicationFees = value;
                            });
                          },
                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          validator: (value) {
                            if (value == "") {
                              return "Enter application fees";
                            }
                            if (int.tryParse(value) == null) {
                              return "Enter number only";
                            }
                            return null;
                          },
                          style: const TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Roboto',
                              fontSize: 12),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "Application Fees",
                            hintStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.white54,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 150,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.4))
                  ],
                  color: Variables.backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: SafeArea(
                child: NeumorphicButton(
                  padding: EdgeInsets.zero,
                  child: Container(
                    height: 50,
                    color: const Color(0xff294A91),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        gradient: Variables.buttonGradient,
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      var bloc =
                          BlocProvider.of<HomeBloc>(context, listen: false);
                      var agent = (bloc.state as AgentHomeState).agent;
                      EasyLoading.show(status: 'Creating Offer');
                      await OfferBloc.addOffer(
                        offer,
                        FirebaseAuth.instance.currentUser.uid,
                      );

                      await bloc.getAgentHome(context: context);
                      EasyLoading.dismiss();
                      var otherUser = widget.student;

                      BlocProvider.of<FirebaseChatBloc>(context, listen: false)
                          .createRoom(agent, otherUser);

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    } else {
                      EasyLoading.showError("Enter all details first");
                    }
                  },
                  style: NeumorphicStyle(
                      border: const NeumorphicBorder(
                          isEnabled: true,
                          color: Variables.backgroundColor,
                          width: 2),
                      shadowLightColor: Colors.white.withOpacity(0.6),
                      // color: Color(0xff294A91),
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(30))),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
