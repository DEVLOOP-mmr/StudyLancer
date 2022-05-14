import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
// ignore: implementation_imports
import 'package:dio/src/response.dart' show Response;
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/models/agent.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/pages/usertype_select/usertype_select_page.dart';
import 'package:elite_counsel/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../dio.dart';

class HomeBloc extends Cubit<HomeState> {
  HomeBloc() : super(InitialHomeState());
  void setCountry(String newCountry, String userType) {
    assert(newCountry.isNotEmpty);
    switch (userType) {
      case 'student':
        if (state is! StudentHomeState) {
          emit(StudentHomeState(
            countryCode: newCountry,
            loadState: LoadState.initial,
          ));
          break;
        }
        emit((state as StudentHomeState).copyWith(countryCode: newCountry));
        break;

      case 'agent':
        if (state is! AgentHomeState) {
          emit(AgentHomeState(
            countryCode: newCountry,
            loadState: LoadState.initial,
          ));
          break;
        }
        emit((state as AgentHomeState).copyWith(countryCode: newCountry));
        break;
      default:
        emit((state as InitialHomeState).copyWith(country: newCountry));
        break;
    }
    assert(state.countryCode!.isNotEmpty);
  }

  void emitNewStudent(Student? student) {
    if (state is StudentHomeState) {
      var homeState = (state as StudentHomeState);
      emit(homeState.copyWith(student: student));
      emit(homeState.copyWith(loadState: LoadState.loading));
      emit(homeState.copyWith(loadState: LoadState.done));
    }
  }

  AgentHomeState agentHome() => (state as AgentHomeState);

  void emitNewAgent(Agent? agent) {
    if (state is AgentHomeState) {
      var homeState = (state as AgentHomeState);
      emit(homeState.copyWith(agent: agent));
      emit(homeState.copyWith(loadState: LoadState.loading));
      emit(homeState.copyWith(loadState: LoadState.done));
    }
  }

  void sortApplications(String order) {
    assert(order == 'asc' || order == 'desc');
    if (state is! StudentHomeState) {
      return;
    }
    var applications = (state as StudentHomeState).student!.applications!;
    applications.sort((a, b) {
      return int.parse(a.courseFees!).compareTo(
        int.parse(b.courseFees!),
      );
    });
    if (order == 'desc') {
      applications = applications.reversed.toList();
    }
    var state2 = (state as StudentHomeState);
    state2.student!.applications = applications;
    emit(state2.copyWith(student: state2.student));
  }

  void sortApplicationsForAgentHome(String order) {
    assert(order == 'asc' || order == 'desc');
    if (state is! AgentHomeState) {
      return;
    }
    var applications = (state as AgentHomeState).applications!;
    applications.sort((a, b) {
      return int.parse(a.courseFees!).compareTo(
        int.parse(b.courseFees!),
      );
    });
    if (order == 'desc') {
      applications = applications.reversed.toList();
    }
    emit((state as AgentHomeState).copyWith(applications: applications));
  }

  void sortStudentsForAgentHomeByTimeline(String order) {
    assert(order == 'asc' || order == 'desc');
    emit((state as AgentHomeState).copyWith(loadState: LoadState.loading));
    var applications = (state as AgentHomeState).applications!;
    try {
      applications.sort((a, b) {
        if (a.status == 3 && b.status == 3) {
          return (a.progress!).compareTo(
            (b.progress!),
          );
        }

        return 0;
      });
    } on Exception catch (e) {
      log(e.toString());
    }
    if (order == 'desc') {
      applications = applications.reversed.toList();
    }
    emit((state as AgentHomeState)
        .copyWith(applications: applications, loadState: LoadState.done));
  }

  Future<StudentHomeState> getStudentHome({
    BuildContext? context,
    FirebaseAuth? firebaseAuth,
  }) async {
    firebaseAuth ??= FirebaseAuth.instance;
    StudentHomeState homeData = StudentHomeState(countryCode: '');
    if (state is! StudentHomeState) {
      emit(homeData.copyWith(
        loadState: LoadState.loading,
      ));
    }
    _setCountryCodeForStudent();
    assert(state.countryCode!.isNotEmpty);
    String? countryLookingFor = state.countryCode!.isEmpty
        ? Variables.sharedPreferences.get(Variables.countryCode)
        : state.countryCode;
    Map<String, String?> body = {
      "studentID": firebaseAuth.currentUser!.uid,
      "countryLookingFor": countryLookingFor ?? 'CA',
      "phone": firebaseAuth.currentUser!.phoneNumber,
    };
    var result = await GetDio.getDio().post(
      "student/home",
      data: jsonEncode(body),
    );

    if (result.statusCode! < 299) {
      homeData = _parseStudentHomeData(result, homeData);
    } else {
      await _handleInvalidResult(result, context);
    }
    emit(homeData.copyWith(loadState: LoadState.done));

    return homeData;
  }

