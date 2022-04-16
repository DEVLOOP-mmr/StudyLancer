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
  const StudentTabbedList({Key key}) : super(key: key);

  @override
  State<StudentTabbedList> createState() => _StudentTabbedListState();
}

class _StudentTabbedListState extends State<StudentTabbedList>
    with TickerProviderStateMixin {
  final String country = 'All';

   TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is! AgentHomeState) {
          return const CircularProgressIndicator();
        }
        final agentHomePageState = state as AgentHomeState;
        final agent = agentHomePageState.agent;
        if (agent == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                // setState(() {
                //   country = null;
                // });

                ///TODO: home bloc set country
              },
            ),
            actions: const [SortButton()],
            backgroundColor: Variables.backgroundColor,
            centerTitle: false,
            title: Text(
              country.toUpperCase(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            bottom: TabBar(
              labelColor: Variables.accentColor,
              indicatorColor: Colors.transparent,
              unselectedLabelColor: Colors.white.withOpacity(0.6),
              isScrollable: true,
              controller: _tabController,
              tabs: const [
                Tab(
                  text: "Awaiting",
                ),
                Tab(
                  text: "Options Provided",
                ),
                Tab(
                  text: "Ongoing",
                ),
              ],
            ),
          ),
          backgroundColor: Variables.backgroundColor,
          body: TabBarView(
            controller: _tabController,
            children: const [
              AwaitingStudents(),
              OptionsProvided(),
              OngoingStudents(),
            ],
          ),
        );
      },
    );
  }
}
