import 'package:elite_counsel/pages/phone_login.dart';
import 'package:elite_counsel/variables.dart';
import 'package:flutter/material.dart';

class StudentSelectButton extends StatelessWidget {
  const StudentSelectButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Variables.sharedPreferences
            .put(Variables.userType, Variables.userTypeStudent);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const PhonePage();
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
          const Padding(
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
    );
  }
}
