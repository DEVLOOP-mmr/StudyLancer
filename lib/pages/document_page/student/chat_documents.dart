import 'package:elite_counsel/bloc/document_bloc/documents_state.dart';
import 'package:elite_counsel/models/document.dart';
import 'package:elite_counsel/pages/document_page/document_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/document_bloc/document_bloc.dart';

class ChatDocuments extends StatelessWidget {
  const ChatDocuments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentBloc, ProfileDocumentsState>(
      builder: (context, state) {
        return Column(
          children: List<ExpansionTile>.generate(
            (state.chatDocuments.keys).length,
            (index) {
              var room = (state.chatDocuments.keys).toList()[index];
              List<Document> docs = state.chatDocuments[room] ?? [];
              return ExpansionTile(
                collapsedIconColor: Colors.white,
                iconColor: Colors.white,
                backgroundColor: Colors.black,
                maintainState: true,
                collapsedBackgroundColor: Colors.black,
                title: Text(
                  room.name.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                children: docs.map((doc) {
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
                      renameEnabled: false,
                      onDismiss: (direction) {},
                    ),
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }
}
