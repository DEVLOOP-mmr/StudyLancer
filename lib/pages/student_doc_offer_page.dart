import 'package:dio/dio.dart';
import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/pages/offer_page.dart';
import 'package:elite_counsel/variables.dart';
import 'package:elite_counsel/widgets/inner_shadow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ionicons/ionicons.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class StudentDocOfferPage extends StatefulWidget {
  final Student student;
  const StudentDocOfferPage({Key key, @required this.student})
      : super(key: key);

  @override
  _StudentDocOfferPageState createState() => _StudentDocOfferPageState();
}

class _StudentDocOfferPageState extends State<StudentDocOfferPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Variables.backgroundColor,
      appBar: AppBar(
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
        title: Text(
          "Documents",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 23, color: Colors.white),
        ),
        centerTitle: false,
        backgroundColor: Variables.backgroundColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: Colors.white),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: (widget.student.otherDoc ?? []).length,
                itemBuilder: (context, index) {
                  Document doc = widget.student.otherDoc[index];
                  if (doc.link == null) {
                    return Container();
                  }
                  String icon = "assets/docicon.png";
                  if (doc.type == "pdf") {
                    icon = "assets/pdficon.png";
                  } else if (doc.type == "jpg" ||
                      doc.type == "png" ||
                      doc.type == "gif" ||
                      doc.type == "jpeg") {
                    icon = "assets/imageicon.png";
                  }
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: InnerShadow(
                      blur: 20,
                      offset: const Offset(5, 5),
                      color: Colors.black.withOpacity(0.38),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Variables.backgroundColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          onTap: () async {
                            if (await Permission.storage.request().isGranted) {
                              String filePath = '';
                              var dir =
                                  await getApplicationDocumentsDirectory();
                              print(doc.link);
                              try {
                                filePath =
                                    dir.path + "/" + doc.name + "." + doc.type;
                                EasyLoading.show(status: "Downloading..");
                                await Dio().download(doc.link, filePath);
                                EasyLoading.dismiss();
                                OpenFile.open(filePath);
                              } catch (ex) {
                                filePath = 'Can not fetch url';
                              }
                            } else {
                              EasyLoading.showError(
                                  "Please allow storage permissions");
                            }
                          },
                          contentPadding: EdgeInsets.all(15),
                          leading: Image.asset(icon),
                          trailing: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Color(0x3fC1C1C1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: Icon(
                              Ionicons.cloud_download_outline,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            doc.name,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.4))
                ],
                color: Variables.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Want to provide best options acc. to documents.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Variables.accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SafeArea(
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
                            "Provide Option ->",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return OfferPage(student: widget.student);
                      }));
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
