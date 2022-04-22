import 'dart:io';

import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/bloc/profile_bloc.dart';
import 'package:elite_counsel/pages/document_page/student/student_document_page.dart';
import 'package:elite_counsel/pages/profile_page/student/date_selector.dart';

import 'package:elite_counsel/variables.dart';
import 'package:elite_counsel/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({Key key}) : super(key: key);

  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

//end

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // BlocProvider.of<HomeBloc>(context, listen: false).getStudentHome();
    });
  }

  void _showImagePicker() async {
    final student =
        (BlocProvider.of<HomeBloc>(context).state as StudentHomeState).student;
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
          student.photo = uri;
        });
        ProfileBloc.updateStudentProfile(student);
        await FirebaseAuth.instance.currentUser
            .updateProfile(photoURL: student.photo);
      } on FirebaseException catch (e) {
        print(e);
      }
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state.loadState == LoadState.loading) {
        return Container(
          color: Variables.backgroundColor,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      if (state is InitialHomeState) {
        return Container(
          color: Variables.backgroundColor,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      var student = (state as StudentHomeState).student;

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
                              image: NetworkImage(student.photo ??
                                  "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg"),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xff131618),
                                offset: Offset(-6, -5),
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
                            decoration: const BoxDecoration(
                              gradient: Variables.buttonGradient,
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
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
                            return const StudentDocumentPage();
                          }));
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
                    const Padding(
                      padding: EdgeInsets.only(left: 35.0, bottom: 8),
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
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          initialValue: student.name,
                          onChanged: (value) {
                            student.name = value;
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
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          initialValue: student.email,
                          onChanged: (value) {
                            student.email = value;
                          },
                          validator: (value) {
                            String p =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                            RegExp regExp = RegExp(p);
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
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          initialValue: student.phone,
                          onChanged: (value) {
                            student.phone = value;
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
                    const Padding(
                      padding: EdgeInsets.only(left: 35.0, bottom: 8),
                      child: Text(
                        "Date Of Birth",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            fontSize: 12),
                      ),
                    ),
                    const DateSelector(),
                    const Padding(
                      padding: EdgeInsets.only(left: 35.0, bottom: 8),
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
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
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
                          value: student.maritalStatus,
                          onChanged: (value) {
                            student.maritalStatus = value;
                          },
                          style: const TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Roboto',
                              fontSize: 12),
                          dropdownColor: Colors.black,
                          items: [
                            "Married",
                            "Unmarried",
                          ]
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
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          initialValue: student.city,
                          onChanged: (value) {
                            student.city = value;
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
                          value: student.country,
                          onChanged: (value) {
                            student.country = value;
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
                      padding: EdgeInsets.only(left: 35.0, bottom: 8),
                      child: Text(
                        "About",
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
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          initialValue: student.bio,
                          onChanged: (value) {
                            student.bio = value;
                          },
                          validator: (value) {
                            if (value == "") {
                              return null;
                            }
                            return null;
                          },
                          maxLines: 5,
                          autocorrect: false,
                          style: const TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Roboto',
                              fontSize: 12),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'write something about yourself',
                            hintStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w400),
                          ),
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
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              EasyLoading.show(status: "Updating");
                              ProfileBloc.updateStudentProfile(student)
                                  .then((value) async {
                                EasyLoading.dismiss();
                                EasyLoading.showSuccess("Updated Successfully");
                              });
                            } else {
                              EasyLoading.showError("Enter valid details");
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
