import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/offer_bloc.dart';
import 'package:elite_counsel/chat/backend/firebase_chat_bloc/firebase_chat_bloc.dart';
import 'package:elite_counsel/chat/ui/chat_page/chat_page.dart';
import 'package:elite_counsel/models/agent.dart';
import 'package:elite_counsel/models/application.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/pages/progress_page.dart';
import 'package:elite_counsel/variables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';

enum ApplicationCardViewMode {
  student,
  agent,
}

class ApplicationCard extends StatelessWidget {
  const ApplicationCard({
    Key? key,
    required this.application,
    required this.student,
    required this.viewMode,
  }) : super(key: key);

  final Application application;
  final Student student;
  final ApplicationCardViewMode viewMode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ProgressPage(application: application);
        }));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Neumorphic(
          style: NeumorphicStyle(
            color: Variables.backgroundColor,
            shadowLightColor: Colors.white.withOpacity(0.3),
            lightSource: LightSource.topLeft.copyWith(dx: -2, dy: -2),
            depth: -1,
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(
                        int.parse(application.color!.replaceFirst("#", ""))),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SizedBox(
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                           
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width / 3),
                                child: Text(
                                  application.universityName ?? "",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 150),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: ((application
                                                    .agent?.photo ==
                                                null)
                                            ? const AssetImage(
                                                'assets/images/abc.png',
                                              )
                                            : NetworkImage(
                                                (application.agent?.photo)!,
                                              )) as ImageProvider<Object>?,
                                        // backgroundImage:
                                        //     NetworkImage(offer
                                        //         .agentImage),
                                        radius: 10,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          application.agent?.name ?? "Agent",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              viewMode == ApplicationCardViewMode.student
                                  ? GestureDetector(
                                      onTap: () {
                                        BlocProvider.of<HomeBloc>(context)
                                            .toggleApplicationFavorite(
                                          application.applicationID!,
                                        );
                                      },
                                      child: Icon(
                                        (application.favorite ?? false)
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            application.courseName ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Variables.backgroundColor,
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "Description",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        application.description ?? "",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "Additional Details:",
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          AutoSizeText(
                            application.description ?? "",
                            maxLines: 4,
                            style: const TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const RotatedBox(
                                quarterTurns: 3,
                                child: Icon(
                                  Ionicons.send,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                (application.city ?? "") + ", ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                application.country ?? "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "\$" + application.courseFees!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                "/yr",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // if (offer.accepted)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: NeumorphicButton(
                        padding: EdgeInsets.zero,
                        child: Container(
                          color: Variables.backgroundColor,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Course link",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          log(application.courseLink!);
                          await launch(application.courseLink!,
                              enableJavaScript: true);
                        },
                        style: NeumorphicStyle(
                            border: const NeumorphicBorder(
                                isEnabled: true,
                                color: Variables.backgroundColor,
                                width: 2),
                            shadowLightColor: Colors.white.withOpacity(0.6),
                            // color: Color(0xff294A91),
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(30))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: NeumorphicButton(
                        padding: EdgeInsets.zero,
                        child: Container(
                          color: const Color(0xff294A91),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12),
                            decoration: const BoxDecoration(
                              gradient: Variables.buttonGradient,
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                viewMode == ApplicationCardViewMode.student
                                    ? "Chat with us"
                                    : 'Edit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (viewMode == ApplicationCardViewMode.student) {
                            await _onPressChatButton(context);
                          }
                        },
                        style: NeumorphicStyle(
                          border: const NeumorphicBorder(
                            isEnabled: true,
                            color: Variables.backgroundColor,
                            width: 2,
                          ),
                          shadowLightColor: Colors.white.withOpacity(0.6),
                          // color: Color(0xff294A91),
                          boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (!application.accepted!)
                  const SizedBox(
                    height: 4,
                  ),
                if (!application.accepted!)
                  Text(
                    "*This college application charges \$" +
                        application.applicationFees!,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7)),
                  ),
                if (application.status == 2)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.all(18.0),
                      //   child: NeumorphicButton(
                      //     padding: EdgeInsets.zero,
                      //     child: Container(
                      //       color: Variables.backgroundColor,
                      //       child: Container(
                      //         padding: EdgeInsets.symmetric(
                      //             horizontal: 18,
                      //             vertical: 12),
                      //         child: Align(
                      //           alignment: Alignment.center,
                      //           child: Text(
                      //             "X",
                      //             style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 15,
                      //                 fontWeight:
                      //                     FontWeight.w600),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     onPressed: () async {
                      //       await canLaunch(offer.courseLink)
                      //           ? await launch(
                      //               offer.courseLink)
                      //           : EasyLoading.showError(
                      //               "Cannot launch link");
                      //     },
                      //     style: NeumorphicStyle(
                      //         border: NeumorphicBorder(
                      //             isEnabled: true,
                      //             color: Variables
                      //                 .backgroundColor,
                      //             width: 2),
                      //         shadowLightColor: Colors.white
                      //             .withOpacity(0.6),
                      //         // color: Color(0xff294A91),
                      //         boxShape: NeumorphicBoxShape
                      //             .roundRect(
                      //                 BorderRadius.circular(
                      //                     30))),
                      //   ),
                      // ),
                      viewMode == ApplicationCardViewMode.student
                          ? Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: NeumorphicButton(
                                  padding: EdgeInsets.zero,
                                  child: Container(
                                    color: const Color(0xff294A91),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 12),
                                      decoration: const BoxDecoration(
                                        gradient: Variables.buttonGradient,
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          application.status == 3
                                              ? "Offer Accepted"
                                              : "Accept Offer",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (application.status == 2) {
                                      await OfferBloc.acceptOffer(
                                        application.applicationID,
                                        application.agent?.id,
                                        student.id,
                                      );
                                      await BlocProvider.of<HomeBloc>(context)
                                          .getStudentHome();
                                      EasyLoading.showSuccess("Accepted Offer");
                                    } else {
                                      EasyLoading.showSuccess(
                                          "Offer Already Accepted");
                                    }
                                  },
                                  style: NeumorphicStyle(
                                      border: const NeumorphicBorder(
                                          isEnabled: true,
                                          color: Variables.backgroundColor,
                                          width: 2),
                                      shadowLightColor:
                                          Colors.white.withOpacity(0.6),
                                      // color: Color(0xff294A91),
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(30))),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onPressChatButton(BuildContext context) async {
    var otherUser = Agent();
    otherUser.id = application.agent?.id;
    var currentStudent =
        (BlocProvider.of<HomeBloc>(context).state as StudentHomeState).student;
    final room = await BlocProvider.of<FirebaseChatBloc>(
      context,
      listen: false,
    ).createRoom(currentStudent, otherUser);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          room: room,
        ),
      ),
    );
  }
}
