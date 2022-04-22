import 'package:elite_counsel/pages/home_page/agent/agent_home_app_bar.dart';
import 'package:elite_counsel/pages/home_page/agent/student_list_view/student_tabbed_list.dart';
import 'package:elite_counsel/variables.dart';
import 'package:elite_counsel/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class AgentHomePage extends StatefulWidget {
  const AgentHomePage({Key key}) : super(key: key);

  @override
  AgentHomePageState createState() => AgentHomePageState();
}

class Country {
  final String image;
  final String name;

  Country(this.image, this.name);
}

class AgentHomePageState extends State<AgentHomePage>
    with TickerProviderStateMixin {
   final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  List<Country> data = [
    Country("assets/images/taj.png", "India"),
    Country("assets/images/pakistan.png", "Pakistan"),
    Country("assets/images/nepal.png", "Nepal"),
    Country("assets/images/bangladesh.png", "Bangladesh"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Variables.backgroundColor,
      endDrawer: MyDrawer(),
      appBar:  PreferredSize(
        child: AgentHomeAppBar(scaffoldKey: scaffoldKey,),
        preferredSize: Size.fromHeight(70),
      ),
      body: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Neumorphic(
          style: NeumorphicStyle(
            color: Variables.backgroundColor,
            shadowLightColor: Colors.white.withOpacity(0.3),
            lightSource: LightSource.topLeft.copyWith(dx: -2, dy: -2),
            depth: -1,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 15,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              // setState(() {
                              //   country = data[index].name;
                              // });
                              /// TODO:
                            },
                            child: AspectRatio(
                                aspectRatio: 1 / 2,
                                child: Image.asset(
                                  data[index].image,
                                  fit: BoxFit.contain,
                                )));
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => const StudentTabbedList()));
                        },
                        child: AspectRatio(
                          aspectRatio: 324 / 177,
                          child: Image.asset(
                            "assets/images/seeall.png",
                            fit: BoxFit.contain,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
