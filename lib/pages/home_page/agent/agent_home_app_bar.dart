import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/pages/home_page/agent/agent_home.dart';
import 'package:elite_counsel/pages/profile_page/agent/agent_profile_page.dart';
import 'package:elite_counsel/variables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class AgentHomeAppBar extends StatelessWidget {
  const AgentHomeAppBar({
    Key key,
    @required this.scaffoldKey,
  });
  final scaffoldKey;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: null,
      backgroundColor: Variables.backgroundColor,
      centerTitle: false,
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AgentProfilePage()));
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is! AgentHomeState) {
                return Container();
              }
              final agentHomePageState = state as AgentHomeState;
              final agent = agentHomePageState.agent;
              return agent == null
                  ? Container()
                  : Container(
                      height: 25,
                      width: 25,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: CachedNetworkImage(
                        imageUrl: agent.photo ??
                            "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg",
                        fit: BoxFit.cover,
                        height: 25,
                        width: 25,
                      ),
                    );
            },
          ),
        ),
        GestureDetector(
          child: Image.asset("assets/images/menu.png"),
          onTap: () {
            scaffoldKey.currentState.openEndDrawer();
          },
        )
      ],
      title: Text(
        "Study Lancer",
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: <Color>[Color(0xffFF8B86), Color(0xffAE78BE)],
              ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))),
      ),
    );
  }
}
