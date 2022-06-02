import 'package:elite_counsel/models/agent.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/pages/document_page/agent/document_upload_button.dart';
import 'package:elite_counsel/pages/document_page/agent/required_documents.dart';
import 'package:elite_counsel/pages/document_page/document_card.dart';
import 'package:elite_counsel/pages/document_page/student/chat_documents.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:elite_counsel/bloc/document_bloc/document_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/models/document.dart';
import 'package:elite_counsel/widgets/drawer.dart';

import '../../../variables.dart';

class DocumentPage extends StatelessWidget {
  const DocumentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Variables.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Documents",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            color: Colors.white,
          ),
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
          }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<HomeBloc>(context, listen: false).getHome();
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is InitialHomeState) {
                      return Container();
                    }

                    var profile = (state is AgentHomeState)
                        ? (state).agent
                        : (state as StudentHomeState).student!;
                    if (profile == null) {
                      return Container();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Divider(color: Colors.white),
                        const SizedBox(
                          height: 8,
                        ),
                        !((profile is Agent
                                ? (profile).verified
                                : (profile as Student).verified))!
                            ? Image.asset(
                                "assets/images/${profile is Agent ? 'agent' : 'student'}_docs_required.png",
                              )
                            : Container(),
                        const SizedBox(
                          height: 16,
                        ),
                        profile == null
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : (profile is Agent
                                        ? (profile).id
                                        : (profile as Student).id) ==
                                    null
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : BlocBuilder<HomeBloc, HomeState>(
                                    builder: (context, state) {
                                      return const AgentRequiredDocuments();
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
                        (profile is Agent
                                    ? (profile).id
                                    : (profile as Student).id) ==
                                null
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Flexible(
                                child: Column(
                                    children: List.generate(
                                  ((profile is Agent
                                              ? (profile).documents
                                              : (profile as Student)
                                                  .documents) ??
                                          [])
                                      .length,
                                  (index) {
                                    Document doc = (profile is Agent
                                        ? (profile).documents
                                        : (profile as Student)
                                            .documents)![index];
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
                                        renameEnabled: true,
                                        icon: icon,
                                        index: index,
                                        onDismiss: (direction) {
                                          var doc = (profile is Agent
                                              ? (profile).documents
                                              : (profile as Student)
                                                  .documents)![index];
                                          final bloc =
                                              BlocProvider.of<HomeBloc>(
                                            context,
                                          );

                                          BlocProvider.of<DocumentBloc>(context,
                                                  listen: false)
                                              .deleteDocument(
                                            doc.name,
                                            doc.id,
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                          );

                                          (profile is Agent
                                                  ? (profile).documents
                                                  : (profile as Student)
                                                      .documents)!
                                              .removeAt(index);
                                          if (profile is Agent) {
                                            bloc.emitNewAgent(profile);
                                          } else {
                                            bloc.emitNewStudent(
                                                profile as Student);
                                          }

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text("Document Removed"),
                                          ));
                                        },
                                      ),
                                    );
                                  },
                                )),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Chat Documents',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ChatDocuments(),
                        const SizedBox(
                          height: 300,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const Align(
              alignment: Alignment.bottomRight,
              child: DocumentUploadButton(),
            ),
          ],
        ),
      ),
      endDrawer: MyDrawer(),
    );
  }
}
