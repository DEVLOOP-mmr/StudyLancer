import 'dart:io';

import 'package:elite_counsel/chat/backend/firebase_chat_core.dart';
import 'package:elite_counsel/chat/type/flutter_chat_types.dart' as types;
import 'package:elite_counsel/models/study_lancer_user.dart';
import 'package:elite_counsel/pages/home_page/home_page.dart';
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
    @required this.roomId,
  }) : super(key: key);

  final String roomId;

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
    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.roomId);
  }

  void _onSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.sendMessage(
      message,
      widget.roomId,
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

          FirebaseChatCore.instance.sendMessage(
            message,
            widget.roomId,
          );
          _setAttachmentUploading(false);
        } on FirebaseException catch (e) {
          _setAttachmentUploading(false);
          print(e);
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

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.roomId,
        );
        _setAttachmentUploading(false);
      } on FirebaseException catch (e) {
        _setAttachmentUploading(false);
        print(e);
      }
    } else {
      // User canceled the picker
    }
  }

  //new
  getRoomUsers() async {
    roomUsers =
        (await FirebaseChatCore.instance.getRoomDetail(widget.roomId)).users;
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
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.white),
        ),
        leading: BackButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: ((context) {
              return const HomePage();
            })));
          },
        ),
      ),
      body: StreamBuilder<List<types.Message>>(
        stream: FirebaseChatCore.instance.messages(widget.roomId),
        initialData: const [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            print(widget.roomId);
            print("@123kjxncslkjkdn");
            for (var element in snapshot.data) {
              if (element.status != types.Status.read &&
                      element.authorId != FirebaseChatCore.instance.user.uid ??
                  '') {
                FirebaseChatCore.instance.updateMessage(
                    element.copyWith(status: types.Status.read), widget.roomId);
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
              id: FirebaseChatCore.instance.user.uid ?? '',
              avatarUrl: FirebaseAuth.instance.currentUser.photoURL,
              firstName: FirebaseAuth.instance.currentUser.displayName,
            ),
          );
        },
      ),
    );
  }
}
