import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:elite_counsel/bloc/document_bloc.dart';
import 'package:elite_counsel/chat/backend/firebase_chat_bloc/firebase_chat_bloc.dart';
import 'package:elite_counsel/chat/backend/firebase_chat_bloc/firebase_chat_state.dart';
import 'package:elite_counsel/chat/type/flutter_chat_types.dart' as types;
import 'package:elite_counsel/chat/ui/chat_page/chat_media_page.dart';
import 'package:elite_counsel/models/document.dart';
import 'package:elite_counsel/models/study_lancer_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elite_counsel/chat/ui/widgets/chat.dart';

import 'package:elite_counsel/variables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.room,
  }) : super(key: key);

  final types.Room room;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isAttachmentUploading = false;
  List<StudyLancerUser?> roomUsers = [];
  List<Document> chatDocs = [];
  void getChatDocs() {
    DocumentBloc(userType: 'student').getChatDocs(widget.room.id).then((docs) {
      if (mounted) {
        setState(() {
          chatDocs = docs ?? [];
        });
      }
    });
  }

  void _handleAttachmentPress() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showFilePicker();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Open file picker'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showImagePicker();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Open image picker'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onPreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);
    BlocProvider.of<FirebaseChatBloc>(context, listen: false)
        .updateMessage(updatedMessage, widget.room.id);
  }

  void _onSendPressed(types.PartialText message) {
    BlocProvider.of<FirebaseChatBloc>(context, listen: false).sendMessage(
      message,
      widget.room,
    );
    // var selfUser = Functions.getSelUserID();
    // roomUsers.forEach((element) {
    //   if (element.id != selfUser)
    //     ChatBloc.sendMessageNotification(
    //         selfUser, element.id, message.text, "You have a new message");
    // });
  }

  void _openFile(types.FileMessage message) async {
    var localPath = message.uri;

    if (message.uri!.startsWith('http')) {
      final client = http.Client();
      final request = await client.get(Uri.parse(message.uri!));
      final bytes = request.bodyBytes;
      final documentsDir = (await getApplicationDocumentsDirectory()).path;
      localPath = '$documentsDir/${message.fileName}';

      if (!File(localPath).existsSync()) {
        final file = File(localPath);
        await file.writeAsBytes(bytes);
      }
    }

    await OpenFile.open(localPath);
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  void _showFilePicker() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      for (var x in result.files) {
        final fileName = x.path!.split("/").last;
        final filePath = x.path;
        final file = File(filePath ?? '');

        try {
          final reference = FirebaseStorage.instance.ref(fileName);
          await reference.putFile(file);
          final uri = await reference.getDownloadURL();

          types.PartialFile message = _parsePartialFileFromFirebaseStorageFile(
            fileName,
            filePath,
            x,
            uri,
          );

          BlocProvider.of<FirebaseChatBloc>(context, listen: false).sendMessage(
            message,
            widget.room,
          );
          _addFileToChat(uri, fileName, message.mimeType!);
        } on FirebaseException {
          // _setAttachmentUploading(false);
          // if (kDebugMode) {
          //   print(e);
          // }
        }
      }
    }
  }

  types.PartialFile _parsePartialFileFromFirebaseStorageFile(
      String fileName, String? filePath, PlatformFile x, String uri) {
    final message = types.PartialFile(
      fileName: fileName,
      mimeType: lookupMimeType(filePath ?? ''),
      size: x.path!.length,
      uri: uri,
    );
    return message;
  }

  void _addFileToChat(
    String uri,
    String fileName,
    String type,
  ) {
    var document = Document(
      link: uri,
      name: fileName,
      type: type,
    );
    setState(() {
      chatDocs.add(document);
    });
    DocumentBloc(userType: 'student')
        .postChatDocument(document, widget.room.id);
    _setAttachmentUploading(false);
  }

  //new

  void _showImagePicker() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final imageName = result.path.split('/').last;

      try {
        final reference = FirebaseStorage.instance.ref(imageName);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          imageName: imageName,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        BlocProvider.of<FirebaseChatBloc>(context, listen: false).sendMessage(
          message,
          widget.room,
        );
        _addFileToChat(uri, imageName, '.jpg');
        _setAttachmentUploading(false);
      } on FirebaseException {
        // _setAttachmentUploading(false);
        // if (kDebugMode) {
        //   print(e);
        // }
      }
    }
  }

  //new
  getRoomUsers() async {
    /// TODO: get room users
    roomUsers = (await BlocProvider.of<FirebaseChatBloc>(context, listen: false)
            .getRoomDetail(widget.room.id))
        .users;
  }

  @override
  void initState() {
    super.initState();
    getRoomUsers();
    getChatDocs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Variables.backgroundColor,
        title: Title(
          color: Variables.backgroundColor,
          child: Container(
            constraints:
                BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 3),
            child: AutoSizeText(
              widget.room.name ?? '',
              maxLines: 2,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: ((context) => ChatMediaPage(
                        documents: chatDocs,
                        roomID: widget.room.id,
                      )),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(top: 10, right: 15),
              child: Row(
                children: const [
                  Icon(
                    Icons.download,
                    size: 25,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Media',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  )
                ],
              ),
            ),
          ),
        ],
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<FirebaseChatBloc, FirebaseChatState>(
        builder: (context, state) {
          if (state.roomMessages.containsKey(widget.room.id)) {
            for (var element in state.roomMessages[widget.room.id]!) {
              if (element.status != types.Status.read &&
                  element.authorId != FirebaseAuth.instance.currentUser!.uid) {
                BlocProvider.of<FirebaseChatBloc>(context, listen: false)
                    .updateMessage(
                  element.copyWith(status: types.Status.read),
                  widget.room.id,
                );
              }
            }
          }

          return Container(
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black))),
            child: Chat(
              isAttachmentUploading: _isAttachmentUploading,
              messages: state.roomMessages.containsKey(widget.room.id)
                  ? state.roomMessages[widget.room.id]!
                  : [],
              onAttachmentPressed: _handleAttachmentPress,
              onFilePressed: _openFile,
              onPreviewDataFetched: _onPreviewDataFetched,
              onSendPressed: _onSendPressed,
              user: types.User(
                id: BlocProvider.of<FirebaseChatBloc>(context, listen: false)
                    .user!
                    .uid,
                avatarUrl: FirebaseAuth.instance.currentUser!.photoURL,
                firstName: FirebaseAuth.instance.currentUser!.displayName,
              ),
            ),
          );
        },
      ),
    );
  }
}
