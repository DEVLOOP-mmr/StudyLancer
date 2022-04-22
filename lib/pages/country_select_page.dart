import 'package:elite_counsel/bloc/country_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/pages/home_page/home_page.dart';
import 'package:elite_counsel/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

class CountrySelectPage extends StatefulWidget {
  const CountrySelectPage({Key key}) : super(key: key);

  @override
  _CountrySelectPageState createState() => _CountrySelectPageState();
}

class _CountrySelectPageState extends State<CountrySelectPage> {
  List<Country> countries = [];
  int selectedIndex = -1;
  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: 'loading...');
    CountryBloc.getCountries().then((value) {
      EasyLoading.dismiss();

      if (mounted) {
        setState(() {
          countries = value;
        });
      }

      if (countries.isEmpty) {
        EasyLoading.dismiss();
        setState(() {
          countries = [
            Country(id: 'CA', countryName: 'Canada'),
            Country(id: 'AU', countryName: 'Australia')
          ];
        });
      }
    });

    if (countries.isEmpty) {
      EasyLoading.dismiss();
      setState(() {
        countries = [
          Country(id: 'CA', countryName: 'Canada'),
          Country(id: 'AU', countryName: 'Australia')
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
            color: Color(0xff1E2224),
            image: DecorationImage(
                image: AssetImage(
                  "assets/background.png",
                ),
                fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  Variables.sharedPreferences.get(Variables.userType) ==
                          Variables.userTypeStudent
                      ? "Where do you want to study ?"
                      : "Country recruiting for?",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: countries.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NeumorphicButton(
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  countries[index].countryName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              if (selectedIndex == index) {
                                selectedIndex = -1;
                              } else {
                                selectedIndex = index;
                              }
                            });
                          },
                          style: NeumorphicStyle(
                              depth: 0,
                              color: selectedIndex == index
                                  ? const Color(0xff294A91)
                                  : Colors.black,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(30))),
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: NeumorphicButton(
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Not Sure ?",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (selectedIndex == countries.length) {
                            selectedIndex = -1;
                          } else {
                            selectedIndex = countries.length;
                          }
                        });
                      },
                      style: NeumorphicStyle(
                          depth: 0,
                          color: selectedIndex == countries.length
                              ? const Color(0xff294A91)
                              : Colors.black,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(30))),
                    ),
                  ),
                ),
                const Spacer(),
                SafeArea(
                  child: Column(
                    children: [
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: NeumorphicButton(
                            padding: EdgeInsets.zero,
                            child: Container(
                              color: selectedIndex < countries.length &&
                                      selectedIndex > -1
                                  ? const Color(0xff294A91)
                                  : Variables.backgroundColor,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: selectedIndex < countries.length &&
                                          selectedIndex > -1
                                      ? Variables.buttonGradient
                                      : null,
                                ),
                                child: const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Next",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (selectedIndex == -1 ||
                                  selectedIndex == countries.length) {
                                EasyLoading.showError(
                                  'Error! Please select a country or request callback',
                                );

                                return;
                              }
                              String countryCode;
                              countryCode = selectedIndex == countries.length
                                  ? "notSure"
                                  : countries[selectedIndex].id;
                              await Variables.sharedPreferences
                                  .put(Variables.countryCode, countryCode);
                              BlocProvider.of<HomeBloc>(context, listen: false)
                                  .setCountry(
                                countryCode,
                                Variables.sharedPreferences
                                    .get(Variables.userType),
                              );
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                                (route) => false,
                              );
                            },
                            style: NeumorphicStyle(
                              border: const NeumorphicBorder(
                                isEnabled: true,
                                color: Variables.backgroundColor,
                                width: 2,
                              ),
                              shadowLightColor: Colors.white.withOpacity(0.6),
                              // color: Color(0xff294A91),
                              boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Divider(
                        color: Colors.white.withOpacity(0.4),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 16),
                        child: Row(
                          children: [
                            Flexible(
                              child: Align(
                                alignment: Alignment.center,
                                child: NeumorphicButton(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.phone_outlined,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "Request Callback",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onPressed: selectedIndex == countries.length
                                      ? () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                String phone, message;
                                                var formKey =
                                                    GlobalKey<FormState>();
                                                return AlertDialog(
                                                  backgroundColor:
                                                      Variables.backgroundColor,
                                                  content: Form(
                                                    key: formKey,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 20),
                                                          child: Center(
                                                            child: Text(
                                                              "Request a callback",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 20),
                                                            ),
                                                          ),
                                                        ),
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 8),
                                                          child: Text(
                                                            "Phone Number",
                                                            style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 8),
                                                          decoration: const BoxDecoration(
                                                              color:
                                                                  Colors.black,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10))),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child:
                                                                TextFormField(
                                                              onChanged:
                                                                  (value) {
                                                                phone = value;
                                                              },
                                                              validator:
                                                                  (value) {
                                                                if ((value ??
                                                                        "") ==
                                                                    "") {
                                                                  return "Entry phone number";
                                                                }
                                                                return null;
                                                              },
                                                              autocorrect: true,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 12),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .phone,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                focusedBorder:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    'Phone Number',
                                                                hintStyle: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.7),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 8),
                                                          child: Text(
                                                            "Message",
                                                            style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 8),
                                                          decoration: const BoxDecoration(
                                                              color:
                                                                  Colors.black,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10))),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child:
                                                                TextFormField(
                                                              onChanged:
                                                                  (value) {
                                                                message = value;
                                                              },
                                                              validator:
                                                                  (value) {
                                                                if ((value ??
                                                                        "") ==
                                                                    "") {
                                                                  return "Entry your message";
                                                                }
                                                                return null;
                                                              },
                                                              autocorrect: true,
                                                              minLines: 3,
                                                              maxLines: 4,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 12),
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                focusedBorder:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    'Enter you query',
                                                                hintStyle: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.7),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SafeArea(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        40.0),
                                                            child:
                                                                NeumorphicButton(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              child: Container(
                                                                color: const Color(
                                                                    0xff294A91),
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(12),
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    gradient:
                                                                        Variables
                                                                            .buttonGradient,
                                                                  ),
                                                                  child:
                                                                      const Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                      "Submit",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                if (formKey
                                                                    .currentState
                                                                    .validate()) {
                                                                  EasyLoading.show(
                                                                      status:
                                                                          "Updating");
                                                                  CountryBloc.requestCallback(
                                                                          message,
                                                                          phone)
                                                                      .then(
                                                                          (value) async {
                                                                    EasyLoading
                                                                        .dismiss();
                                                                    EasyLoading
                                                                        .showSuccess(
                                                                            "Requested Successfully");
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  });
                                                                } else {
                                                                  EasyLoading
                                                                      .showError(
                                                                          "Enter valid details");
                                                                }
                                                              },
                                                              style:
                                                                  NeumorphicStyle(
                                                                      border: const NeumorphicBorder(
                                                                          isEnabled:
                                                                              true,
                                                                          color: Variables
                                                                              .backgroundColor,
                                                                          width:
                                                                              2),
                                                                      shadowLightColor: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.6),
                                                                      // color: Color(0xff294A91),
                                                                      boxShape:
                                                                          NeumorphicBoxShape.roundRect(
                                                                              BorderRadius.circular(30))),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        }
                                      : () {},
                                  style: NeumorphicStyle(
                                      shadowLightColor:
                                          Colors.white.withOpacity(0.6),
                                      border: const NeumorphicBorder(
                                          isEnabled: true,
                                          color: Variables.backgroundColor,
                                          width: 2),
                                      color: selectedIndex == countries.length
                                          ? const Color(0xff294A91)
                                          : Variables.backgroundColor,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(30))),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Align(
                              alignment: Alignment.center,
                              child: NeumorphicButton(
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(
                                    Ionicons.logo_whatsapp,
                                    color: Colors.greenAccent,
                                    size: 17,
                                  ),
                                ),
                                onPressed: selectedIndex == countries.length
                                    ? () async {
                                        await canLaunch(
                                                    "https://wa.me/+919493395000") ==
                                                true
                                            ? launch(
                                                "https://wa.me/+919493395000")
                                            : EasyLoading.showError(
                                                "Cannot open Whatsapp.");
                                      }
                                    : () {},
                                style: NeumorphicStyle(
                                  shadowLightColor:
                                      Colors.white.withOpacity(0.6),
                                  border: const NeumorphicBorder(
                                      isEnabled: true,
                                      color: Variables.backgroundColor,
                                      width: 2),
                                  color: selectedIndex == countries.length
                                      ? const Color(0xff294A91)
                                      : Variables.backgroundColor,
                                  boxShape: const NeumorphicBoxShape.circle(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
