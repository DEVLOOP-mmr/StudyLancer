import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../profile/profile_test.dart';

void main() {
  test('Test to sort applications for agent home by timeline', () async {
    final bloc = HomeBloc();
    var agentHome = await ProfileTestSuite().getAgentHome(bloc);

    expect(bloc.state is AgentHomeState, true);

    bloc.sortStudentsForAgentHomeByTimeline('desc');

    final applications = (((bloc.agentHome())
                .applications
                ?.where((element) => element.status == 3)) ??
            [])
        .toList();
    if (applications.length == 2) {
      expect(applications[0].progress! >= applications[1].progress!, true);
    } else if (applications.length > 2) {
      for (int i = 0; i < applications.length; i++) {
        if (i + 1 <= applications.length - 1) {
          expect(
            applications[i].progress! >= applications[i + 1].progress!,
            true,
          );
        }
      }
    }
  });
}
