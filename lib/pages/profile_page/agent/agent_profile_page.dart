import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/bloc/profile_bloc.dart';
import 'package:elite_counsel/pages/profile_page/agent/agent_profile_header.dart';
import 'package:elite_counsel/variables.dart';
import 'package:elite_counsel/widgets/drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class AgentProfilePage extends StatefulWidget {
  const AgentProfilePage({Key key}) : super(key: key);

  @override
  State<AgentProfilePage> createState() => _AgentProfilePageState();
}

class _AgentProfilePageState extends State<AgentProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey;
  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state.loadState == LoadState.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is InitialHomeState) {
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
              image: AssetImage(
                "assets/background.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AgentProfileHeader(),
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
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
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
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          initialValue: agent.licenseNo,
                          onChanged: (value) {
                            agent.licenseNo = value;
                          },
                          validator: (value) {
                            if ((value ?? "").isEmpty) {
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
                          initialValue: agent.email,
                          onChanged: (value) {
                            agent.email = value;
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
                          items: ["Unmarried", "Married", "Divorced"]
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
                              ProfileBloc.setAgentProfile(agent)
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
