import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/pages/home_page/agent/student_list_view/student_tile.dart'
    show StudentTile;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class AwaitingStudents extends StatelessWidget {
  const AwaitingStudents({
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

        return ListView.builder(
          itemCount: agentHomePageState.students.where((element) {
            return element.applications.isEmpty;
          }).length,
          itemBuilder: (context, index) {
            var student = agentHomePageState.students.where((element) {
              return element.applications.isEmpty;
            }).toList()[index];

            return StudentTile(
              student: student,
              courseName: '',
            );
          },
        );
      },
    );
  }
}
