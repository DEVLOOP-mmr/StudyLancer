import 'package:dio/dio.dart';
import 'package:elite_counsel/widgets/inner_shadow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:elite_counsel/bloc/document_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/models/document.dart';
import 'package:ionicons/ionicons.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../variables.dart';

class StudentDocumentCard extends StatelessWidget {
  final Document doc;
  final String icon;
  final String requiredDocKey;
  final int index;
  const StudentDocumentCard({
    @required this.doc,
    @required this.icon,
    this.requiredDocKey,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeBloc>(context, listen: false);
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is UnAuthenticatedHomeState) {
          return Container();
        }
        final student = (state as StudentHomeState).student;
        return Dismissible(
          key: ValueKey(doc.id),
          onDismissed: (direction) {
            DocumentBloc.deleteDocument(
              doc.name,
              doc.id,
              FirebaseAuth.instance.currentUser.uid,
            );
            if (requiredDocKey != null) {
              student.requiredDocuments[requiredDocKey] = null;
              bloc.emitNewStudent(student);
            } else if (index != null) {
              student.documents.removeAt(index);
              bloc.emitNewStudent(student);
            } else {
              return;
            }
           // bloc.getStudentHome(context: context);

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: const Text("Document Removed"),
            ));
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
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
                  contentPadding: const EdgeInsets.all(15),
                  leading: Image.asset(icon),
                  trailing: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Color(0x3fC1C1C1),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: const Icon(
                      Ionicons.cloud_download_outline,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    doc.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
