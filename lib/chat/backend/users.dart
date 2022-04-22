import 'package:elite_counsel/chat/type/flutter_chat_types.dart' as types;
import 'package:elite_counsel/models/study_lancer_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../chat_page.dart';
import 'firebase_chat_bloc/firebase_chat_bloc.dart';

@Deprecated("Figma has no page to show list of users, unused in Widget Tree")
class UsersPage extends StatelessWidget {
  const UsersPage({Key key}) : super(key: key);

  void _handlePressed(StudyLancerUser otherUser, BuildContext context) async {
    // final room = await FirebaseChatCore.instance.createRoom(otherUser);

    // Navigator.of(context).pop();
    // await Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => ChatPage(
    //       roomId: room.id,
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
    //   body: StreamBuilder<List<types.User>>(
    //     stream: BlocProvider.of<FirebaseChatBloc>(context,

    //     initialData: const [],
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData || snapshot.data.isEmpty) {
    //         return Container(
    //           alignment: Alignment.center,
    //           margin: const EdgeInsets.only(
    //             bottom: 200,
    //           ),
    //           child: const Text('No users'),
    //         );
    //       }

    //       return ListView.builder(
    //         itemCount: snapshot.data.length,
    //         itemBuilder: (context, index) {
    //           final user = snapshot.data[index];

    //           return GestureDetector(
    //             onTap: () {
    //               /// TODO: _handlePressed(user, context);
    //             },
    //             child: Container(
    //               padding: const EdgeInsets.symmetric(
    //                 horizontal: 16,
    //                 vertical: 8,
    //               ),
    //               child: Row(
    //                 children: [
    //                   Container(
    //                     height: 40,
    //                     margin: const EdgeInsets.only(
    //                       right: 16,
    //                     ),
    //                     width: 40,
    //                     child: ClipRRect(
    //                       borderRadius: const BorderRadius.all(
    //                         Radius.circular(20),
    //                       ),
    //                       child: Image.network(
    //                         user.avatarUrl ?? '',
    //                       ),
    //                     ),
    //                   ),
    //                   Text('${user.firstName} ${user.lastName}'),
    //                 ],
    //               ),
    //             ),
    //           );
    //         },
    //       );
    //     },
    //   ),
    // );
  }
}
