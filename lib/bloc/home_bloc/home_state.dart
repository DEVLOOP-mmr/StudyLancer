import 'package:elite_counsel/models/agent.dart';
import 'package:equatable/equatable.dart';

import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/models/student.dart';

enum LoadState { initial, loading, error, done }

abstract class HomeState {
  LoadState loadState = LoadState.initial;
  HomeState({
    this.loadState,
  });
}

class UnAuthenticatedHomeState extends HomeState {
  UnAuthenticatedHomeState() {
    loadState = LoadState.initial;
  }
}

class StudentHomeState extends HomeState {
  LoadState loadState;
  Student student;
  List<Agent> agents;
  StudentHomeState({
    this.loadState,
    this.student,
    this.agents,
  });

  StudentHomeState copyWith({
    LoadState loadState,
    Student student,
    List<Agent> agents,
  }) {
    return StudentHomeState(
      loadState: loadState ?? this.loadState,
      student: student ?? this.student,
      agents: agents ?? this.agents,
    );
  }
}

class AgentHomeState extends HomeState with EquatableMixin {
  Agent agent;
  List<Student> students;

  LoadState loadState;
  AgentHomeState({
    this.agent,
    this.students,
    this.loadState,
  });

  AgentHomeState copyWith({
    Agent agent,
    List<Student> students,
    LoadState loadState,
  }) {
    return AgentHomeState(
      agent: agent ?? this.agent,
      students: students ?? this.students,
      loadState: loadState ?? this.loadState,
    );
  }

  @override
  List<Object> get props => [agent, students, loadState];
}
