import 'dart:developer';
import 'dart:io';

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
    options.connectTimeout = 5000;
    options.receiveTimeout = 5000;
    options.sendTimeout = 5000;
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
    dio.interceptors.add(
      PrettyDioLogger(
          requestBody: true,
          responseBody: true,
          error: true,
          compact: true,
          logPrint: (object) {
            if (kReleaseMode && Firebase.apps.isNotEmpty) {
              FirebaseCrashlytics.instance.log(object);
            } else {
              log(object);
            }
          }),
    );
    dio.interceptors.add(dioInterceptor());
    return dio;
  }

  static InterceptorsWrapper dioInterceptor() {
    return InterceptorsWrapper(onRequest: (options, handler) {
      // Do something before request is sent
      return handler.next(options); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: `handler.resolve(response)`.
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: `handler.reject(dioError)`
    }, onResponse: (response, handler) {
      // Do something with response data
      return handler.next(response); // continue
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: `handler.reject(dioError)`
    }, onError: (DioError e, handler) {
      if (kReleaseMode && Firebase.apps.isNotEmpty) {
        FirebaseCrashlytics.instance.recordError(e.toString(), e.stackTrace);
      }
      return handler.next(e); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: `handler.resolve(response)`.
    });
  }

  static bool isTestMode() {
    return (Platform.environment.containsKey('FLUTTER_TEST'));
  }
}
