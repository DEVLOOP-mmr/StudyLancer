import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/pages/home_page/agent/student_tile.dart';
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
        return ListView.builder(
          itemCount: agentHomePageState.students.where((element) {
            if (element.applications.first.status == 2) {
              return true;
            }
            return false;
          }).length,
          itemBuilder: (context, index) {
            var student = agentHomePageState.students.where((element) {
              if (element.applications.first.status == 2) {
                return true;
              }
              return false;
            }).toList()[index];
            return StudentTile(student: student);
          },
        );
      },
    );
  }
}
