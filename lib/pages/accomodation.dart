import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import '../variables.dart';

class Accommodation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Scaffold(
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
          //elevation: 0,
          title: Text(
            'Accommodation',
            style: TextStyle(
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: <Color>[Color(0xffFF8B86), Color(0xffAE78BE)],
                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                //color: Colors.blue[900],
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                fontFamily: 'Roboto',
                fontSize: 20),
          ),
        ),
        body: SafeArea(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Html(
                      data: """
                    <p dir="ltr"><span>Who we are</span></p>
<p dir="ltr"><span>We, Study Lancer are the&nbsp;</span><span>No.1 overseas education consultant</span><span>&nbsp;in the industry today and help students, every step of the way, in achieving their dream international degree.</span></p>
<p dir="ltr"><span>Through our wide range of </span><span>free support services</span><span>, we guide students to their dream study destination- by helping them find the courses, colleges and universities that meet their expectations and needs-on a global level...</span></p>
<p dir="ltr"><span>Our mission:</span><span>&nbsp;To provide students with best study abroad plans &amp; services.</span></p>
<p dir="ltr"><span>We are a valued brand by universities across the globe and have enjoyed a very strong presence in the education industry for nearly 7 years and this gives us the edge. Our database is rich and updated and over 1 million students rely on it to learn about universities and courses all the way across the globe and make life changing study-decisions. Students can choose from half a million course listings based out of 3 countries.</span></p>
<p dir="ltr"><span>Study Lancer is managed by industry experts - an establishment that comprises associates and employees in India, Australia, the United States and Canada, who have a key aim of helping people explore various education opportunities across the world.</span></p>
<p dir="ltr"><span>With one of the largest global databases [over 500,000 courses and 5000 institutions across 48 countries] and unique websites and application of Study Lancer &ndash; coupled with great experience in student engagement. Our expansion is set to achieve new goals in international education and deliver upbeat services at every step of the study abroad journey, from enquiries to applications to enrolments.</span></p>
""",
                      style: {'Html': Style(color: Colors.white)},
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
