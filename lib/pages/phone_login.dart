import 'package:elite_counsel/pages/home_page/home_page.dart';
import 'package:elite_counsel/pages/otp_page.dart';
import 'package:elite_counsel/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({Key key}) : super(key: key);

  @override
  _PhonePageState createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  String phoneNumber;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Color(0xff1E2224),
            image: DecorationImage(
                image: AssetImage(
                  "assets/background.png",
                ),
                fit: BoxFit.fill)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, right: 150.0),
                child: Text(
                  "Let’s get started",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50)),
                child: IntlPhoneField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.only(bottom: 8),
                    disabledBorder: InputBorder.none,
                    alignLabelWithHint: true,
                    counter: Container(),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Enter your number',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                  ),
                  initialCountryCode: 'IN',
                  countryCodeTextColor: Colors.white,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (phone) {
                    if (mounted) {
                      setState(() {
                        phoneNumber = phone.completeNumber;
                      });
                    }
                  },
                ),
              ),
            ),
            const Spacer(),
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
                          "Get OTP",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  onPressed: phoneNumber == null
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Enter Phone Number")));
                        }
                      : () {
                          EasyLoading.show(
                              status: 'loading...',
                              maskType: EasyLoadingMaskType.clear,
                              dismissOnTap: false);
                          FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: phoneNumber,
                              verificationCompleted: (credential) {
                                EasyLoading.dismiss();
                                Variables.sharedPreferences
                                    .put(Variables.phone, phoneNumber);
                                FirebaseAuth.instance
                                    .signInWithCredential(credential)
                                    .then((result) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const HomePage(),
                                      ),
                                      (_) => false);
                                }).catchError((e) {
                                  print(e);
                                });
                              },
                              verificationFailed: (exception) {
                                EasyLoading.dismiss();

                                EasyLoading.showError(exception.toString());
                              },
                              codeSent: (verificationId, forceResendingToken) {
                                EasyLoading.dismiss();
                                Variables.sharedPreferences
                                    .put(Variables.phone, phoneNumber);
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return OtpPage(
                                    verificationId: verificationId,
                                  );
                                }));
                              },
                              codeAutoRetrievalTimeout: (verificationId) {});
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
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
