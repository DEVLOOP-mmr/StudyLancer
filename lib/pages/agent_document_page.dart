import 'dart:io';
import 'package:dio/dio.dart';
import 'package:elite_counsel/bloc/document_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/models/document.dart';
import 'package:elite_counsel/widgets/drawer.dart';
import 'package:elite_counsel/widgets/inner_shadow.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ionicons/ionicons.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../variables.dart';

/// TODO: inject HomeBloc

class AgentDocumentPage extends StatefulWidget {
  @override
  _AgentDocumentPageState createState() => _AgentDocumentPageState();
}

class _AgentDocumentPageState extends State<AgentDocumentPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final reqDocNames = ['license', 'registrationCertificate', 'personalID'];
  List<Document> requiredDocs = [];
  Agent selfData = Agent();
  @override
  void initState() {
    super.initState();
  }

  void getAgentData() {
    BlocProvider.of<HomeBloc>(context, listen: false)
        .getAgentHome()
        .then((value) {
      setState(() {
        selfData = value.agent;

        selfData.otherDoc.forEach((element) {
          if (reqDocNames.contains(element.name)) {
            requiredDocs.add(element);
          }
        });

        selfData.otherDoc
            .removeWhere((element) => reqDocNames.contains(element.name));
      });
    });
  }

  Widget requiredDocumentsList() {
    return Container(
      padding: EdgeInsets.only(left: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: reqDocNames
            .map((e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      requiredDocs.any((element) => element.name == e)
                          ? DismissibleDocument(
                              0,
                              context,
                              requiredDocs
                                  .firstWhere((element) => element.name == e),
                              "assets/imageicon.png",
                              requiredDoc: e,
                            )
                          : UploadButton(e)
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  void _showFilePicker([String requiredDocType]) async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.any, allowMultiple: true);

    if (result != null) {
      EasyLoading.show(status: "Uploading");
      await DocumentBloc.parseAndUploadFilePickerResult(
        result,
        requiredDocType: requiredDocType,
      );
      getAgentData();
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Variables.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Documents",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 23, color: Colors.white),
        ),
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        actions: [
          Builder(builder: (context) {
            return GestureDetector(
              child: Image.asset("assets/images/menu.png"),
              onTap: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          })
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(color: Colors.white),
                  SizedBox(
                    height: 8,
                  ),
                  Image.asset("assets/images/agent_docs_required.png"),
                  SizedBox(
                    height: 16,
                  ),
                  selfData.id == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : requiredDocumentsList(),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      color: Color(0xffFF8B86),
                    ),
                  ),
                  selfData.id == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: (selfData.otherDoc ?? []).length,
                            itemBuilder: (context, index) {
                              Document doc = selfData.otherDoc[index];
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

                              return Center(
                                child: DismissibleDocument(
                                    index, context, doc, icon),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          ),
          Align(alignment: Alignment.bottomRight, child: UploadButton())
        ],
      ),
      endDrawer: MyDrawer(),
    );
  }

  void documentOnDismiss(int index, BuildContext context) {}

  Widget DismissibleDocument(
    int index,
    BuildContext context,
    Document doc,
    String icon, {
    String requiredDoc,
  }) {
    return Dismissible(
      key: ObjectKey(doc ?? selfData.otherDoc[index]),
      onDismissed: (direction) {
        if (index != null) {
          setState(() {
            selfData.otherDoc.removeAt(index);
          });
        } else if (requiredDoc != null) {
          setState(() {
            requiredDocs.removeWhere((element) => element.name == requiredDoc);
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("document remove"),
        ));
      },
      child: Padding(
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
                  var dir = await getApplicationDocumentsDirectory();
                  print(doc.link);
                  try {
                    filePath = dir.path + "/" + doc.name + "." + doc.type;
                    EasyLoading.show(status: "Downloading..");
                    await Dio().download(doc.link, filePath);
                    EasyLoading.dismiss();
                    OpenFile.open(filePath);
                  } catch (ex) {
                    filePath = 'Can not fetch url';
                  }
                } else {
                  EasyLoading.showError("Please allow storage permissions");
                }
              },
              contentPadding: EdgeInsets.all(15),
              leading: Image.asset(icon),
              trailing: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Color(0x3fC1C1C1),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
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
      ),
    );
  }

  Widget UploadButton([String requiredDocType]) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {
          _showFilePicker(requiredDocType);
        },
        child: Wrap(
          children: [
            Wrap(
              direction: Axis.vertical,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xff294A91),
                      borderRadius: BorderRadius.circular(8)),
                  clipBehavior: Clip.hardEdge,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: Variables.buttonGradient,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.upload_sharp,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Upload ${requiredDocType ?? ''}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
