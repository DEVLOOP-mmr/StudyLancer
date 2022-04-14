import 'package:dio/dio.dart';
import 'package:elite_counsel/bloc/document_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/models/document.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/widgets/drawer.dart';
import 'package:elite_counsel/widgets/inner_shadow.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ionicons/ionicons.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../variables.dart';


/// TODO: subsections for required documents
class StudentDocumentPage extends StatelessWidget {
  const StudentDocumentPage({Key key}) : super(key: key);

  void _showFilePicker(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );

    if (result != null) {
      //result.file   for (file in result.files)  let say
      EasyLoading.show(status: "Uploading");

      await DocumentBloc.parseAndUploadFilePickerResult(result);
      EasyLoading.dismiss();

      BlocProvider.of<HomeBloc>(context, listen: false)
          .getStudentHome()
          .then((value) {});
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Documents",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is! StudentHomeState) {
            return Container(
              child: CircularProgressIndicator(),
            );
          }
          final student = (state as StudentHomeState).student;
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const Divider(color: Colors.white),
                    const SizedBox(
                      height: 8,
                    ),
                    Image.asset("assets/images/docs_required.png"),
                    const SizedBox(
                      height: 16,
                    ),
                    state.loadState == LoadState.loading
                        ? Container(
                            color: Variables.backgroundColor,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ))
                        : student == null
                            ? Container(
                                color: Variables.backgroundColor,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ))
                            : Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: (student.documents ?? []).length,
                                  itemBuilder: (context, index) {
                                    Document doc = student.documents[index];
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
                                    return Dismissible(
                                      background: Container(
                                        color: Colors.red,
                                      ),
                                      key: ObjectKey(student.documents[index]),
                                      onDismissed: (direction) async {
                                        await deleteDocumentOnDismiss(
                                            index, context);
                                        // showCupertinoModalPopup(
                                        //   context: context,
                                        //   builder: (_) {
                                        //     return Container(
                                        //       child: Column(
                                        //         children: [],
                                        //       ),
                                        //     );
                                        //   },
                                        // );
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: InnerShadow(
                                          blur: 20,
                                          offset: const Offset(5, 5),
                                          color: Colors.black.withOpacity(0.38),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Variables.backgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: ListTile(
                                              onTap: () async {
                                                if (await Permission.storage
                                                    .request()
                                                    .isGranted) {
                                                  String filePath = '';
                                                  var dir =
                                                      await getApplicationDocumentsDirectory();

                                                  try {
                                                    filePath = dir.path +
                                                        "/" +
                                                        doc.name +
                                                        "." +
                                                        doc.type;
                                                    EasyLoading.show(
                                                        status:
                                                            "Downloading..");
                                                    await Dio().download(
                                                        doc.link, filePath);
                                                    EasyLoading.dismiss();
                                                    OpenFile.open(filePath);
                                                  } catch (ex) {
                                                    filePath =
                                                        'Can not fetch url';
                                                  }
                                                } else {
                                                  EasyLoading.showError(
                                                      "Please allow storage permissions");
                                                }
                                              },
                                              contentPadding:
                                                  const EdgeInsets.all(15),
                                              leading: Image.asset(icon),
                                              trailing: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: const BoxDecoration(
                                                    color: Color(0x3fC1C1C1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                                child: const Icon(
                                                  Ionicons
                                                      .cloud_download_outline,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              title: Text(
                                                doc.name,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {
                      _showFilePicker(context);
                    },
                    child: Wrap(
                      children: [
                        Wrap(
                          direction: Axis.vertical,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xff294A91),
                                  borderRadius: BorderRadius.circular(8)),
                              clipBehavior: Clip.hardEdge,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: Variables.buttonGradient,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.upload_sharp,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "Upload",
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
                ),
              )
            ],
          );
        },
      ),
      endDrawer: MyDrawer(),
    );
  }

  Future<void> deleteDocumentOnDismiss(int index, BuildContext context) async {
    var bloc = BlocProvider.of<HomeBloc>(context, listen: false);
    final student = (bloc.state as StudentHomeState).student;
    final document = student.documents[index];

    student.documents.removeAt(index);

    bloc.emitNewStudent(student);
    var response = await DocumentBloc.deleteDocument(document.id, student.id);
    if (response.statusCode != 200) {
      student.documents.insert(index, document);

      bloc.emitNewStudent(student);
    } else if (response.statusCode != 500) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Document removed"),
      ));
    }
    BlocProvider.of<HomeBloc>(context, listen: false)
        .getStudentHome()
        .then((value) {});
  }
}
