import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:elite_counsel/bloc/document_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/models/document.dart';

import '../../../variables.dart';
class AgentDocumentUploadButton extends StatelessWidget {
  const AgentDocumentUploadButton({
    Key key,
    this.requiredDocType,
  }) : super(key: key);
  final String requiredDocType;

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
      BlocProvider.of<HomeBloc>(context, listen: false).getAgentHome();
      ;
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      borderRadius: BorderRadius.circular(8),),
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
                                fontWeight: FontWeight.w500,),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
