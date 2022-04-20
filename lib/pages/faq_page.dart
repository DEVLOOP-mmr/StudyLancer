import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import '../variables.dart';

class FaqPage extends StatelessWidget {
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
          title: Text(
            'FAQ',
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
                      <h2 dir="ltr"><span>Did you know that Australia is the world&rsquo;s third most popular study abroad destination?</span></h2>
<p dir="ltr"><span>Australia has traditionally been the&nbsp;</span><a href="https://www.hotcoursesabroad.com/india/find-your-course/how-to-choose-the-right-study-abroad-destinations/australia-most-sought-destination/"><span>safe choice</span></a><span>&nbsp;for Indian students who fail to make it to the USA and the UK. Despite the rise of Singapore and Malaysia as popular study abroad&nbsp;</span></p>
<p dir="ltr"><span>Destinations, Australia continues to welcome a sizeable number of Indian students to its universities every year.</span></p>
<p dir="ltr"><span>This article examines some of the most common queries that Indian students have when they plan to study in Australia.</span></p>
<h2 dir="ltr"><span>Why Study in Australia?</span></h2>
<ul>
<li dir="ltr">
<p dir="ltr"><span>A wide variety of choices available with universities spread across the country from Perth to Sydney and Melbourne to Tasmania</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>&lsquo;The Group of Eight&rsquo; is a network of eight leading Australian universities, which set the benchmark in academic excellence</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Globally recognized degrees</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Five out of the world&rsquo;s top 30 student cities are in Australia</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Australian universities have produced over 15 Nobel laureates</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>The Australian government spends over \$200,000,000 on scholarships for international students every year</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Strong community of Indian migrants in cities like&nbsp;</span><a href="https://www.hotcoursesabroad.com/india/find-your-course/how-to-choose-the-right-study-abroad-destinations/melbourne-the-cultural-capital-of-the-world/"><span>Melbourne</span></a><span>&nbsp;and Sydney</span></p>
</li>
<li dir="ltr">
<p dir="ltr"><span>Explore the natural wonders of Australia during vacations</span></p>
</li>
</ul>
<h2 dir="ltr"><span>Which are the top-ranked universities in Australia?</span></h2>
<p dir="ltr"><span>There is stiff competition among the top-ranked universities in Australia and every year we observe one university overtaking the other. As per the latest QS World University Rankings, the top five Australian universities are -&nbsp;</span><a href="https://www.hotcoursesabroad.com/india/australia/school-college-university/monash-university/72222/international.html"><span>Monash University</span></a><span>, Australian National University, University of New South Wales, University of Queensland and University of Sydney.</span></p>
<h2 dir="ltr"><span>What are the course options available for Indian students?</span></h2>
<p dir="ltr"><span>Indian students can choose from a wide variety of course options ranging from vocational TAFE courses, English language courses, Foundation programmes for University studies, undergraduate and postgraduate degrees and Ph.D. programmes.</span></p>
<h2 dir="ltr"><span>How do I apply to study in Australia?</span></h2>
<p dir="ltr"><span>All leading universities offer a simple online application process. Once your application is approved and you pay the fees and receive a letter of confirmation, you can use it to secure a student visa from the Australian embassy.</span></p>
<h2 dir="ltr"><span>Do I need to meet any admission requirements?</span></h2>
<p dir="ltr"><span>Yes, applicants need to meet the entry requirements specified by their respective university. These requirements vary, based on the programme selected. Undergraduate programmes usually require applicants to have a minimum IELTS score of 6.0. Postgraduate programmes usually require applicants to have an&nbsp;</span><a href="https://www.hotcoursesabroad.com/india/test-preparation/how-to-prepare-for-ielts-exam/"><span>IELTS</span></a><span>&nbsp;score ranging from 6.5 to 7.0. Those aspiring to study a postgraduate degree should have a good academic score in a relevant undergraduate programme. Some universities require applicants to MBA programmes to have at least two years of work experience.</span></p>
<h2 dir="ltr"><span>How much does it cost to study a full-time degree in Australia?</span></h2>
<p dir="ltr"><span>The cost of completing a degree varies on the university and course selected. An undergraduate degree could cost anywhere from \$15,000 to \$33,000; courses in medicine and veterinary science will cost more. Postgraduate programmes could cost anywhere from \$20,000 to \$37,000. &nbsp;Students are advised to earmark at least \$20,000 every year for food and living costs.</span></p>
<h2 dir="ltr"><span>Am I eligible for scholarships?</span></h2>
<p dir="ltr"><span>A number of scholarships are on offer from the Australian government, the Commonwealth and the British Council. Universities offer a number of academic scholarships to international students with a greater focus on postgraduate programmes.</span></p>
<p dir="ltr"><span>&nbsp;</span></p>
<h2 dir="ltr"><span>Can I work part-time when I am studying?</span></h2>
<p dir="ltr"><span>Yes, you can work part-time when you are studying. You can work up to 20 hours a week when studying and full-time during vacations. A number of part-time jobs are available in super-markets, restaurants and shopping malls. Students can also check for internships within their respective university itself.</span></p>
<h2 dir="ltr"><span>What are my chances of finding a job in Australia once I graduate?</span></h2>
<p dir="ltr"><span>Australia offers a bright future for those who excel academically and have the patience, perseverance and ambition to succeed. An extension on the student visa can be obtained to search for a relevant job once you graduate. Opportunities abound in the medical profession, civil and construction engineering and the tourism and hospitality industries.</span></p>
<p dir="ltr"><span>&nbsp;</span></p>
<h2 dir="ltr"><span>What are the accommodation options available</span><span>?</span></h2>
<p dir="ltr"><span>Most universities offer on-campus accommodation facilities for students. International students are assured of accommodation if they apply on time. The prices vary from institution to institution and students are advised to ensure that they have a safe place to stay before they fly out to Australia. Homestay options are quite popular and most leading cities offer this facility with families renting out a room in their house to international students. The rent usually also includes food that is served by the host-family. The students get to experience Australian life and become an integral part of the host family&rsquo;s life.</span></p>
<p dir="ltr"><span>&nbsp;</span></p>
<p dir="ltr"><span>Be it enjoying the Boxing Day Test at the Melbourne Cricket Ground or watching the T:20 Big Bash or enjoying lawn tennis greats battle it out at the Australian Open; students are spoilt for choice at the sporting action on offer. From the Australian Grand Prix to Rugby tournaments and football action, there is always some sporting event or the other happening. Travel enthusiasts can have a gala time in Australia making the coast to coast trip covering the rich and diverse heritage of the country and exploring some of the most ecologically vibrant parts of the world. These include the Great Barrier Reef, the Australian outback, Ayers Rock - the monolith that seems to change colours and the wonderful beaches that dot the long coastline.</span></p>
<p dir="ltr">&nbsp;</p>
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
