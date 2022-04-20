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

class AgentDocumentPage extends StatefulWidget {
  const AgentDocumentPage({Key key}) : super(key: key);

  @override
  State<AgentDocumentPage> createState() => _AgentDocumentPageState();
}

class _AgentDocumentPageState extends State<AgentDocumentPage> {
  Map<String, String> requiredDocTitles = {
    'license': 'License',
    'personalID': 'Personal Identification',
    'registrationCertificate': 'Registration Certificate'
  };
  @override
  void initState() {
    super.initState();
  }

  void getAgentData(BuildContext context) async {
    await BlocProvider.of<HomeBloc>(context, listen: false).getAgentHome();
    await BlocProvider.of<HomeBloc>(context, listen: false).getAgentHome();
  }

  Widget requiredDocumentsList() {
    return Container(
      padding: const EdgeInsets.only(left: 11),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is! AgentHomeState) {
            return Container(child: const CircularProgressIndicator());
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
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        agent.requiredDocuments[key] != null
                            ? DocumentCard(
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
                            : UploadButton(key)
                      ],
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
          getAgentData(context);
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
                                        icon: icon,
                                        index: index,
                                        onDismiss: (direction) {
                                          var doc = agent.documents[index];
                                          final bloc =
                                              BlocProvider.of<HomeBloc>(
                                                  context);

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
    final agent = (bloc.state as AgentHomeState).agent;
    if (result != null) {
      EasyLoading.show(status: "Uploading");
      try {
        await DocumentBloc(userType: Variables.userTypeAgent)
            .parseAndUploadFilePickerResult(
          result,
          requiredDocType: requiredDocType,
        );
        if (requiredDocType != null) {
          agent.requiredDocuments[requiredDocType] =
              Document(name: result.files.first.name);
          bloc.emitNewAgent(agent);
        } else {
          agent.documents.add(Document(name: result.files.first.name));
          bloc.emitNewAgent(agent);
        }
      } catch (e) {}
      getAgentData(context);
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
                    decoration: BoxDecoration(
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
