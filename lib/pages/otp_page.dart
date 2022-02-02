import 'package:elite_counsel/pages/country_select_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../variables.dart';

class OtpPage extends StatefulWidget {
  final String verificationId;

  const OtpPage({Key key, @required this.verificationId}) : super(key: key);
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  //final _formKey = GlobalKey<FormState>();
  var controller = TextEditingController();

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SmsAutoFill().listenForCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 40.0),
                child: Text(
                  "Enter OTP",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, top: 15.0, right: 16.0, bottom: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: PinFieldAutoFill(
                    decoration: UnderlineDecoration(
                      textStyle: TextStyle(fontSize: 20, color: Colors.white),
                      colorBuilder:
                          FixedColorBuilder(Colors.black.withOpacity(0.3)),
                    ),
                    currentCode: controller.text,
                    onCodeSubmitted: (code) {},
                    onCodeChanged: (code) {
                      controller.text = code;
                      if (code.length == 6) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        checkCode(code);
                      }
                    },
                  ),
                ),
              ),
              Spacer(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
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
                            "Verify",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    onPressed: controller.text.length != 6
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Enter OTP")));
                          }
                        : () {
                            EasyLoading.show(
                                status: 'loading...',
                                maskType: EasyLoadingMaskType.clear,
                                dismissOnTap: false);
                            checkCode(controller.text);
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
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void checkCode(String code) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: code ?? "",
      );
      final user = await FirebaseAuth.instance.signInWithCredential(credential);
      Future.delayed(Duration.zero, () async {
        await EasyLoading.dismiss();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return CountrySelectPage();
        }), (route) => false);
      });
    } catch (e) {
      handleError(e);
    }
  }

  handleError(FirebaseAuthException error) {
    print(error);
    switch (error.code) {
      case 'invalid-verification-code':
        EasyLoading.dismiss();
        EasyLoading.showError("Invalid OTP");
        break;
      default:
        EasyLoading.dismiss();
        EasyLoading.showError(error.message.toString());

        break;
    }
  }
}
