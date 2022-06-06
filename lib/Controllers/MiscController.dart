import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

final generalProvider =
    StateProvider<GeneralController>((ref) => GeneralController());

String getPriceString(double price) {
  if (price < 1000000) {
    return (price / 1000).toStringAsFixed(2) + "K";
  } else if (price < 1000000000) {
    return (price / 1000000).toStringAsFixed(2) + "M";
  } else {
    return (price / 1000000000).toStringAsFixed(2) + "B";
  }
}

class GeneralController {
  bool isRequesting = false;
  List<dynamic>? jsonCountryData;
  List<dynamic>? jsonCountryPhoneData;
  List<String> getCountryNames() {
    List<String> temp = [];
    jsonCountryData?.forEach((element) {
      temp.add(element["name"]);
    });
    return temp;
  }

  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrlString(googleUrl)) {
      await launchUrlString(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  String getCountryPhone(String countryName) {
    String code = getCountryCode(countryName).toUpperCase();
    List<dynamic>? result = jsonCountryPhoneData
        ?.where((element) => element["code"] == code)
        .toList();
    return result?[0]["dial_code"];
  }

  String getCountryCode(String countryName) {
    List<dynamic>? result = jsonCountryData
        ?.where((element) => element["name"] == countryName)
        .toList();

    return result?[0]["alpha2"];
  }

  TabController? homePageController;
  String getCountryImage(String countryName) {
    List<dynamic>? result = jsonCountryData
        ?.where((element) => element["name"] == countryName)
        .toList();
    String imagePath =
        "assets/Materials/Images/flags/${result?[0]["alpha2"]}.png";
    return imagePath;
  }
}



/*


*/