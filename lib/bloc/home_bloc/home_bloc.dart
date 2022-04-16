import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/models/agent.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/pages/usertype_select/usertype_select_page.dart';
import 'package:elite_counsel/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../dio.dart';

class HomeBloc extends Cubit<HomeState> {
  HomeBloc() : super(UnAuthenticatedHomeState());
  void emitNewStudent(Student student) {
    if (state is StudentHomeState) {
      emit((state as StudentHomeState).copyWith(student: student));
    }
  }

  void emitNewAgent(Agent agent) {
    if (state is AgentHomeState) {
      emit((state as AgentHomeState).copyWith(agent: agent));
    }
  }

  Future<StudentHomeState> getStudentHome({
    BuildContext context,
    FirebaseAuth firebaseAuth,
  }) async {
    firebaseAuth ??= FirebaseAuth.instance;
    assert(firebaseAuth.currentUser != null);
    StudentHomeState homeData = StudentHomeState();
    if (state is! StudentHomeState) {
      emit(homeData.copyWith(loadState: LoadState.loading));
    } else {
      // emit((state as AgentHomeState).copyWith(loadState: LoadState.loading));
    }
    Map<String, String> body = {
      "studentID": firebaseAuth.currentUser.uid,
      "countryLookingFor": Variables.sharedPreferences.get(
        Variables.countryCode,
        defaultValue: "AU",
      ),
      "phone": firebaseAuth.currentUser.phoneNumber,
    };
    var result = await GetDio.getDio().post(
      "student/home",
      data: jsonEncode(body),
    );

    if (result.statusCode < 299) {
      var data = result.data;
      homeData.student = Student.parseStudentData(data["student"]);
      homeData.agents = [];
      if (data['agents'] is! String) {
        List agentList = data["agents"];
        for (var element in agentList) {
          homeData.agents.add(Agent.parseAgentData(element));
        }
      }
    } else {
      await handleInvalidResult(result, context);
    }
    emit(homeData.copyWith(loadState: LoadState.done));
    return homeData;
  }

  static Future<void> handleInvalidResult(
    Response<dynamic> result,
    BuildContext context,
  ) async {
    final message = forbiddenRequestMessage(result);
    debugPrint(message);
    if (context != null) {
      EasyLoading.showInfo(message);
      await FirebaseAuth.instance.signOut();
      Variables.sharedPreferences.clear();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return const UserTypeSelectPage();
      }), (route) => false);
    }
  }

  static String forbiddenRequestMessage(Response<dynamic> result) {
    var message = '';
    if (result.statusCode == 403) {
      Map map = (result.data);
      if (map.containsKey('message')) {
        message = result.data['message'];
      } else {
        message = 'You are not authorized to use this feature';
      }
    } else {
      message = 'Something went wrong';
    }
    return message;
  }

  Future<AgentHomeState> getAgentHome({
    BuildContext context,
    FirebaseAuth auth,
  }) async {
    auth ??= FirebaseAuth.instance;
    assert(auth.currentUser != null);

    AgentHomeState homeData = AgentHomeState();
    if (state is! AgentHomeState) {
      emit(homeData.copyWith(loadState: LoadState.loading));
    } else {
      // emit((state as AgentHomeState).copyWith(loadState: LoadState.loading));
    }

    Map<String, String> body = {
      "agentID": auth.currentUser.uid,
      "countryLookingFor": Variables.sharedPreferences
          .get(Variables.countryCode, defaultValue: "AU"),
      "phone": auth.currentUser.phoneNumber,
    };
    var result =
        await GetDio.getDio().post("agent/home", data: jsonEncode(body));

    if (result.statusCode < 300) {
      var data = result.data;
      homeData.agent = Agent.parseAgentData(data["agent"]);
      homeData.students = [];
      List studentList = data["studentdata"];
      if (studentList != null) {
        for (var element in studentList) {
          var student = Student.parseStudentData(element);

          homeData.students.add(student);
        }
      }

      assert(homeData.agent != null);
      emit(homeData.copyWith(loadState: LoadState.done));
      return homeData;
    } else {
      handleInvalidResult(result, context);
    }
  }

  void reset() {
    emit(UnAuthenticatedHomeState());
  }
}
