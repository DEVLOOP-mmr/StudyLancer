import 'dart:io';

import 'package:dio/dio.dart';

class GetDio {
  static var productionUrl = "https://elite-counsel.herokuapp.com/";
  static Dio getDio() {
    Dio dio = Dio();
    var options = BaseOptions();
    options.connectTimeout = 90000;
    options.receiveTimeout = 90000;
    options.sendTimeout = 90000;
    options.followRedirects = true;
    options.validateStatus = (status) {
      return true;
    };
    options.receiveDataWhenStatusError = true;
    options.contentType = Headers.jsonContentType;
    options.responseType = ResponseType.json;

    options.baseUrl = "http://localhost:5000/";
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
