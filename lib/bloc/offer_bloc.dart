import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:elite_counsel/bloc/notification_bloc/notification_bloc.dart';
import 'package:elite_counsel/models/application.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dio.dart';

class OfferBloc {
  static Future<Response> addOffer(
    Application application,
    String agentID,
  ) async {
    try {
      Map<dynamic, dynamic> body =
          _responseBodyFromApplication(application, agentID);
      var response = await GetDio.getDio()
          .post("application/create", data: jsonEncode(body));
      if (response.statusCode! < 299) {
        if (kDebugMode) {
          return response;
        }
        EasyLoading.showSuccess("Offer sent");

        NotificationCubit.sendNotificationToUser(
          'You have a new offer',
          'Tap and view your applications',
          application.student!.id!,
        );
      } else {
        var data = response.data;
        if (data.containsKey('message')) {
          if (kDebugMode) {
            log(data['message'].toString());
            return response;
          }
          EasyLoading.showError(data['message']);
        } else {
          if (kDebugMode) {
            log(data['message'].toString());
            return response;
          }
          EasyLoading.showError('Something went wrong');
        }
      }

      return response;
    } on DioError {
      EasyLoading.showError('Cant connect please try again later');
      rethrow;
    }
  }

  static Map<dynamic, dynamic> _responseBodyFromApplication(
      Application application, String agentID) {
    Map body = {
      "studentID": application.student!.id,
      "agentID": agentID,
      "universityName": application.universityName,
      "location": {
        "city": application.city ?? application.location!['city'] ?? '',
        "country":
            application.country ?? application.location!['country'] ?? '',
      },
      "courseFees": int.parse(application.courseFees!),
      "applicationFees": int.parse(application.applicationFees!),
      "courseName": application.courseName,
      "courseLink": application.courseLink,
      "description": application.description,
    };

    return body;
  }

  static Future<Response> acceptOffer(
    String? applicationID,
    String? agentID,
    String? studentID,
  ) async {
    Map body = {
      "studentID": studentID,
      "agentID": agentID,
      "applicationID": applicationID,
    };
    try {
      final response = await GetDio.getDio().post(
        "student/application/add",
        data: jsonEncode(body),
      );
      if (response.statusCode! < 299) {
        if (kDebugMode) {
          return response;
        }
        if (response.statusCode == 202) {
          EasyLoading.showInfo("You cannot accept more than 3 offers");
        } else {
          NotificationCubit.sendNotificationToUser(
            'Offer Accepted',
            'A student has accepted an offer you made',
            agentID!,
          );
          EasyLoading.showSuccess("Offer Accepted");
        }
      } else {
        return _handleInvalidOfferResponse(response);
      }

      return response;
    } on DioError {
      EasyLoading.show(status: 'Cant connect please try again later');
      rethrow;
    }
  }

  static Response<dynamic> _handleInvalidOfferResponse(
    Response<dynamic> response,
  ) {
    if (kDebugMode) {
      return response;
    }

    if (response.data.containsKey('message')) {
      EasyLoading.show(status: response.data['message']);
    } else {
      EasyLoading.show(status: 'Something went wrong');
    }

    return response;
  }
}
