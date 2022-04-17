import 'package:elite_counsel/models/agent.dart';
import 'package:equatable/equatable.dart';

import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/models/student.dart';

enum LoadState { initial, loading, error, done }

abstract class HomeState {
  LoadState loadState = LoadState.initial;
  String country;
  HomeState({
    this.loadState,
    this.country,
  });
}

class InitialHomeState extends HomeState {
  InitialHomeState({String country, LoadState loadState})
      : super(country: country, loadState: loadState) {
    loadState = LoadState.initial;
  
  }
  InitialHomeState copyWith({String country, LoadState loadState}) {
    return InitialHomeState(
      country: country ?? this.country,
      loadState: loadState ?? this.loadState,
    );
  }
}

class StudentHomeState extends HomeState {
  LoadState loadState;
  Student student;
  List<Agent> agents;
  @override
  String country;
  StudentHomeState({
    this.loadState,
    this.student,
    this.agents,
    this.country,
  });

  StudentHomeState copyWith(
      {LoadState loadState,
      Student student,
      List<Agent> agents,
      String country}) {
    return StudentHomeState(
      loadState: loadState ?? this.loadState,
      student: student ?? this.student,
      agents: agents ?? this.agents,
      country: country ?? this.country,
    );
  }
}

class AgentHomeState extends HomeState with EquatableMixin {
  Agent agent;
  List<Student> students;
  @override
  String country;
  @override
  LoadState loadState;
  AgentHomeState({
    this.agent,
    this.students,
    this.loadState,
    this.country,
  });

  AgentHomeState copyWith({
    Agent agent,
    List<Student> students,
    LoadState loadState,
    String country,
  }) {
    return AgentHomeState(
      agent: agent ?? this.agent,
      students: students ?? this.students,
      loadState: loadState ?? this.loadState,
      country: country ?? this.country,
    );
  }

  @override
  List<Object> get props => [agent, students, loadState];
}
