import 'package:elite_counsel/models/agent.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/pages/document_page/agent/document_upload_button.dart';
import 'package:elite_counsel/pages/document_page/document_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:elite_counsel/bloc/document_bloc/document_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';

class AgentRequiredDocuments extends StatelessWidget {
  const AgentRequiredDocuments({Key? key}) : super(key: key);
  Map<String, String> requiredDocTitles(HomeState state) {
    if (state is InitialHomeState) {
      return {};
    }
    return state is AgentHomeState
        ? {
            'license': 'License',
            'personalID': 'Personal Identification',
            'registrationCertificate': 'Registration Certificate',
          }
        : {
            'passport': 'Passport',
            'englishProficiencyTest': 'English Proficiency Test',
            'academics': 'Academics',
          };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      padding: const EdgeInsets.only(left: 11),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is InitialHomeState) {
            return const CircularProgressIndicator();
          }

          var profile = (state is AgentHomeState)
              ? (state).agent
              : (state as StudentHomeState).student!;
          if (profile == null) {
            return Container();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: requiredDocTitles(state)
                .keys
                .toList()
                .map((key) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          requiredDocTitles(state)[key]!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        (profile is Agent
                                    ? (profile).requiredDocuments
                                    : (profile as Student)
                                        .requiredDocuments)![key] !=
                                null
                            ? DocumentCard(
                                renameEnabled: true,
                                doc: (profile is Agent
                                    ? (profile).requiredDocuments
                                    : (profile as Student)
                                        .requiredDocuments)![key],
                                icon: "assets/imageicon.png",
                                requiredDocKey: key,
                                onDismiss: (direction) {
                                  var doc = (profile is Agent
                                      ? (profile).requiredDocuments
                                      : (profile as Student)
                                          .requiredDocuments)![key]!;
                                  final bloc =
                                      BlocProvider.of<HomeBloc>(context);

                                  BlocProvider.of<DocumentBloc>(context,
                                          listen: false)
                                      .deleteDocument(
                                    doc.name,
                                    doc.id,
                                    FirebaseAuth.instance.currentUser!.uid,
                                  );

                                  (profile is Agent
                                      ? (profile).requiredDocuments
                                      : (profile as Student)
                                          .requiredDocuments)![key] = null;
                                  if (profile is Agent) {
                                    bloc.emitNewAgent(profile);
                                  } else {
                                    bloc.emitNewStudent(profile as Student);
                                  }

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Document Removed"),
                                  ));
                                },
                              )
                            : DocumentUploadButton(
                                requiredDocType: key,
                              ),
                      ],
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
