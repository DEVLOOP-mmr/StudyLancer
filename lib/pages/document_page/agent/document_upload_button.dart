import 'dart:developer';

import 'package:elite_counsel/bloc/notification_bloc/notification_bloc.dart';
import 'package:elite_counsel/models/agent.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:elite_counsel/bloc/document_bloc/document_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/models/document.dart';

import '../../../variables.dart';

class DocumentUploadButton extends StatelessWidget {
  const DocumentUploadButton({
    Key? key,
    this.requiredDocType,
  }) : super(key: key);
  final String? requiredDocType;

  void _showFilePicker(BuildContext context, [String? requiredDocType]) async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.any, allowMultiple: true);
    var bloc = BlocProvider.of<HomeBloc>(context, listen: false);
    var profile = (bloc.state is AgentHomeState)
        ? (bloc.state as AgentHomeState).agent
        : (bloc.state as StudentHomeState).student!;
    if (result != null) {
      EasyLoading.show(status: "Uploading");
      try {
        String uri = await BlocProvider.of<DocumentBloc>(context, listen: false)
            .parseAndUploadFilePickerResult(
          result,
          requiredDocType: requiredDocType,
        );
        if (requiredDocType != null) {
          (profile is Agent
                  ? (profile).requiredDocuments
                  : (profile as Student).requiredDocuments)![requiredDocType] =
              Document(name: result.files.first.name, link: uri);
          if (profile is Agent) {
            bloc.emitNewAgent(profile);
          } else {
            bloc.emitNewStudent(profile as Student);
          }
        } else {
          (profile is Agent
                  ? (profile).documents
                  : (profile as Student).documents)!
              .add(Document(name: result.files.first.name, link: uri));
          if (profile is Agent) {
            bloc.emitNewAgent(profile);
          } else {
            bloc.emitNewStudent(profile as Student);
          }
        }
      } catch (e) {
        log(e.toString());
      }

      if (requiredDocType != null) {
        if ((profile is Agent
                    ? (profile).requiredDocuments
                    : (profile as Student).requiredDocuments)
                ?.values
                .length ==
            3) {
          NotificationCubit.sendNotificationToUser(
            'Verification Started!',
            'Thanks for uploading your documents, our team will be in touch with you ASAP.',
            FirebaseAuth.instance.currentUser!.uid,
          );
        }
      }
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
                    borderRadius: BorderRadius.circular(8),
                  ),
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
                              fontWeight: FontWeight.w500,
                            ),
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
