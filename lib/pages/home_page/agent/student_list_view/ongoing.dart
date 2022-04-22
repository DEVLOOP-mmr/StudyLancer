import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/pages/home_page/agent/student_list_view/student_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class OngoingStudents extends StatelessWidget {
  const OngoingStudents({
    Key key,
  }) : super(key: key);

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
        final ongoingStudents = agentHomePageState.students.where((element) {
          if (element.applications.isEmpty) {
            return false;
          }
          bool agentIDMatchesApplicationAgentID = element.applications.any(
            (application) =>
                application.status == 3 && application.agentID == agent.id,
          );

          return agentIDMatchesApplicationAgentID;
        }).toList();

        return SingleChildScrollView(
          child: Column(
            children: ongoingStudents.map((student) {
              var ongoingApplications = student.applications
                  .where((app) => app.agentID == agent.id && app.status == 3)
                  .toList();
              print(ongoingApplications);

              return Column(
                children: List.generate(
                  ongoingApplications.length,
                  (index) {
                    var ongoingApplication = ongoingApplications[index];

                    return StudentTile(
                      student: student,
                      courseName: ongoingApplication.courseName,
                    );
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
