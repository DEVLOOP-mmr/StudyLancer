import 'package:accordion/accordion.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/bloc/offer_bloc.dart';
import 'package:elite_counsel/chat/backend/firebase_chat_core.dart';
import 'package:elite_counsel/chat/chat.dart';
import 'package:elite_counsel/chat/type/user.dart' as types;
import 'package:elite_counsel/models/application.dart';
import 'package:elite_counsel/widgets/drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../variables.dart';

class ApplicationPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ApplicationPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Variables.backgroundColor,
      appBar: AppBar(
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
        automaticallyImplyLeading: true,
        title: const Text(
          "Applications",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 23, color: Colors.white),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        actions: [
          SortApplicationsButton(),
          GestureDetector(
            child: Image.asset("assets/images/menu.png"),
            onTap: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is! StudentHomeState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final studentHomeState = state as StudentHomeState;
            final student = studentHomeState.student;
            return Column(
              children: [
                const Divider(color: Colors.white),
                Expanded(
                  child: (student.applications ?? []).isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: (student.applications ?? []).length,
                          itemBuilder: (context, index) {
                            Application offer;
                            offer = student.applications[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                  color: Variables.backgroundColor,
                                  shadowLightColor:
                                      Colors.white.withOpacity(0.3),
                                  lightSource: LightSource.topLeft
                                      .copyWith(dx: -2, dy: -2),
                                  depth: -1,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Color(int.parse(offer.color
                                                .replaceFirst("#", ""))),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Container(
                                          height: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Stack(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child:
                                                          FractionallySizedBox(
                                                        widthFactor: 0.6,
                                                        child: Text(
                                                          offer.universityName ??
                                                              "",
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 23,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child:
                                                          FractionallySizedBox(
                                                        widthFactor: 0.4,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.4),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Row(
                                                              children: [
                                                                CircleAvatar(
                                                                  backgroundImage: (offer
                                                                              .agentImage ==
                                                                          null)
                                                                      ? const AssetImage(
                                                                          'assets/images/abc.png')
                                                                      : NetworkImage(
                                                                          offer
                                                                              .agentImage),
                                                                  // backgroundImage:
                                                                  //     NetworkImage(offer
                                                                  //         .agentImage),
                                                                  radius: 10,
                                                                ),
                                                                const SizedBox(
                                                                  width: 4,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    offer.agentName ??
                                                                        "",
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .white),
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  offer.courseName ?? "",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                              backgroundColor:
                                                                  Variables
                                                                      .backgroundColor,
                                                              content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  const Text(
                                                                    "Description",
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Text(
                                                                    offer.description ??
                                                                        "",
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ));
                                                  },
                                                  child: const Text(
                                                    "Additional Details",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        fontSize: 10,
                                                        color: Colors.white),
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
                                                      (offer.city ?? "") + ", ",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12,
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      offer.country ?? "",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12,
                                                          color: Colors.white),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      "\$" + offer.courseFees ??
                                                          "0",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12,
                                                          color: Colors.white),
                                                    ),
                                                    const Text(
                                                      "/yr",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 10,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      // if (offer.accepted)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: NeumorphicButton(
                                              padding: EdgeInsets.zero,
                                              child: Container(
                                                color:
                                                    Variables.backgroundColor,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 18,
                                                      vertical: 12),
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Course link",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () async {
                                                await canLaunch(
                                                        offer.courseLink)
                                                    ? await launch(
                                                        offer.courseLink)
                                                    : EasyLoading.showError(
                                                        "Cannot launch link");
                                              },
                                              style: NeumorphicStyle(
                                                  border: NeumorphicBorder(
                                                      isEnabled: true,
                                                      color: Variables
                                                          .backgroundColor,
                                                      width: 2),
                                                  shadowLightColor: Colors.white
                                                      .withOpacity(0.6),
                                                  // color: Color(0xff294A91),
                                                  boxShape: NeumorphicBoxShape
                                                      .roundRect(
                                                          BorderRadius.circular(
                                                              30))),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: NeumorphicButton(
                                              padding: EdgeInsets.zero,
                                              child: Container(
                                                color: const Color(0xff294A91),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 18,
                                                      vertical: 12),
                                                  decoration: BoxDecoration(
                                                    gradient: Variables
                                                        .buttonGradient,
                                                  ),
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Chat with us",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () async {
                                                var otherUser = types.User(
                                                  id: offer.studentID,
                                                );
                                                FirebaseChatCore.instance
                                                    .createUserInFirestore(
                                                        otherUser);
                                                final room =
                                                    await FirebaseChatCore
                                                        .instance
                                                        .createRoom(otherUser);
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatPage(
                                                      roomId: room.id,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: NeumorphicStyle(
                                                  border: NeumorphicBorder(
                                                      isEnabled: true,
                                                      color: Variables
                                                          .backgroundColor,
                                                      width: 2),
                                                  shadowLightColor: Colors.white
                                                      .withOpacity(0.6),
                                                  // color: Color(0xff294A91),
                                                  boxShape: NeumorphicBoxShape
                                                      .roundRect(
                                                          BorderRadius.circular(
                                                              30))),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (!offer.accepted)
                                        const SizedBox(
                                          height: 4,
                                        ),
                                      if (!offer.accepted)
                                        Text(
                                          "*This college application charges \$" +
                                              offer.applicationFees,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 12,
                                              color: Colors.white
                                                  .withOpacity(0.7)),
                                        ),
                                      if (!offer.accepted)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
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
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(18.0),
                                                child: NeumorphicButton(
                                                  padding: EdgeInsets.zero,
                                                  child: Container(
                                                    color:
                                                        const Color(0xff294A91),
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 18,
                                                          vertical: 12),
                                                      decoration: BoxDecoration(
                                                        gradient: Variables
                                                            .buttonGradient,
                                                      ),
                                                      child: const Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Text(
                                                          "Accept Offer",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    await OfferBloc.acceptOffer(
                                                      offer.offerId,
                                                      offer.agentID,
                                                      student.id,
                                                    );
                                                    EasyLoading.showSuccess(
                                                        "Accepted Offer");
                                                  },
                                                  style: NeumorphicStyle(
                                                      border: NeumorphicBorder(
                                                          isEnabled: true,
                                                          color: Variables
                                                              .backgroundColor,
                                                          width: 2),
                                                      shadowLightColor: Colors
                                                          .white
                                                          .withOpacity(0.6),
                                                      // color: Color(0xff294A91),
                                                      boxShape:
                                                          NeumorphicBoxShape
                                                              .roundRect(
                                                                  BorderRadius
                                                                      .circular(
                                                                          30))),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            "No Applications",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white.withOpacity(0.7)),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
      endDrawer: MyDrawer(),
    );
  }

  Widget SortApplicationsButton() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is! StudentHomeState) {
          return const Center(
            child: const CircularProgressIndicator(),
          );
        }
        final studentHomeState = state as StudentHomeState;
        final selfData = studentHomeState.student;
        return GestureDetector(
          child: const Icon(Ionicons.filter_circle_outline),
          onTap: () async {
            var result = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: Variables.backgroundColor,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Accordion(
                            maxOpenSections: 1,
                            headerBackgroundColor: Variables.backgroundColor,
                            contentBackgroundColor: Variables.backgroundColor,
                            children: [
                              AccordionSection(
                                  header: const Text(
                                    "Sort by Tuition Fees",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "roboto"),
                                  ),
                                  content: Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop("desc");
                                        },
                                        child: const Text(
                                          "High to Low",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop("asc");
                                        },
                                        child: const Text(
                                          "Low To High",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              AccordionSection(
                                  header: const Text(
                                    "Sort by Application Fees",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "roboto"),
                                  ),
                                  content: Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop("desc");
                                        },
                                        child: const Text(
                                          "High To Low",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop("asc");
                                        },
                                        child: const Text(
                                          "Low To High",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ));
            if (result != null) {
              BlocProvider.of<HomeBloc>(context).sortApplications(result);
            
            }
          },
        );
      },
    );
  }
}
