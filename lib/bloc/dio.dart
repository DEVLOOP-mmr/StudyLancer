import 'package:dio/dio.dart';

class GetDio {
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
    options.contentType = Headers.textPlainContentType;
    options.responseType = ResponseType.json;
    options.baseUrl = "https://elite-counsel.herokuapp.com/";
    dio.options = options;
    return dio;
  }
}
