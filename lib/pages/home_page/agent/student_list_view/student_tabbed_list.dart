import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/pages/home_page/agent/student_list_view/awaiting.dart';
import 'package:elite_counsel/pages/home_page/agent/student_list_view/ongoing.dart';
import 'package:elite_counsel/pages/home_page/agent/student_list_view/options_provided.dart';
import 'package:elite_counsel/pages/home_page/agent/student_list_view/sort_button.dart';
import 'package:elite_counsel/variables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class StudentTabbedList extends StatefulWidget {
  const StudentTabbedList(
      {Key? key, this.showOnlyOngoingApplications, this.filterStudentID})
      : super(key: key);

  final bool? showOnlyOngoingApplications;
  final String? filterStudentID;

  @override
  State<StudentTabbedList> createState() => _StudentTabbedListState();
}

class _StudentTabbedListState extends State<StudentTabbedList>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
        length: widget.showOnlyOngoingApplications ?? false ? 1 : 3,
        vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is! AgentHomeState) {
          return const CircularProgressIndicator();
        }
        final agentHomePageState = state;
        final agent = agentHomePageState.agent;
        if (agent == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            leading: widget.showOnlyOngoingApplications ?? false
                ? null
                : IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
            actions: const [SortButton()],
            backgroundColor: Variables.backgroundColor,
            centerTitle: false,
            title: Text(
              widget.showOnlyOngoingApplications ?? false ? '' : 'ALL',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Variables.backgroundColor,
          body: RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<HomeBloc>(context).getAgentHome(context: context);
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is! AgentHomeState) {
                        return const CircularProgressIndicator();
                      }
                      final agentHomePageState = state;
                      final agent = agentHomePageState.agent;
                      if (agent == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      var verifiedStudents =
                          agentHomePageState.verifiedStudents;
                      final optionsProvidedApplications =
                          agentHomePageState.applications!.where((element) {
                        bool agentIDMatchesApplicationAgentID =
                            element.status == 2 &&
                                element.agent?.id == agent.id;

                        return agentIDMatchesApplicationAgentID;
                      }).toList();
                      final ongoingApplications =
                          agentHomePageState.applications!.where((element) {
                        bool agentIDMatchesApplicationAgentID =
                            element.status == 3 &&
                                element.agent?.id == agent.id;
                        if (widget.filterStudentID != null) {
                          return agentIDMatchesApplicationAgentID &&
                              element.student!.id == widget.filterStudentID;
                        }
                        return agentIDMatchesApplicationAgentID;
                      }).toList();

                      return TabBar(
                        labelColor: Variables.accentColor,
                        indicatorColor: Colors.transparent,
                        unselectedLabelColor: Colors.white.withOpacity(0.6),
                        isScrollable: true,
                        controller: _tabController,
                        tabs: widget.showOnlyOngoingApplications ?? false
                            ? [
                                Tab(
                                  text:
                                      "Ongoing(${ongoingApplications.length ?? 0})",
                                ),
                              ]
                            : [
                                Tab(
                                  text:
                                      "Awaiting(${verifiedStudents?.length ?? 0})",
                                ),
                                Tab(
                                  text:
                                      "Options Provided(${optionsProvidedApplications.length ?? 0})",
                                ),
                                Tab(
                                  text:
                                      "Ongoing(${ongoingApplications.length ?? 0})",
                                ),
                              ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Flexible(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 100,
                      child: TabBarView(
                        controller: _tabController,
                        children: widget.showOnlyOngoingApplications ?? false
                            ? [
                                OngoingStudents(
                                  filterStudentID: widget.filterStudentID,
                                ),
                              ]
                            : [
                                const AwaitingStudents(),
                                const OptionsProvided(),
                                OngoingStudents(
                                  filterStudentID: widget.filterStudentID,
                                ),
                              ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
