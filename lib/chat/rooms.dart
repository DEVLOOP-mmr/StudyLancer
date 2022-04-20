import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/chat/backend/firebase_chat_core.dart';
import 'package:elite_counsel/chat/chat.dart';
import 'package:elite_counsel/chat/type/flutter_chat_types.dart' as types;
import 'package:elite_counsel/models/study_lancer_user.dart';
import 'package:elite_counsel/variables.dart';
import 'package:elite_counsel/widgets/drawer.dart';
import 'package:elite_counsel/widgets/inner_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({Key key}) : super(key: key);

  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Variables.backgroundColor,
      appBar: AppBar(
        backgroundColor: Variables.backgroundColor,
        centerTitle: false,
        actions: [
          GestureDetector(
            child: Image.asset("assets/images/menu.png"),
            onTap: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
          ),
        ],
        leading: null,
        title: const Text(
          "Chats",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 23, color: Colors.white),
        ),
      ),
      endDrawer: MyDrawer(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is InitialHomeState) {
            return CircularProgressIndicator();
          }
          var homeState = state is AgentHomeState
              ? state as AgentHomeState
              : state as StudentHomeState;
          StudyLancerUser user = homeState is AgentHomeState
              ? homeState.agent
              : (homeState as StudentHomeState).student;
          return StreamBuilder<List<types.Room>>(
            stream: FirebaseChatCore.instance.rooms(user),
            initialData: const [],
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                    bottom: 200,
                  ),
                  child: const Text(
                    'No chats',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final room = snapshot.data[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            roomId: room.id,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 8),
                      child: InnerShadow(
                        blur: 5,
                        offset: const Offset(5, 5),
                        color: Colors.black.withOpacity(0.38),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Variables.backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 54,
                                margin: const EdgeInsets.only(
                                  right: 16,
                                ),
                                width: 54,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: room.imageUrl ??
                                        "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  room.name ?? 'User',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
