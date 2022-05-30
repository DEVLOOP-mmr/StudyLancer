import 'package:elite_counsel/models/agent.dart';
import 'package:flutter/material.dart';

import 'agent_detail_page.dart';

class AgentDetailsPageView extends StatefulWidget {
  final List<Agent>? agents;
  final int? pageNumber;
  const AgentDetailsPageView({Key? key, this.agents, this.pageNumber})
      : super(key: key);

  @override
  _AgentDetailsPageViewState createState() => _AgentDetailsPageViewState();
}

class _AgentDetailsPageViewState extends State<AgentDetailsPageView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      pageSnapping: true,
      itemCount: widget.agents!.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return AgentDetailPage(
          agent: widget.agents![index],
        );
      },
    );
  }
}
