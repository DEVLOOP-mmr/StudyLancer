import 'dart:math';

import 'package:elite_counsel/variables.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class ItemData {
  final String image;

  ItemData(this.image);
}

/// Example of LiquidSwipe with itemBuilder
class TutorialPage extends StatefulWidget {
  @override
  _TutorialPageBuilder createState() => _TutorialPageBuilder();
}

class _TutorialPageBuilder extends State<TutorialPage> {
  int page = 0;
  LiquidController liquidController;
  UpdateType updateType;

  List<ItemData> data = [
    // ItemData("assets/tut1.jpg"),
    ItemData("assets/tut2.jpg"),
    ItemData("assets/tut3.jpg"),
    ItemData("assets/tut4.jpg"),
    ItemData("assets/tut5.jpg"),
  ];
  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page ?? 0) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectedness;
    return SizedBox(
      width: 25.0,
      child: Center(
        child: Material(
          color: Colors.white,
          type: MaterialType.circle,
          child: SizedBox(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          LiquidSwipe.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Variables.backgroundColor,
                  image: DecorationImage(
                      image: AssetImage(data[index].image),
                      fit: BoxFit.contain),
                ),
              );
            },
            positionSlideIcon: 0.8,
            // slideIconWidget: Icon(Icons.arrow_back_ios),
            onPageChangeCallback: pageChangeCallback,
            waveType: WaveType.liquidReveal,
            liquidController: liquidController,
            ignoreUserGestureWhileAnimating: true,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                const Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(data.length, _buildDot),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: FlatButton(
                onPressed: () {
                  Variables.sharedPreferences.put(Variables.isFirstTime, false);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(color: Variables.accentColor),
                ),
                color: Colors.white.withOpacity(0.01),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: FlatButton(
                onPressed: () {
                  if (liquidController.currentPage + 1 > data.length - 1) {
                    Variables.sharedPreferences
                        .put(Variables.isFirstTime, false);
                    Future.delayed(Duration.zero, () {
                      Navigator.of(context).pop();
                    });
                  } else {
                    liquidController.jumpToPage(
                        page: liquidController.currentPage + 1);
                  }
                },
                child: const Text(
                  "Next",
                  style: TextStyle(color: Variables.accentColor),
                ),
                color: Colors.white.withOpacity(0.01),
              ),
            ),
          )
        ],
      ),
    );
  }

  pageChangeCallback(int lpage) {
    if (page == data.length - 1 && lpage == 0) {
      Variables.sharedPreferences.put(Variables.isFirstTime, false);
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pop();
      });
    }
    setState(() {
      page = lpage;
    });
  }
}
