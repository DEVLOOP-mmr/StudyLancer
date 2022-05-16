import 'package:bloc/bloc.dart';
import 'package:elite_counsel/bloc/dio.dart';
import 'package:elite_counsel/models/application.dart';

import 'package:elite_counsel/models/student.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class StudentApplicationCubit extends Cubit<Application> {
  StudentApplicationCubit(Application application) : super(application);

  Future<void> changeApplicationProgress(int newProgress) async {
    var application = state;
    application.progress = (newProgress);

    emit(application);
    if (kReleaseMode) {
      EasyLoading.showToast('Changing Status');
    }

    final response =
        await GetDio.getDio().post('application/progressUpdate', data: {
      'applicationId': state.applicationID,
      'progress': newProgress.toString(),
    });
    if (response.statusCode != 200) {
      throw Exception('progressUpdate${response.statusCode}');
    } else {}
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
