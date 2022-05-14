import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../profile/profile_test.dart';

void main() {
  test('Test to sort students for agent home by timeline', () async {
    final bloc = HomeBloc();
    var agentHome = await ProfileTestSuite().getAgentHome(bloc);

    expect(bloc.state is AgentHomeState, true);

    bloc.sortStudentsForAgentHomeByTimeline('desc');

    final applications = (bloc.agentHome()).applications;
  });
}
