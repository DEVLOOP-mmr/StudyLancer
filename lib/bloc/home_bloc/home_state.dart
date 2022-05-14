import 'package:equatable/equatable.dart';

import 'package:elite_counsel/models/agent.dart';
import 'package:elite_counsel/models/application.dart';
import 'package:elite_counsel/models/student.dart';

enum LoadState { initial, loading, error, done }

abstract class HomeState extends Equatable {
  LoadState? loadState = LoadState.initial;
  String? countryCode;
  HomeState({
    this.loadState,
    this.countryCode,
  });
}

class InitialHomeState extends HomeState {
  InitialHomeState({String? country, LoadState? loadState})
      : super(countryCode: country, loadState: loadState) {
    loadState = LoadState.initial;
  }
  InitialHomeState copyWith({String? country, LoadState? loadState}) {
    return InitialHomeState(
      country: country ?? countryCode,
      loadState: loadState ?? this.loadState,
    );
  }

  @override
  List<Object?> get props => [countryCode, loadState];
}

class StudentHomeState extends HomeState {
  Student? student;
  List<Agent>? agents;

  StudentHomeState({
    LoadState? loadState,
    this.student,
    this.agents,
    String? countryCode,
  }) : super(loadState: loadState, countryCode: countryCode);

  StudentHomeState copyWith({
    LoadState? loadState,
    String? countryCode,
    Student? student,
    List<Agent>? agents,
  }) {
    return StudentHomeState(
      student: student ?? this.student,
      agents: agents ?? this.agents,
      loadState: loadState ?? this.loadState,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  @override
  List<Object?> get props => [loadState, student, agents, countryCode];
}

class AgentHomeState extends HomeState with EquatableMixin {
  Agent? agent;
  List<Application>? applications;
  List<Student>? verifiedStudents;

  AgentHomeState({
    String? countryCode,
    LoadState? loadState,
    this.agent,
    this.applications,
    this.verifiedStudents,
  }) : super(loadState: loadState, countryCode: countryCode);

  AgentHomeState copyWith({
    Agent? agent,
    List<Application>? applications,
    List<Student>? verifiedStudents,
    LoadState? loadState,
    String? countryCode,
  }) {
    return AgentHomeState(
      agent: agent ?? this.agent,
      applications: applications ?? this.applications,
      verifiedStudents: verifiedStudents ?? this.verifiedStudents,
      loadState: loadState ?? this.loadState,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  @override
  List<Object?> get props => [
        agent,
        applications,
        verifiedStudents,
      ];
}
