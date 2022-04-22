import 'package:elite_counsel/pages/document_page/document_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:elite_counsel/bloc/document_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/models/document.dart';
import 'package:elite_counsel/widgets/drawer.dart';

import '../../../variables.dart';

class StudentDocumentPage extends StatefulWidget {
  const StudentDocumentPage({Key key}) : super(key: key);

  @override
  State<StudentDocumentPage> createState() => _StudentDocumentPageState();
}

class _StudentDocumentPageState extends State<StudentDocumentPage> {
  Map<String, String> requiredDocTitles = {
    'passport': 'Passport',
    'englishProficiencyTest': 'English Proficiency Test',
    'academics': 'Academics'
  };
  @override
  void initState() {
    super.initState();
  }

  void getStudentData(BuildContext context) async {
    await BlocProvider.of<HomeBloc>(context, listen: false).getStudentHome();
    await BlocProvider.of<HomeBloc>(context, listen: false).getStudentHome();
  }

  Widget requiredDocumentsList() {
    return Container(
      padding: const EdgeInsets.only(left: 11),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is! StudentHomeState) {
            return Container(child: const CircularProgressIndicator());
          }
          final student = (state as StudentHomeState).student;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: requiredDocTitles.keys
                .toList()
                .map((key) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            requiredDocTitles[key],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          student.requiredDocuments[key] != null
                              ? DocumentCard(
                                  doc: student.requiredDocuments[key],
                                  icon: "assets/imageicon.png",
                                  requiredDocKey: key,
                                  renameEnabled: true,
                                  onDismiss: (direction) {
                                    var doc = student.requiredDocuments[key];
                                    final bloc =
                                        BlocProvider.of<HomeBloc>(context);

                                    DocumentBloc(
                                      userType: 'student',
                                    ).deleteDocument(
                                      doc.name,
                                      doc.id,
                                      student.id,
                                    );

                                    student.requiredDocuments[key] = null;
                                    bloc.emitNewStudent(student);

                                    bloc.getStudentHome(context: context);

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Document Removed"),
                                    ));
                                  },
                                )
                              : UploadButton(key)
                        ],
                      ),
                    ))
                .toList(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Variables.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Documents",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 23, color: Colors.white),
        ),
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(
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
      body: RefreshIndicator(
        onRefresh: () async {
          getStudentData(context);
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is InitialHomeState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final student = (state as StudentHomeState).student;
                    return student == null
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Divider(color: Colors.white),
                              const SizedBox(
                                height: 8,
                              ),
                              Image.asset(
                                  "assets/images/student_docs_required.png"),
                              const SizedBox(
                                height: 16,
                              ),
                              student == null
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : student.id == null
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : BlocBuilder<HomeBloc, HomeState>(
                                          builder: (context, state) {
                                            return requiredDocumentsList();
                                          },
                                        ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Divider(
                                  color: Color(0xffFF8B86),
                                ),
                              ),
                              student.id == null
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Flexible(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            (student.documents ?? []).length,
                                        itemBuilder: (context, index) {
                                          Document doc =
                                              student.documents[index];
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
                                            child: DocumentCard(
                                              doc: doc,
                                              icon: icon,
                                              index: index,
                                              renameEnabled: true,
                                              onDismiss: (direction) {
                                                var doc =
                                                    student.documents[index];
                                                final bloc =
                                                    BlocProvider.of<HomeBloc>(
                                                        context);

                                                DocumentBloc(
                                                  userType: 'student',
                                                ).deleteDocument(
                                                  doc.name,
                                                  doc.id,
                                                  student.id,
                                                );

                                                student.documents
                                                    .removeAt(index);
                                                bloc.emitNewStudent(student);

                                                bloc.getStudentHome(
                                                    context: context);

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content:
                                                      Text("Document Removed"),
                                                ));
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                              const SizedBox(
                                height: 200,
                              )
                            ],
                          );
                  },
                ),
              ),
            ),
            Align(alignment: Alignment.bottomRight, child: UploadButton())
          ],
        ),
      ),
      endDrawer: MyDrawer(),
    );
  }

  void _showFilePicker(BuildContext context, [String requiredDocType]) async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.any, allowMultiple: true);
    var bloc = BlocProvider.of<HomeBloc>(context, listen: false);
    final student = (bloc.state as StudentHomeState).student;
    if (result != null) {
      EasyLoading.show(status: "Uploading");
      try {
        await DocumentBloc(userType: Variables.userTypeStudent)
            .parseAndUploadFilePickerResult(
          result,
          requiredDocType: requiredDocType,
        );
        if (requiredDocType != null) {
          student.requiredDocuments[requiredDocType] =
              Document(name: result.files.first.name);
          bloc.emitNewStudent(student);
        } else {
          student.documents.add(Document(name: result.files.first.name));
          bloc.emitNewStudent(student);
        }
      } catch (e) {}
      getStudentData(context);
    } else {
      // User canceled the picker
    }
  }

  Widget UploadButton([String requiredDocType]) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {
          _showFilePicker(context, requiredDocType);
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
                    decoration: const BoxDecoration(
                      gradient: Variables.buttonGradient,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.upload_sharp,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Upload ${requiredDocType ?? ''}",
                            style: const TextStyle(
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
