import 'dart:io';

import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/profile_bloc.dart';
import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/variables.dart';
import 'package:elite_counsel/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';

import 'agent_document_page.dart';
/// TODO: inject HomeBloc

class AgentProfilePage extends StatefulWidget {
  const AgentProfilePage({Key key}) : super(key: key);

  @override
  _AgentProfilePageState createState() => _AgentProfilePageState();
}

class _AgentProfilePageState extends State<AgentProfilePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Agent selfData = Agent();

  Future<AgentHome> initFuture;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initFuture = HomeBloc.getAgentHome();
  }

  void _showImagePicker() async {
    final result = await ImagePicker().getImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final imageName = result.path.split('/').last;

      try {
        final reference = FirebaseStorage.instance.ref(imageName);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();
        setState(() {
          selfData.photo = uri;
        });
        ProfileBloc.setAgentProfile(selfData);
        await FirebaseAuth.instance.currentUser
            .updateProfile(photoURL: selfData.photo);
      } on FirebaseException catch (e) {
        print(e);
      }
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AgentHome>(
        future: initFuture,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          selfData = snapshot.data.self;
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Variables.backgroundColor,
            appBar: AppBar(
              leading: Navigator.of(context).canPop()
                  ? IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  : null,
              backgroundColor: Colors.transparent,
              centerTitle: false,
              actions: [
                GestureDetector(
                  child: Image.asset("assets/images/menu.png"),
                  onTap: () {
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              ],
            ),
            extendBodyBehindAppBar: true,
            body: Container(
              decoration: BoxDecoration(
                  color: Color(0xff1E2224),
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/background.png",
                      ),
                      fit: BoxFit.fill)),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: InkWell(
                            onTap: () {
                              _showImagePicker();
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10.0),
                              width: 133.0,
                              height: 133.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(selfData.photo ??
                                      "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg"),
                                ),
                                boxShadow: [
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
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100.0, vertical: 16),
                          child: NeumorphicButton(
                            padding: EdgeInsets.zero,
                            child: Container(
                              color: Color(0xff294A91),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: Variables.buttonGradient,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.insert_drive_file_outlined,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "My Documents",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return AgentDocumentPage();
                              }));
                            },
                            style: NeumorphicStyle(
                                border: NeumorphicBorder(
                                    isEnabled: true,
                                    color: Variables.backgroundColor,
                                    width: 2),
                                shadowLightColor: Colors.white.withOpacity(0.6),
                                // color: Color(0xff294A91),
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(30))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 35.0, bottom: 8),
                          child: Text(
                            "Full Name*",
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto',
                                fontSize: 12),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, bottom: 8),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextFormField(
                              initialValue: selfData.name,
                              onChanged: (value) {
                                selfData.name = value;
                              },
                              validator: (value) {
                                if ((value ?? "").length < 4) {
                                  return "Please enter full name";
                                }
                                return null;
                              },
                              autocorrect: false,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'Roboto',
                                  fontSize: 12),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: 'Full Name',
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 35.0, bottom: 8),
                          child: Text(
                            "About you",
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto',
                                fontSize: 12),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, bottom: 8),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextFormField(
                              initialValue: selfData.bio,
                              onChanged: (value) {
                                selfData.bio = value;
                              },
                              validator: (value) {
                                if (value == "") {
                                  return null;
                                }
                                return null;
                              },
                              autocorrect: false,
                              minLines: 3,
                              maxLines: 3,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'Roboto',
                                  fontSize: 12),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: 'About you',
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 35.0, bottom: 8),
                          child: Text(
                            "Licence Number*",
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto',
                                fontSize: 12),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, bottom: 8),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextFormField(
                              initialValue: selfData.licenseNo,
                              onChanged: (value) {
                                selfData.licenseNo = value;
                              },
                              validator: (value) {
                                if ((value ?? "").length < 1) {
                                  return "Please enter License Number";
                                }
                                return null;
                              },
                              autocorrect: false,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'Roboto',
                                  fontSize: 12),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: Variables.sharedPreferences
                                            .get(Variables.countryCode) ==
                                        "CA"
                                    ? 'IRCC member number'
                                    : "MARA agent number",
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 35.0, bottom: 8),
                          child: Text(
                            "Enter Email*",
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto',
                                fontSize: 12),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, bottom: 8),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextFormField(
                              initialValue: selfData.email,
                              onChanged: (value) {
                                selfData.email = value;
                              },
                              validator: (value) {
                                String p =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                                RegExp regExp = new RegExp(p);
                                if (!regExp.hasMatch(value)) {
                                  return "Please enter valid email";
                                }
                                return null;
                              },
                              autocorrect: true,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'Roboto',
                                  fontSize: 12),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: 'Enter Email',
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 35.0, bottom: 8),
                          child: Text(
                            "Phone Number",
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto',
                                fontSize: 12),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, bottom: 8.0),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextFormField(
                              initialValue: selfData.phone,
                              onChanged: (value) {
                                selfData.phone = value;
                              },
                              readOnly: true,
                              autocorrect: true,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'Roboto',
                                  fontSize: 12),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: 'Phone Number',
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 35.0, bottom: 8),
                        //   child: Text(
                        //     "Date Of Birth",
                        //     style: TextStyle(
                        //         fontStyle: FontStyle.normal,
                        //         color: Colors.white,
                        //         fontWeight: FontWeight.w400,
                        //         fontFamily: 'Roboto',
                        //         fontSize: 12),
                        //   ),
                        // ),
                        // Container(
                        //   margin: const EdgeInsets.only(
                        //       left: 30.0, right: 30.0, bottom: 5),
                        //   decoration: BoxDecoration(
                        //       color: Colors.black,
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(10))),
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(left: 10),
                        //     child: DateTimeFormField(
                        //       initialValue: selfData.dob == null
                        //           ? null
                        //           : DateTime.parse(selfData.dob),
                        //       lastDate: DateTime(DateTime.now().year - 18,
                        //           DateTime.now().month),
                        //       dateTextStyle: TextStyle(
                        //           color: Colors.white,
                        //           fontStyle: FontStyle.normal,
                        //           fontFamily: 'Roboto',
                        //           fontSize: 12),
                        //       decoration: const InputDecoration(
                        //         hintText: 'Date of birth',
                        //         hintStyle: TextStyle(
                        //             fontSize: 12,
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.w400),
                        //         errorStyle: TextStyle(
                        //             fontSize: 12,
                        //             color: Colors.red,
                        //             fontWeight: FontWeight.w400),
                        //         suffixIcon: Icon(Icons.event_note),
                        //       ),
                        //       mode: DateTimeFieldPickerMode.date,
                        //       validator: (e) => (e?.day ?? 0) == 1
                        //           ? 'Please enter a date'
                        //           : null,
                        //       onDateSelected: (DateTime value) {
                        //         selfData.dob = value.toString();
                        //       },
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(left: 35.0, bottom: 8),
                          child: Text(
                            "Marital Status",
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto',
                                fontSize: 12),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, bottom: 8),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: DropdownButtonFormField(
                              validator: (value) {
                                return null;
                              },
                              hint: Text(
                                'Marital Status',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                    fontWeight: FontWeight.w400),
                              ),
                              value: selfData.maritalStatus,
                              onChanged: (value) {
                                selfData.maritalStatus = value;
                              },
                              style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'Roboto',
                                  fontSize: 12),
                              dropdownColor: Colors.black,
                              items: ["Single", "Married", "Divorced"]
                                  .map((label) => DropdownMenuItem(
                                        child: Container(
                                            color: Colors.black,
                                            child: Text(
                                              label,
                                              style: TextStyle(
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
                        Padding(
                          padding: const EdgeInsets.only(left: 35.0, bottom: 8),
                          child: Text(
                            "City*",
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto',
                                fontSize: 12),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, bottom: 8),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextFormField(
                              initialValue: selfData.city,
                              onChanged: (value) {
                                selfData.city = value;
                              },
                              validator: (value) {
                                if ((value ?? "") == "") {
                                  return "Entry city";
                                }
                                return null;
                              },
                              autocorrect: true,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'Roboto',
                                  fontSize: 12),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: 'City',
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 35.0, bottom: 8),
                          child: Text(
                            "Country*",
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto',
                                fontSize: 12),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, bottom: 8),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: DropdownButtonFormField(
                              hint: Text(
                                'Country',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                    fontWeight: FontWeight.w400),
                              ),
                              value: selfData.country,
                              onChanged: (value) {
                                selfData.country = value;
                              },
                              validator: (value) {
                                if ((value ?? "") == "") {
                                  return "Select Country";
                                }
                                return null;
                              },
                              style: TextStyle(
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
                                              style: TextStyle(
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
                        SizedBox(height: 8),
                        SafeArea(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: NeumorphicButton(
                              padding: EdgeInsets.zero,
                              child: Container(
                                color: Color(0xff294A91),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: Variables.buttonGradient,
                                  ),
                                  child: Align(
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
                              onPressed: () {
                                if (formKey.currentState.validate()) {
                                  EasyLoading.show(status: "Updating");
                                  ProfileBloc.setAgentProfile(selfData)
                                      .then((value) async {
                                    await FirebaseAuth.instance.currentUser
                                        .updateProfile(
                                            displayName: selfData.name);
                                    EasyLoading.dismiss();
                                    EasyLoading.showSuccess(
                                        "Updated Successfully");
                                  });
                                } else {
                                  EasyLoading.showError("Enter valid details");
                                }
                              },
                              style: NeumorphicStyle(
                                  border: NeumorphicBorder(
                                      isEnabled: true,
                                      color: Variables.backgroundColor,
                                      width: 2),
                                  shadowLightColor:
                                      Colors.white.withOpacity(0.6),
                                  // color: Color(0xff294A91),
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(30))),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            endDrawer: MyDrawer(),
          );
        });
  }
}
