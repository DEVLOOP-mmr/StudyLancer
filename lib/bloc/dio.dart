import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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

    options.baseUrl = kReleaseMode ? productionUrl : local;
    options.headers = {
      "Accept": "application/json",
    };
    dio.options = options;
    return dio;
  }

  static bool isTestMode() {
    return (Platform.environment.containsKey('FLUTTER_TEST'));
  }
}
