import 'package:elite_counsel/bloc/cubit/student_application_cubit.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/pages/home_page/agent/student_list_view/student_tile/student_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class OngoingStudents extends StatelessWidget {
  const OngoingStudents({Key? key, this.filterStudentID})
      : super(
          key: key,
        );
  final String? filterStudentID;
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
        final ongoingApplications =
            agentHomePageState.applications!.where((element) {
          bool agentIDMatchesApplicationAgentID =
              element.status == 3 && element.agent?.id == agent.id;
          if (filterStudentID != null) {
            return agentIDMatchesApplicationAgentID &&
                element.student!.id == filterStudentID;
          }
          return agentIDMatchesApplicationAgentID;
        }).toList();

        return SingleChildScrollView(
          key: UniqueKey(),
          child: Column(
            children: ongoingApplications.map((application) {
              return SizedBox(
                child: BlocProvider(
                  create: (context) => StudentApplicationCubit(
                    application,
                  ),
                  child: StudentTile(),
                ),
              );
            }).toList()
              ..add(SizedBox(
                height: 100,
              )),
          ),
        );
      },
    );
  }
}
