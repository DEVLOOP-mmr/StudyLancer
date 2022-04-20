import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/models/agent.dart';
import 'package:flutter/material.dart';

import 'agent_detail_page.dart';

class AgentDetailsPageView extends StatefulWidget {
  final List<Agent> agents;
  final int pageNumber;
  const AgentDetailsPageView({Key key, this.agents, this.pageNumber})
      : super(key: key);

  @override
  _AgentDetailsPageViewState createState() => _AgentDetailsPageViewState();
}

class _AgentDetailsPageViewState extends State<AgentDetailsPageView> {
  PageController _controller;
  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.pageNumber ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        pageSnapping: true,
        controller: _controller,
        allowImplicitScrolling: true,
        itemCount: widget.agents.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return AgentDetailPage(
            agent: widget.agents[index],
          );
        });
  }
}
