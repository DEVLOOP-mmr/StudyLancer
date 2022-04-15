import 'dart:io';

import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/bloc/profile_bloc.dart';
import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/variables.dart';
import 'package:elite_counsel/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';

import 'document_page/agent/agent_document_page.dart';

class AgentProfilePage extends StatelessWidget {
  AgentProfilePage({Key key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  void _showImagePicker(BuildContext context) async {
    var bloc = BlocProvider.of<HomeBloc>(context, listen: false);
    var agent = (bloc.state as AgentHomeState).agent;
    final result = await ImagePicker().pickImage(
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



        agent.photo = uri;
        bloc.emitNewAgent(agent);
        ProfileBloc.setAgentProfile(agent)
            .then((value) => bloc.getAgentHome(context: context));
      } on FirebaseException catch (e) {
        EasyLoading.showInfo(e.message);
      }
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state.loadState == LoadState.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      final agent = (state as AgentHomeState).agent;
      return Scaffold(
        key: _scaffoldKey,
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
          decoration: const BoxDecoration(
              color: Color(0xff1E2224),
              image: DecorationImage(
                  image: const AssetImage(
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
                          _showImagePicker(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          width: 133.0,
                          height: 133.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(agent.photo ??
                                  "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg"),
                            ),
                            boxShadow: [
                              const BoxShadow(
                                color: Color(0xff131618),
                                offset: const Offset(-6, -5),
                                spreadRadius: 0,
                                blurRadius: 45.0,
                              ),
                            ],
                            border: Border.all(
                              width: 10,
                              color: const Color(0xff1C1F22),
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
                          color: const Color(0xff294A91),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: Variables.buttonGradient,
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.insert_drive_file_outlined,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
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
                    const Padding(
                      padding: EdgeInsets.only(left: 35.0, bottom: 8),
                      child: const Text(
                        "Full Name*",
                        style: const TextStyle(
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
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          initialValue: agent.name,
                          onChanged: (value) {
                            agent.name = value;
                          },
                          validator: (value) {
                            if ((value ?? "").length < 4) {
                              return "Please enter full name";
                            }
                            return null;
                          },
                          autocorrect: false,
                          style: const TextStyle(
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
                    const Padding(
                      padding: EdgeInsets.only(left: 35.0, bottom: 8),
                      child: const Text(
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
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          initialValue: agent.bio,
                          onChanged: (value) {
                            agent.bio = value;
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
                          style: const TextStyle(
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
                    const Padding(
                      padding: EdgeInsets.only(left: 35.0, bottom: 8),
                      child: const Text(
                        "Licence Number*",
                        style: const TextStyle(
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
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          initialValue: agent.licenseNo,
                          onChanged: (value) {
                            agent.licenseNo = value;
                          },
                          validator: (value) {
                            if ((value ?? "").length < 1) {
                              return "Please enter License Number";
                            }
                            return null;
                          },
                          autocorrect: false,
                          style: const TextStyle(
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
                    const Padding(
                      padding: EdgeInsets.only(left: 35.0, bottom: 8),
                      child: const Text(
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
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          initialValue: agent.email,
                          onChanged: (value) {
                            agent.email = value;
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
                          style: const TextStyle(
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
                    const Padding(
                      padding: EdgeInsets.only(left: 35.0, bottom: 8),
                      child: const Text(
                        "Phone Number",
                        style: const TextStyle(
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
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          initialValue: agent.phone,
                          onChanged: (value) {
                            agent.phone = value;
                          },
                          readOnly: true,
                          autocorrect: true,
                          style: const TextStyle(
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
                    //       initialValue: agent.dob == null
                    //           ? null
                    //           : DateTime.parse(agent.dob),
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
                    //         agent.dob = value.toString();
                    //       },
                    //     ),
                    //   ),
                    // ),
                    const Padding(
                      padding: EdgeInsets.only(left: 35.0, bottom: 8),
                      child: const Text(
                        "Marital Status",
                        style: const TextStyle(
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
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(const Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                          value: agent.maritalStatus,
                          onChanged: (value) {
                            agent.maritalStatus = value;
                          },
                          style: const TextStyle(
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
                      padding: EdgeInsets.only(left: 35.0, bottom: 8),
                      child: const Text(
                        "City*",
                        style: const TextStyle(
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
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(const Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          initialValue: agent.city,
                          onChanged: (value) {
                            agent.city = value;
                          },
                          validator: (value) {
                            if ((value ?? "") == "") {
                              return "Entry city";
                            }
                            return null;
                          },
                          autocorrect: true,
                          style: const TextStyle(
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
                    const Padding(
                      padding: EdgeInsets.only(left: 35.0, bottom: 8),
                      child: const Text(
                        "Country*",
                        style: const TextStyle(
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
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: const BorderRadius.all(Radius.circular(10))),
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
                          value: agent.country,
                          onChanged: (value) {
                            agent.country = value;
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
                    const SizedBox(height: 8),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: NeumorphicButton(
                          padding: EdgeInsets.zero,
                          child: Container(
                            color: const Color(0xff294A91),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
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
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              EasyLoading.show(status: "Updating");
                              ProfileBloc.setAgentProfile(agent)
                                  .then((value) async {
                                await FirebaseAuth.instance.currentUser
                                    .updateProfile(displayName: agent.name);
                                EasyLoading.dismiss();
                                EasyLoading.showSuccess("Updated Successfully");
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
                              shadowLightColor: Colors.white.withOpacity(0.6),
                              // color: Color(0xff294A91),
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(30))),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
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
