import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class GetDio {
  static var productionUrl = "https://study-lancer.herokuapp.com/";

  static var local = "http://localhost:5000/";
  static Dio getDio() {
    Dio dio = Dio();
    var options = BaseOptions();
    options.connectTimeout = 20000;
    options.receiveTimeout = 0;
    options.sendTimeout = 0;
    options.followRedirects = true;
    options.validateStatus = (status) {
      return true;
    };
    options.receiveDataWhenStatusError = true;
    options.contentType = Headers.jsonContentType;
    options.responseType = ResponseType.json;

    options.baseUrl = productionUrl;
    options.headers = {
      "Accept": "application/json",
    };
    dio.options = options;

    dio.interceptors.add(dioInterceptor());
    return dio;
  }

  static InterceptorsWrapper dioInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        return handler.next(options); //continue
      },
      onResponse: (response, handler) {
        if (response.statusCode > 299 && response.statusCode != 403) {
          var exceptionData = {
            'url': response.requestOptions.uri.toString(),
            'statusCode': '${response.statusCode}',
            'requestBody': response.requestOptions.data,
            'responseBody': response.data,
            'params': response.requestOptions.queryParameters,
          };

          logDioException(exceptionData);
        }

        return handler.next(response); // continue
      },
      onError: (DioError e, handler) {
        if (Firebase.apps.isNotEmpty && !kDebugMode) {
          FirebaseCrashlytics.instance.recordError(e.toString(), e.stackTrace);
        } else {
          debugPrint(e.error.toString());
        }

        return handler.next(e); //continue
        // If you want to resolve the request with some custom data，
        // you can resolve a `Response` object eg: `handler.resolve(response)`.
      },
    );
  }

  static void logDioException(Map<String, dynamic> exception) {
    if (Firebase.apps.isNotEmpty && kReleaseMode) {
      FirebaseCrashlytics.instance.recordError(exception, StackTrace.current);
    } else {
      debugPrint(exception.toString());
    }
  }

  static String prettyJson(
    dynamic json, {
    int indent = 2,
  }) {
    final spaces = ' ' * indent;
    final encoder = JsonEncoder.withIndent(spaces, (obj) {
      if (obj is Timestamp) {
        return obj.toString();
      }

      return obj;
    });

    return (encoder.convert(json));
  }

  static bool isTestMode() {
    return (Platform.environment.containsKey('FLUTTER_TEST'));
  }
}
