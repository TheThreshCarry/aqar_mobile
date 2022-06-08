// ignore_for_file: prefer_const_constructors_in_immutables, file_names, prefer_const_constructors
import 'dart:developer';

import 'package:aqar_mobile/Controllers/AuthController.dart';
import 'package:aqar_mobile/Controllers/LocationHandeler.dart';
import 'package:aqar_mobile/Controllers/MiscController.dart';
import 'package:aqar_mobile/Controllers/ThemeController.dart';
import 'package:aqar_mobile/Pages/AllowLocation.dart';
import 'package:aqar_mobile/Pages/SignIn.dart';
import 'package:aqar_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckFirstTime extends ConsumerStatefulWidget {
  CheckFirstTime({Key? key}) : super(key: key);

  @override
  _CheckFirstTimeState createState() => _CheckFirstTimeState();
}

class _CheckFirstTimeState extends ConsumerState<CheckFirstTime> {
  @override
  void initState() {
    super.initState();
    String routeName = "/home";
    () async {
      SharedPreferences? prefs = await ref.read(authProvider).setupPrefs();
      bool? firstTime = prefs?.getBool("firstTime");
      bool loggedIn = ref.read(authProvider).loggedIn();
      if (firstTime == null) {
        await prefs?.setBool("firstTime", false);
        routeName = "/allowLocation";
      } else {
        if (ref.read(generalProvider).isRequesting == false) {
          ref.read(generalProvider).isRequesting = true;
          ref.read(authProvider).userPosition = await determinePosition();
          ref.read(generalProvider).isRequesting = false;
        }

        if (loggedIn) {
          await ref.read(authProvider).getUserData();
          print(ref.read(authProvider).userData["user_type"]);
          if (ref.read(authProvider).userData["user_type"] == 'c') {
            routeName = "/home";
          } else {
            routeName = "/agency/home";
          }
        } else {
          routeName = "/home";
        }
      }
      Navigator.of(context)
          .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
