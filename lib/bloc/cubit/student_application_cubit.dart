import 'package:bloc/bloc.dart';
import 'package:elite_counsel/bloc/dio.dart';

import 'package:elite_counsel/models/student.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class StudentApplicationCubit extends Cubit<Student> {
  StudentApplicationCubit(Student student) : super(student);

  Future<void> changeApplicationProgress(
      String applicationID, int newProgress) async {
    var student = state;
    var applications = student.applications;
    if (applications == null) {
      return;
    }
    int index = applications
        .indexWhere((element) => element.applicationID == applicationID);
    if (index != -1 && index <= (applications.length) - 1) {
      applications[index].progress = (newProgress);
    }
    student.applications = applications;
    student.timeline = newProgress;
    emit(student);
    if (kReleaseMode) {
      EasyLoading.showToast('Changing Status');
    }

    final response =
        await GetDio.getDio().post('application/progressUpdate', data: {
      'applicationId': applicationID,
      'progress': newProgress.toString(),
    });
    if (response.statusCode != 200) {
      throw Exception('progressUpdate${response.statusCode}');
    }
    if (kReleaseMode) {
      EasyLoading.dismiss();
    }
  }

  static String? parseProgressTitleFromValue(int progressValue) {
    if (canadaProgressMap.containsKey(progressValue)) {
      return canadaProgressMap[progressValue];
    }
    return null;
  }

  static int? convertProgressTitleToValue(String title) {
    for (var key in canadaProgressMap.keys) {
      if (canadaProgressMap[key] == title) {
        return key;
      }
    }
    return null;
  }

  static final Map<int, String> canadaProgressMap = {
    0: 'Apply Offer Letter',
    1: 'Lodge Visa',
    2: 'Book Biometric',
    3: 'Visa Approved',
    4: 'Passport Stamping',
    5: 'Prepare To Fly',
  };
}
