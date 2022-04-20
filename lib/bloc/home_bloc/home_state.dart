import 'package:equatable/equatable.dart';

import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/models/agent.dart';
import 'package:elite_counsel/models/student.dart';

enum LoadState { initial, loading, error, done }

abstract class HomeState {
  LoadState loadState = LoadState.initial;
  String countryCode;
  HomeState({
    this.loadState,
    this.countryCode,
  });
}

class InitialHomeState extends HomeState {
  InitialHomeState({String country, LoadState loadState})
      : super(countryCode: country, loadState: loadState) {
    loadState = LoadState.initial;
  }
  InitialHomeState copyWith({String country, LoadState loadState}) {
    return InitialHomeState(
      country: country ?? countryCode,
      loadState: loadState ?? this.loadState,
    );
  }
}

class StudentHomeState extends HomeState with EquatableMixin {
  @override
  LoadState loadState;
  Student student;
  List<Agent> agents;
  @override
  String countryCode;
  StudentHomeState({
    this.loadState,
    this.student,
    this.agents,
    this.countryCode,
  });

  StudentHomeState copyWith({
    LoadState loadState,
    Student student,
    List<Agent> agents,
    String countryCode,
  }) {
    return StudentHomeState(
      loadState: loadState ?? this.loadState,
      student: student ?? this.student,
      agents: agents ?? this.agents,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  @override
  List<Object> get props => [loadState, student, agents, countryCode];
}

class AgentHomeState extends HomeState with EquatableMixin {
  Agent agent;
  List<Student> students;
  @override
  String countryCode;
  @override
  LoadState loadState;
  AgentHomeState({
    this.agent,
    this.students,
    this.loadState,
    this.countryCode,
  });

  AgentHomeState copyWith({
    Agent agent,
    List<Student> students,
    String countryCode,
    LoadState loadState,
  }) {
    return AgentHomeState(
      agent: agent ?? this.agent,
      students: students ?? this.students,
      countryCode: countryCode ?? this.countryCode,
      loadState: loadState ?? this.loadState,
    );
  }

  @override
  List<Object> get props => [agent, students, countryCode, loadState];
}
