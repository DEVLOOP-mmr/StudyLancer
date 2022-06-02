import 'dart:developer';

import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/chat/backend/firebase_chat_bloc/firebase_chat_bloc.dart';
import 'package:elite_counsel/chat/ui/chat_page/chat_page.dart';
import 'package:elite_counsel/models/agent.dart';
import 'package:elite_counsel/models/application.dart';
import 'package:elite_counsel/models/document.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/pages/applications_page/offer_card.dart';
import 'package:elite_counsel/pages/document_page/agent/document_page.dart';
import 'package:elite_counsel/pages/document_page/document_card.dart';
import 'package:elite_counsel/pages/home_page/home_page.dart';
import 'package:elite_counsel/pages/offer_page.dart';
import 'package:elite_counsel/pages/progress_page.dart';
import 'package:elite_counsel/variables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class StudentDocOfferPage extends StatelessWidget {
  final Student student;
  final Application? application;
  const StudentDocOfferPage({Key? key, required this.student, this.application})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Variables.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => HomePage(),
              ),
            );
          },
        ),
        title: Text(
          (application?.status ?? 0) > 1 ? "Application" : "Documents",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        backgroundColor: Variables.backgroundColor,
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is! AgentHomeState) {
            return Container();
          }
          var agent = state.agent;

          var size2 = MediaQuery.of(context).size;
          return SizedBox(
            height: size2.height,
            child: Stack(
              children: [
                Positioned(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(color: Colors.white),
                        ),
                        (application?.status ?? 0) > 1
                            ? Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: ApplicationCard(
                                  application: application!,
                                  student: student,
                                  viewMode: ApplicationCardViewMode.agent,
                                ),
                              )
                            : Container(),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 20),
                            child: Column(
                                children: List.generate(
                              (student.requiredDocuments!.keys).length,
                              (index) {
                                var key = student.requiredDocuments!.keys
                                    .toList()[index];
                                Document? doc = student.requiredDocuments![key];
                                if (doc == null) {
                                  return Container();
                                }
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

                                return DocumentCard(
                                  doc: doc,
                                  icon: icon,
                                  onDismiss: (_) {
                                    log('');
                                  },
                                  renameEnabled: false,
                                );
                              },
                            )),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                                children: List<Widget>.generate(
                              (student.documents ?? []).length,
                              (index) {
                                Document doc = student.documents![index];
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

                                return DocumentCard(
                                  doc: doc,
                                  icon: icon,
                                  onDismiss: (_) {
                                    log('');
                                  },
                                  renameEnabled: false,
                                );
                              },
                            )),
                          ),
                        ),
                        SizedBox(
                          height: 200,
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    width: size2.width,
                    child: _bottomSheet(agent, context))
              ],
            ),
          );
        },
      ),
    );
  }

  Column _bottomSheet(Agent? agent, BuildContext context) {
    return Column(
      children: [
        agent!.verified!
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ],
                  color: Variables.backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: application == null || application?.status == 1
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Want to provide best options acc. to documents.",
                            style: TextStyle(
                              fontSize: 12,
                              color: Variables.accentColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SafeArea(
                            child: NeumorphicButton(
                              padding: EdgeInsets.zero,
                              child: Container(
                                color: const Color(0xff294A91),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    gradient: Variables.buttonGradient,
                                  ),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Provide Option ->",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return OfferPage(student: student);
                                }));
                              },
                              style: NeumorphicStyle(
                                border: const NeumorphicBorder(
                                  isEnabled: true,
                                  color: Variables.backgroundColor,
                                  width: 2,
                                ),
                                shadowLightColor: Colors.white.withOpacity(0.6),
                                // color: Color(0xff294A91),
                                boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          SafeArea(
                            child: NeumorphicButton(
                              padding: EdgeInsets.zero,
                              child: Container(
                                color: const Color(0xff294A91),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    gradient: Variables.buttonGradient,
                                  ),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Chat",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                var currentAgent =
                                    (BlocProvider.of<HomeBloc>(context).state
                                            as AgentHomeState)
                                        .agent;
                                var bloc = BlocProvider.of<FirebaseChatBloc>(
                                  context,
                                  listen: false,
                                );

                                final room = await bloc.createRoom(
                                    currentAgent, student);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      room: room,
                                    ),
                                  ),
                                );
                              },
                              style: NeumorphicStyle(
                                border: const NeumorphicBorder(
                                  isEnabled: true,
                                  color: Variables.backgroundColor,
                                  width: 2,
                                ),
                                shadowLightColor: Colors.white.withOpacity(0.6),
                                // color: Color(0xff294A91),
                                boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          (application!.status ?? 0) < 3
                              ? Container()
                              : SafeArea(
                                  child: NeumorphicButton(
                                    padding: EdgeInsets.zero,
                                    child: Container(
                                      color: const Color(0xff294A91),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: const BoxDecoration(
                                          gradient: Variables.buttonGradient,
                                        ),
                                        child: const Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "View Timeline",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return ProgressPage(
                                            application: application);
                                      }));
                                    },
                                    style: NeumorphicStyle(
                                      border: const NeumorphicBorder(
                                        isEnabled: true,
                                        color: Variables.backgroundColor,
                                        width: 2,
                                      ),
                                      shadowLightColor:
                                          Colors.white.withOpacity(0.6),
                                      // color: Color(0xff294A91),
                                      boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(30),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/images/agent_docs_required.png",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    NeumorphicButton(
                      padding: EdgeInsets.zero,
                      child: Container(
                        color: const Color(0xff294A91),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            gradient: Variables.buttonGradient,
                          ),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Upload Documents",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return DocumentPage();
                        }));
                      },
                      style: NeumorphicStyle(
                        border: const NeumorphicBorder(
                          isEnabled: true,
                          color: Variables.backgroundColor,
                          width: 2,
                        ),
                        shadowLightColor: Colors.white.withOpacity(0.6),
                        // color: Color(0xff294A91),
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
