import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:elite_counsel/chat/backend/firebase_chat_bloc/firebase_chat_bloc.dart';
import 'package:elite_counsel/chat/type/flutter_chat_types.dart' as types;
import 'package:elite_counsel/models/study_lancer_user.dart';
import 'package:flutter/foundation.dart';
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
    Key key,
    @required this.room,
  }) : super(key: key);

  final types.Room room;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isAttachmentUploading = false;
  List<StudyLancerUser> roomUsers = [];

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
      widget.room.id,
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

    if (message.uri.startsWith('http')) {
      final client = http.Client();
      final request = await client.get(Uri.parse(message.uri));
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
        final fileName = x.path.split("/").last;
        final filePath = x.path;
        final file = File(filePath ?? '');

        try {
          final reference = FirebaseStorage.instance.ref(fileName);
          await reference.putFile(file);
          final uri = await reference.getDownloadURL();

          final message = types.PartialFile(
            fileName: fileName ?? '',
            mimeType: lookupMimeType(filePath ?? ''),
            size: x.path.length ?? 0,
            uri: uri,
          );

          BlocProvider.of<FirebaseChatBloc>(context, listen: false).sendMessage(
            message,
            widget.room.id,
          );
          _setAttachmentUploading(false);
        } on FirebaseException catch (e) {
          _setAttachmentUploading(false);
          if (kDebugMode) {
            print(e);
          }
        }
      }
    } else {
      // User canceled the picker
    }
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
          widget.room.id,
        );
        _setAttachmentUploading(false);
      } on FirebaseException catch (e) {
        _setAttachmentUploading(false);
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      // User canceled the picker
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Variables.backgroundColor,
        title: Title(
          color: Variables.backgroundColor,
          child: AutoSizeText(
            widget.room.name ?? '',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<List<types.Message>>(
        stream: BlocProvider.of<FirebaseChatBloc>(context, listen: false)
            .messages(widget.room.id),
        initialData: const [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (var element in snapshot.data) {
              if (element.status != types.Status.read &&
                      element.authorId !=
                          BlocProvider.of<FirebaseChatBloc>(
                            context,
                            listen: false,
                          ).user.uid ??
                  '') {
                BlocProvider.of<FirebaseChatBloc>(context, listen: false)
                    .updateMessage(
                  element.copyWith(status: types.Status.read),
                  widget.room.id,
                );
              }
            }
          }
          
          return Chat(
            isAttachmentUploading: _isAttachmentUploading,
            messages: snapshot.data ?? [],
            onAttachmentPressed: _handleAttachmentPress,
            onFilePressed: _openFile,
            onPreviewDataFetched: _onPreviewDataFetched,
            onSendPressed: _onSendPressed,
            user: types.User(
              id: BlocProvider.of<FirebaseChatBloc>(context, listen: false)
                      .user
                      .uid ??
                  '',
              avatarUrl: FirebaseAuth.instance.currentUser.photoURL,
              firstName: FirebaseAuth.instance.currentUser.displayName,
            ),
          );
        },
      ),
    );
  }
}
