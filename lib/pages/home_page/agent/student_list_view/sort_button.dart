import 'package:elite_counsel/variables.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:accordion/accordion.dart';

class SortButton extends StatelessWidget {
  const SortButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var result = await showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => const SortDialog());
        if (result != null) {
          if (result == "asc") {
            // setState(() {
            //   selfData.applications.sort((a, b) =>
            //       (int.parse(a.courseFees))
            //           .compareTo((int.parse(b.courseFees))));
            // });
            /// TODO: sort and filter studentdata for agenthome
          } else if (result == "desc") {
            // setState(() {
            //   selfData.applications.sort((b, a) =>
            //       (int.parse(a.courseFees))
            //           .compareTo((int.parse(b.courseFees))));
            // });
          }
        }
      },
      child: Row(
        children: [
          InkWell(
            child: Image.asset(
              "assets/images/Sort.png",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 25,
              left: 08,
            ),
            child: InkWell(
              child: Container(
                child: const Text(
                  "Sort",
                  style: TextStyle(
                      color: Color(0xffFFAC97),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SortDialog extends StatelessWidget {
  const SortDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Variables.backgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Accordion(
              maxOpenSections: 1,
              headerBackgroundColor: Variables.backgroundColor,
              contentBackgroundColor: Variables.backgroundColor,
              children: [
                AccordionSection(
                    header: const Text(
                      "Sort by Courses Fees",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontStyle: FontStyle.normal,
                          fontFamily: "roboto"),
                    ),
                    content: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop("asc");
                          },
                          child: const Text(
                            "Ascending",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop("desc");
                          },
                          child: const Text(
                            "Descending",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    )),
                AccordionSection(
                    header: const Text(
                      "Sort by Tuition Fees",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontStyle: FontStyle.normal,
                          fontFamily: "roboto"),
                    ),
                    content: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop("asc");
                          },
                          child: const Text(
                            "Ascending",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop("desc");
                          },
                          child: const Text(
                            "Descending",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    )),
                AccordionSection(
                    header: const Text(
                      "Sort by Application Fees",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontStyle: FontStyle.normal,
                          fontFamily: "roboto"),
                    ),
                    content: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop("asc");
                          },
                          child: const Text(
                            "Ascending",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop("desc");
                          },
                          child: const Text(
                            "Descending",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
