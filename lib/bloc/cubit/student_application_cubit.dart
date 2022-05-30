import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:elite_counsel/bloc/dio.dart';
import 'package:elite_counsel/models/application.dart';
import 'package:elite_counsel/variables.dart';

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

  static bool isValidCountryCode(String code) {
    return code == 'AU' || code == 'CA';
  }

  static String? parseProgressTitleFromValue(
      String countryCode, int progressValue) {
    Map<int, String> map = (isValidCountryCode(countryCode)
                ? countryCode
                : Variables.sharedPreferences.get(Variables.countryCode)) ==
            'AU'
        ? australiaProgressMap
        : canadaProgressMap;
    if (map.containsKey(progressValue)) {
      return canadaProgressMap[progressValue];
    }
    return null;
  }

  static int? convertProgressTitleToValue(String title) {
    Map<int, String> map =
        Variables.sharedPreferences.get(Variables.countryCode) == 'AU'
            ? australiaProgressMap
            : canadaProgressMap;
    for (var key in map.keys) {
      if (map[key] == title) {
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

  static final Map<int, String> australiaProgressMap = {
    0: "Apply offer letter",
    1: "Prepare GTE docs",
    2: "Pay tuition fees",
    3: "Lodge visa",
    4: "Visa approved",
  };
}
