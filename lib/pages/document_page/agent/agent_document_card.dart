import 'package:dio/dio.dart';
import 'package:elite_counsel/widgets/inner_shadow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:elite_counsel/bloc/document_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/models/document.dart';
import 'package:ionicons/ionicons.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../variables.dart';

class AgentDocumentCard extends StatefulWidget {
  final Document doc;
  final String icon;
  final String requiredDocKey;
  final int index;
  const AgentDocumentCard({
    @required this.doc,
    @required this.icon,
    this.requiredDocKey,
    this.index,
  });

  @override
  State<AgentDocumentCard> createState() => _AgentDocumentCardState();
}

class _AgentDocumentCardState extends State<AgentDocumentCard> {
  bool editEnabled = false;
  String newDocName = '';
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeBloc>(context, listen: false);
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is InitialHomeState) {
          return Container();
        }
        final agent = (state as AgentHomeState).agent;
        return Dismissible(
          key: ValueKey(widget.doc.id),
          onDismissed: (direction) {
            DocumentBloc(userType: 'agent').deleteDocument(
              widget.doc.name,
              widget.doc.id,
              FirebaseAuth.instance.currentUser.uid,
            );
            if (widget.requiredDocKey != null) {
              agent.requiredDocuments[widget.requiredDocKey] = null;
              bloc.emitNewAgent(agent);
            } else if (widget.index != null) {
              agent.documents.removeAt(widget.index);
              bloc.emitNewAgent(agent);
            } else {
              return;
            }
            bloc.getAgentHome(context: context);

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: const Text("Document Removed"),
            ));
          },
          child: Container(
            
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
             
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                
                onTap: () async {
                  if (await Permission.storage.request().isGranted) {
                    String filePath = '';
                    var dir = await getApplicationDocumentsDirectory();
                    print(widget.doc.link);
                    try {
                      filePath = dir.path +
                          "/" +
                          widget.doc.name +
                          "." +
                          widget.doc.type;
                      EasyLoading.show(status: "Downloading..");
                      await Dio().download(widget.doc.link, filePath);
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
                leading: Image.asset(
                  widget.icon,
                  width: 46,
                ),
                trailing: Wrap(spacing: 20, children: [
                  widget.requiredDocKey != null
                      ? SizedBox(
                          width: 1,
                          height: 1,
                        )
                      : GestureDetector(
                          onTap: () {
                            if (editEnabled) {
                              DocumentBloc.updateDocument(
                                  widget.doc.id, agent.id, newDocName);
                              
                            }
                            
                            setState(() {
                              editEnabled = !editEnabled;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                color: Color(0x3fC1C1C1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: Icon(
                              editEnabled
                                  ? Ionicons.checkmark
                                  : Ionicons.pencil,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Color(0x3fC1C1C1),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: const Icon(
                      Ionicons.cloud_download_outline,
                      color: Colors.white,
                    ),
                  ),
                ]),
                title: Container(
                  child: editEnabled
                      ? TextFormField(
                          initialValue: widget.doc.name,
                          onChanged: (string) {
                            setState(() {
                              newDocName = string;
                            });
                          },
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          decoration:
                              InputDecoration(border: InputBorder.none),
                        )
                      : AutoSizeText(
                          widget.doc.name,
                          maxFontSize: 14,
                          maxLines: 2,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
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
