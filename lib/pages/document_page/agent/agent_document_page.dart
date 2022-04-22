import 'package:elite_counsel/pages/document_page/agent/agent_document_upload_button.dart';
import 'package:elite_counsel/pages/document_page/agent/agent_required_documents.dart';
import 'package:elite_counsel/pages/document_page/document_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:elite_counsel/bloc/document_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/models/document.dart';
import 'package:elite_counsel/widgets/drawer.dart';

import '../../../variables.dart';

class AgentDocumentPage extends StatefulWidget {
  const AgentDocumentPage({Key key}) : super(key: key);

  @override
  State<AgentDocumentPage> createState() => _AgentDocumentPageState();
}

class _AgentDocumentPageState extends State<AgentDocumentPage> {
  @override
  void initState() {
    super.initState();
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
          BlocProvider.of<HomeBloc>(context, listen: false).getAgentHome();
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

                    final agent = (state as AgentHomeState).agent;
                    if (agent == null) {
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
                        Image.asset("assets/images/agent_docs_required.png"),
                        const SizedBox(
                          height: 16,
                        ),
                        agent == null
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : agent.id == null
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
                        agent.id == null
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Flexible(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: (agent.documents ?? []).length,
                                  itemBuilder: (context, index) {
                                    Document doc = agent.documents[index];
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
                                          var doc = agent.documents[index];
                                          final bloc =
                                              BlocProvider.of<HomeBloc>(
                                            context,
                                          );

                                          DocumentBloc(
                                            userType: 'agent',
                                          ).deleteDocument(
                                            doc.name,
                                            doc.id,
                                            agent.id,
                                          );

                                          agent.documents.removeAt(index);
                                          bloc.emitNewAgent(agent);

                                          bloc.getAgentHome(context: context);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text("Document Removed"),
                                          ));
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                        const SizedBox(
                          height: 200,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const Align(
              alignment: Alignment.bottomRight,
              child: AgentDocumentUploadButton(),
            ),
          ],
        ),
      ),
      endDrawer: MyDrawer(),
    );
  }
}
