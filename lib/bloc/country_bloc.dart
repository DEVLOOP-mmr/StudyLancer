import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dio.dart';

class CountryBloc {
  static Future<bool> requestCallback(String message, String phone) async {
    var result = await GetDio.getDio().get("callback/send");
    if (result.statusCode < 300) {
      return true;
    }
    return false;
  }

  static Future<List<Country>> getCountries() async {
    List<Country> countries = [];
    try {
      var result = await GetDio.getDio().get("countries/");
      if (result.statusCode < 300) {
        var data = result.data;
        List countryList = data["data"];
        countryList.forEach((countryData) {
          countries.add(parseCountryData(countryData));
        });
      } else {
        if (kDebugMode) {
          throw Exception('countries/:' + result.statusCode.toString());
        } else {
          EasyLoading.showToast('Something Went Wrong');
        }
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        rethrow;
      } else {
        EasyLoading.showToast('Cant connect');
      }

      return [];
    }
    return countries;
  }

  static Future<Country> getSelfCountry([String countryID]) async {
    Country country = Country();
    Map body = {
      "countryID": countryID ??= Variables.sharedPreferences
          .get(Variables.countryCode, defaultValue: "notSure"),
    };
    var result =
        await GetDio.getDio().post("countries/single", data: jsonEncode(body));
    if (result.statusCode < 300) {
      var data = result.data;
      var countryData = data["data"];
      country = parseCountryData(countryData);
    }
    return country;
  }

  static Country parseCountryData(countryData) {
    Country country = Country();
    country.images = [];
    if (countryData is List) {
      countryData.forEach((element) {
        List images = element["countryImages"];
        images.forEach((image) {
          country.images.add(CountryImage(image["description"], image["url"]));
        });
      });
    } else {
      country.countryName = countryData["countryName"];
      country.id = countryData["_id"];
      List images = countryData["countryImages"];
      images.forEach((image) {
        country.images.add(CountryImage(image["description"], image["url"]));
      });
    }
    return country;
  }
}