  void _setCountryCodeForStudent() {
    if (state.countryCode!.isEmpty) {
      setCountry(
        Variables.sharedPreferences.get(Variables.countryCode),
        'student',
      );
    }
  }

  StudentHomeState _parseStudentHomeData(
    Response<dynamic> result,
    StudentHomeState homeData,
  ) {
    var data = result.data;
    homeData.student = Student.fromMap(data["student"]);
    homeData.agents = [];
    if (data['agents'] is! String) {
      List agentList = data["agents"];
      for (var element in agentList) {
        homeData.agents!.add(Agent.fromMap(element));
      }
    }

    return homeData;
  }

  Future<void> _handleInvalidResult(
    Response<dynamic> result,
    BuildContext? context,
  ) async {
    final message = forbiddenRequestMessage(result);
    debugPrint(message);
    if (context != null) {
      EasyLoading.showInfo(message!);
      await FirebaseAuth.instance.signOut();
      Variables.sharedPreferences.clear();
      reset();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return const UserTypeSelectPage();
        }),
        (route) => false,
      );
    }
  }

  static String? forbiddenRequestMessage(Response<dynamic> result) {
    String? message = '';
    if (result.statusCode == 403) {
      Map map = (result.data);
      message = map.containsKey('message')
          ? result.data['message']
          : 'You are not authorized to use this feature';
    } else {
      message = 'Something went wrong';
    }

    return message;
  }

  Future<AgentHomeState> getAgentHome({
    BuildContext? context,
    FirebaseAuth? auth,
  }) async {
    auth ??= FirebaseAuth.instance;
    assert(auth.currentUser != null);

    AgentHomeState homeData = _emitInitialAgentState();
    String? countryLookingFor = state.countryCode!.isEmpty
        ? Variables.sharedPreferences.get(Variables.countryCode)
        : state.countryCode;
    Map<String, String?> body = {
      "agentID": auth.currentUser!.uid,
      "countryLookingFor": countryLookingFor ?? "CA",
      "phone": auth.currentUser!.phoneNumber,
    };
    var result =
        await GetDio.getDio().post("agent/home", data: jsonEncode(body));

    if (result.statusCode! < 300) {
      var data = result.data;
      homeData.agent = Agent.fromMap(data["agent"]);
      homeData.applications = [];
      homeData = _parseStudentApplications(data, homeData);
      assert(homeData.agent != null);
      try {
        emit(InitialHomeState(country: '', loadState: LoadState.loading));
        emit(homeData.copyWith(loadState: LoadState.done));
      } on StackOverflowError catch (e) {
        rethrow;
      }
    } else {
      _handleInvalidResult(result, context);
    }

    return homeData;
  }

  AgentHomeState _parseStudentApplications(data, AgentHomeState homeData) {
    List? studentList = data["studentdata"];
    if (studentList != null) {
      homeData.verifiedStudents = [];
      for (var element in studentList) {
        var student = Student.fromMap(element);
        if (student.applications?.isNotEmpty ?? false) {
          for (var application in student.applications ?? []) {
            application.student = student;
            assert(application.agent != null);
            homeData.applications!.add(application);
          }
        } else {
          homeData.verifiedStudents?.add(student);
        }
      }
    }

    return homeData;
  }

  AgentHomeState _emitInitialAgentState() {
    AgentHomeState homeData = AgentHomeState(countryCode: '');
    if (state is! AgentHomeState) {
      emit(homeData.copyWith(loadState: LoadState.loading));
    } else {
      emit((state as AgentHomeState).copyWith(loadState: LoadState.loading));
    }
    if (state.countryCode!.isEmpty) {
      var newCountry = Variables.sharedPreferences.get(Variables.countryCode);
      setCountry(
        newCountry,
        'agent',
      );
    }
    assert(state.countryCode!.isNotEmpty);

    return homeData;
  }

  void reset() {
    emit(InitialHomeState());
  }

  void getHome() {
    final userType = Variables.sharedPreferences.get(Variables.userType);
    switch (userType) {
      case 'student':
        getStudentHome();

        break;
      case 'agent':
        getAgentHome();
        break;
      default:
    }
  }

  void toggleApplicationFavorite(int applicationIndex) async {
    var student = (state as StudentHomeState).student!;
    final applications = student.applications ?? [];
    if (applicationIndex <= applications.length - 1) {
      var application = student.applications![applicationIndex];
      application.favorite =
          !(student.applications![applicationIndex].favorite ?? false);
      emitNewStudent(student);

      try {
        var response =
            await GetDio.getDio().post('application/favourite', data: {
          'applicationId': application.applicationID,
        });
      } catch (e) {
        FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      }
    }
  }
}
