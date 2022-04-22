import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/pages/home_page/agent/student_list_view/student_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class OptionsProvided extends StatelessWidget {
  const OptionsProvided({
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
        final optionsProvided = agentHomePageState.students.where((element) {
          if (element.applications.isEmpty) {
            return false;
          }
          bool agentIDMatchesApplicationAgentID = element.applications.any(
            (application) =>
                application.status == 2 && application.agentID == agent.id,
          );

          return agentIDMatchesApplicationAgentID;
        }).toList();

        return ListView.builder(
          itemCount: optionsProvided.length,
          itemBuilder: (context, index) {
            var student = optionsProvided[index];
            student.applyingFor = student.applications
                .firstWhere((app) => app.status == 2)
                .courseName;
            return StudentTile(student: student);
          },
        );
      },
    );
  }
}
