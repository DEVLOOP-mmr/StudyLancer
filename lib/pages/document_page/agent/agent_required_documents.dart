import 'package:elite_counsel/pages/document_page/agent/agent_document_upload_button.dart';
import 'package:elite_counsel/pages/document_page/document_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:elite_counsel/bloc/document_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';

class AgentRequiredDocuments extends StatelessWidget {
  const AgentRequiredDocuments({Key key}) : super(key: key);
  final Map<String, String> requiredDocTitles = const {
    'license': 'License',
    'personalID': 'Personal Identification',
    'registrationCertificate': 'Registration Certificate',
  };
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 11),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is! AgentHomeState) {
            return const CircularProgressIndicator();
          }
          final agent = (state as AgentHomeState).agent;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: requiredDocTitles.keys
                .toList()
                .map((key) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          requiredDocTitles[key],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        agent.requiredDocuments[key] != null
                            ? DocumentCard(
                                renameEnabled: true,
                                doc: agent.requiredDocuments[key],
                                icon: "assets/imageicon.png",
                                requiredDocKey: key,
                                onDismiss: (direction) {
                                  var doc = agent.requiredDocuments[key];
                                  final bloc =
                                      BlocProvider.of<HomeBloc>(context);

                                  DocumentBloc(
                                    userType: 'agent',
                                  ).deleteDocument(
                                    doc.name,
                                    doc.id,
                                    agent.id,
                                  );

                                  agent.requiredDocuments[key] = null;
                                  bloc.emitNewAgent(agent);

                                  bloc.getAgentHome(context: context);

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Document Removed"),
                                  ));
                                },
                              )
                            : AgentDocumentUploadButton(
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
