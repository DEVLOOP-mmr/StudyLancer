import 'dart:developer';

import 'package:elite_counsel/bloc/document_bloc/document_bloc.dart';
import 'package:elite_counsel/models/document.dart';
import 'package:elite_counsel/pages/document_page/document_card.dart';
import 'package:elite_counsel/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../type/room.dart';

class ChatMediaPage extends StatefulWidget {
  const ChatMediaPage({
    Key? key,
    required this.documents,
    required this.room,
  }) : super(key: key);
  final List<Document> documents;
  final Room room;
  @override
  State<ChatMediaPage> createState() => _ChatMediaPageState();
}

class _ChatMediaPageState extends State<ChatMediaPage> {
  List<Document> chatDocs = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        chatDocs = widget.documents;
      });

      if (chatDocs.isEmpty) {
        getChatDocs();
      }
    });
  }

  void getChatDocs() {
    BlocProvider.of<DocumentBloc>(context, listen: false)
        .getChatDocs(widget.room)
        .then((docs) {
      if (mounted) {
        setState(() {
          chatDocs = docs ?? [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Variables.backgroundColor,
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Variables.backgroundColor,
        title: Title(
          color: Colors.white,
          child: const Text(
            'Chat Media',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: chatDocs.isEmpty
          ? RefreshIndicator(
              onRefresh: () async {
                getChatDocs();
              },
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                  ),
                  const Center(
                    child: Text(
                      'No Documents For This Chat',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                getChatDocs();
              },
              child: ListView.builder(
                itemCount: chatDocs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DocumentCard(
                      doc: chatDocs[index],
                      icon: "assets/imageicon.png",
                      onDismiss: (_) {
                        log('dismissed');
                      },
                      renameEnabled: false,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
