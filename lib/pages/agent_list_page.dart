import 'package:elite_counsel/models/agent.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../variables.dart';
import 'agent_details_page_view.dart';

class AgentListPage extends StatelessWidget {
  final List<Agent> agents;
  const AgentListPage({Key key, this.agents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Variables.backgroundColor,
      appBar: AppBar(
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
        backgroundColor: Variables.backgroundColor,
        title: const Text(
          "Our Expert Agents",
          style: TextStyle(
            fontSize: 18,
            color: Variables.accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
              itemCount: agents.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return AgentDetailsPageView(
                        agents: agents,
                        pageNumber: index,
                      );
                    }));
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        shadowLightColor: Colors.white.withOpacity(0.6),
                        color: Colors.transparent,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              agents[index].photo ??
                                  "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.transparent, Colors.black],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Spacer(),
                                Text(
                                  agents[index].name ?? "",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  (agents[index].applicationsHandled ?? "0") +
                                      " Students",
                                  style: const TextStyle(
                                    fontSize: 7,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star_border_purple500_sharp,
                                      color: Colors.white.withOpacity(0.6),
                                      size: 10,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      (agents[index].reviewsAvg ?? "") +
                                          " (" +
                                          (agents[index].reviewCount ?? "0") +
                                          " Reviews)",
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.white.withOpacity(0.6),
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
