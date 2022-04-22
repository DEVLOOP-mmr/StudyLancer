import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/chat/backend/firebase_chat_bloc/firebase_chat_bloc.dart';
import 'package:elite_counsel/chat/backend/firebase_chat_bloc/firebase_chat_state.dart';
import 'package:elite_counsel/chat/chat_page.dart';
import 'package:elite_counsel/variables.dart';
import 'package:elite_counsel/widgets/drawer.dart';
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
      body: BlocBuilder<FirebaseChatBloc, FirebaseChatState>(
        builder: (context, state) {
          if (state.loadState == LoadState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.rooms.isEmpty) {
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
            itemCount: state.rooms.length,
            itemBuilder: (context, index) {
              final room = state.rooms[index];

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        room: room,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
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
                        const SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
