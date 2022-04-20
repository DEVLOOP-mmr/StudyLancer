import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/pages/student_doc_offer_page.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class StudentDetailPage extends StatefulWidget {
  final Student student;
  const StudentDetailPage({Key key, this.student}) : super(key: key);

  @override
  _StudentDetailPageState createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  PaletteGenerator paletteGenerator;

  @override
  void initState() {
    super.initState();
    PaletteGenerator.fromImageProvider(
      NetworkImage(widget.student.photo ??
          "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg"),
      maximumColorCount: 20,
    ).then((value) {
      setState(() {
        paletteGenerator = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return paletteGenerator == null
        ? Container()
        : Scaffold(
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
            body: Stack(
              children: [
                FractionallySizedBox(
                  heightFactor: 0.7,
                  child: Container(
                    decoration: BoxDecoration(
                      color: paletteGenerator.dominantColor.color,
                      // borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(widget.student.photo ??
                            "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(colors: [
                      Colors.transparent,
                      paletteGenerator.dominantColor.color.withOpacity(0.05),
                      paletteGenerator.dominantColor.color,
                      paletteGenerator.dominantColor.color,
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 32.0, bottom: 46.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.student.name.trim() ?? "",
                                style: TextStyle(
                                  fontSize: 35,
                                  color: paletteGenerator
                                      .dominantColor.titleTextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.pin_drop_outlined,
                                    color: paletteGenerator
                                        .dominantColor.titleTextColor,
                                    size: 14,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    (widget.student.city ?? "") +
                                        ", " +
                                        (widget.student.country ?? ""),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: paletteGenerator
                                          .dominantColor.titleTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if (widget.student.marksheet != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 32.0),
                              child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      widget.student.marksheet.length * 2,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              widget.student.marksheet.length,
                                          childAspectRatio: 2),
                                  itemBuilder: (context, index) {
                                    var markData = widget.student.marksheet.keys
                                        .toList(growable: true);
                                    for (var element
                                        in widget.student.marksheet.values) {
                                      markData.add(element.toString());
                                    }
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: paletteGenerator
                                                .dominantColor.titleTextColor),
                                      ),
                                      child: Center(
                                        child: Text(
                                          markData[index],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: paletteGenerator
                                                  .dominantColor
                                                  .titleTextColor),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          const SizedBox(
                            height: 30,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return StudentDocOfferPage(
                                    student: widget.student);
                              }));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 32.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: paletteGenerator
                                        .dominantColor.titleTextColor,
                                    borderRadius: BorderRadius.circular(40)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Text(
                                      "View Document",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: paletteGenerator
                                            .dominantColor.color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
