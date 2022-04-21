import 'package:accordion/accordion.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/models/application.dart';
import 'package:elite_counsel/pages/applications_page/offer_card.dart';
import 'package:elite_counsel/pages/home_page/student/student_home.dart';
import 'package:elite_counsel/widgets/drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ionicons/ionicons.dart';

import '../../variables.dart';

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
            fontWeight: FontWeight.bold,
            fontSize: 23,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        actions: [
          const SortApplicationsButton(),
          GestureDetector(
            child: Image.asset("assets/images/menu.png"),
            onTap: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<HomeBloc>(context).getStudentHome(context: context);
        },
        child: Padding(
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
                  !(student.verified ?? false)
                      ? const Center(child: UploadRequiredDocumentsPrompt())
                      : Expanded(
                          child: (student.applications ?? []).isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      (student.applications ?? []).length,
                                  itemBuilder: (context, index) {
                                    Application offer;
                                    offer = student.applications[index];

                                    return OfferCard(
                                      offer: offer,
                                      student: student,
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(
                                    "No Applications",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                        ),
                ],
              );
            },
          ),
        ),
      ),
      endDrawer: MyDrawer(),
    );
  }
}

class SortApplicationsButton extends StatelessWidget {
  const SortApplicationsButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is! StudentHomeState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return GestureDetector(
          child: const Icon(Ionicons.filter_circle_outline),
          onTap: () async {
            var result = await showDialog(
              context: context,
              builder: (context) => SizedBox(
                height: 300,
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Variables.backgroundColor,
                  child: Column(
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
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontStyle: FontStyle.normal,
                                fontFamily: "roboto",
                              ),
                            ),
                            content: Column(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop("desc");
                                  },
                                  child: const Text(
                                    "High to Low",
                                    style: TextStyle(
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
                            ),
                          ),
                          AccordionSection(
                            header: const Text(
                              "Sort by Application Fees",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontStyle: FontStyle.normal,
                                fontFamily: "roboto",
                              ),
                            ),
                            content: Column(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop("desc");
                                  },
                                  child: const Text(
                                    "High To Low",
                                    style: TextStyle(
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
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
            if (result != null) {
              BlocProvider.of<HomeBloc>(context).sortApplications(result);
            }
          },
        );
      },
    );
  }
}
