import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite_counsel/bloc/cubit/student_application_cubit.dart';
import 'package:elite_counsel/bloc/document_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/chat/backend/firebase_chat_bloc/firebase_chat_bloc.dart';
import 'package:elite_counsel/chat/backend/firebase_chat_bloc/firebase_chat_state.dart';
import 'package:elite_counsel/chat/type/flutter_chat_types.dart' as types;
import 'package:elite_counsel/chat/ui/chat_page/chat_media_page.dart';
import 'package:elite_counsel/models/application.dart';
import 'package:elite_counsel/models/document.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/models/study_lancer_user.dart';
import 'package:elite_counsel/pages/home_page/agent/student_list_view/student_tabbed_list.dart';
import 'package:elite_counsel/pages/progress_page.dart';
import 'package:elite_counsel/pages/student_detail_page.dart';
import 'package:elite_counsel/pages/student_doc_offer_page.dart';
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
  List<Document> chatDocs = [];
  List<StudyLancerUser?> roomUsers = [];

  bool _isAttachmentUploading = false;

  @override
  void initState() {
    super.initState();
    startMessagesListener();
    getChatDocs();
  }

  void getChatDocs() {
    DocumentBloc(userType: 'student').getChatDocs(widget.room.id).then((docs) {
      if (mounted) {
        setState(() {
          chatDocs = docs ?? [];
        });
      }
    });
  }

  //new
  startMessagesListener() async {
    BlocProvider.of<FirebaseChatBloc>(context, listen: false)
        .messages(widget.room.id);
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

  void _markMessageAsRead(
    FirebaseChatState state,
  ) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Variables.backgroundColor,
      appBar: AppBar(
        backgroundColor: Variables.backgroundColor,
        leadingWidth: 20,
        title: Title(
          color: Variables.backgroundColor,
          child: Row(
            children: [
              Container(
                height: 30,
                margin: const EdgeInsets.only(
                  right: 16,
                ),
                width: 30,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: (widget.room.imageUrl ?? "").isEmpty
                        ? "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg"
                        : widget.room.imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 3),
                child: AutoSizeText(
                  widget.room.name ?? '',
                  maxLines: 2,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
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
      body: Stack(
        children: [
          BlocBuilder<FirebaseChatBloc, FirebaseChatState>(
            builder: (context, state) {
              _markMessageAsRead(state);

              return Container(
                child: Center(
                    child: Column(
                  children: [
                    Expanded(
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
                          id: BlocProvider.of<FirebaseChatBloc>(context,
                                  listen: false)
                              .user!
                              .uid,
                          avatarUrl:
                              FirebaseAuth.instance.currentUser!.photoURL,
                          firstName:
                              FirebaseAuth.instance.currentUser!.displayName,
                        ),
                      ),
                    ),
                  ],
                )),
              );
            },
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is! AgentHomeState) {
                return Container();
              }
              return StudentApplicationStatuses(
                  student: widget.room.users.last! as Student);
            },
          ),
        ],
      ),
    );
  }
}

class StudentApplicationStatuses extends StatelessWidget {
  const StudentApplicationStatuses({Key? key, required this.student})
      : super(key: key);
  final Student student;

  Application? _maxProgressApplications(List<Application>? applications) {
    if (applications == null) {
      return null;
    }
    if (applications.isEmpty) {
      return null;
    }

    var application = applications.first;
    for (var a in applications) {
      if ((a.progress ?? 0) > (application.progress ?? 0)) {
        application = a;
      }
    }
    return application;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          var agentHome = state as AgentHomeState;
          var applications = agentHome.applications
              ?.where(((element) =>
                  element.agent!.id == FirebaseAuth.instance.currentUser!.uid &&
                  element.student?.id == student.id))
              .toList();
          ;
          return applications?.isEmpty ?? false
              ? Container()
              : GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return StudentTabbedList(
                        filterStudentID: student.id,
                        showOnlyOngoingApplications: true,
                      );
                    }));
                  },
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: applications!.length!,
                      itemBuilder: (_, index) {
                        final application = applications![index];
                        return Container(
                          color: Colors.black,
                          child: ListTile(
                            tileColor: Colors.black,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Status for ${application.courseName}',
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 11),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    StudentApplicationCubit
                                            .parseProgressTitleFromValue(
                                                application.country.toString(),
                                                application.progress!) ??
                                        '',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width / 2.5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return StudentDocOfferPage(
                                            student: student,
                                            application: application,
                                          );
                                        }));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: const Color(0xff294A91),
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                                gradient:
                                                    Variables.buttonGradient,
                                                border: Border.all(),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: const Align(
                                              alignment: Alignment.center,
                                              child: AutoSizeText(
                                                "View Application",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                );
        },
      ),
    );
  }
}
