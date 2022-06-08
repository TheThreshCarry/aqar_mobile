// ignore_for_file: prefer_function_declarations_over_variables, await_only_futures, prefer_const_constructors, invalid_use_of_protected_member, unused_import

import 'dart:convert';
import 'dart:developer';

import 'package:aqar_mobile/Controllers/AuthController.dart';
import 'package:aqar_mobile/Controllers/MiscController.dart';
import 'package:aqar_mobile/Controllers/PropertiesController.dart';
import 'package:aqar_mobile/Controllers/ThemeController.dart';
import 'package:aqar_mobile/Pages/Agency/HomeAgency.dart';
import 'package:aqar_mobile/Pages/AllowLocation.dart';
import 'package:aqar_mobile/Pages/CheckFirstTime.dart';
import 'package:aqar_mobile/Pages/Home.dart';
import 'package:aqar_mobile/Pages/SignIn.dart';
import 'package:aqar_mobile/Pages/SignUp.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp();
    () async {
      final String responseWorld =
          await rootBundle.loadString('assets/world.json');
      final String responsePhone =
          await rootBundle.loadString('assets/phone.json');
      final worldData = await json.decode(responseWorld);
      final phoneData = await json.decode(responsePhone);
      setState(() {
        ref.read(generalProvider).jsonCountryData = worldData;
        ref.read(generalProvider).jsonCountryPhoneData = phoneData;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ref.read(themeProvider.notifier).state;

    ref.watch(themeProvider.notifier).addListener((state) {
      setState(() {
        theme = state;
      });
    });
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: theme,
      darkTheme: theme,
      routes: {
        "/": (context) => CheckFirstTime(),
        "/allowLocation": (context) => AllowLocation(),
        "/test": (context) => MyHomePage(),
        "/home": (context) => Home(),
        "/agency/home": (context) => HomeAgency(),
        "/login": (context) => SignInPage(),
        "/register": (context) => SignUpPage()
      },
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  SharedPreferences? pref;

  bool isLoggedIn = false;
  bool isLoading = false;
  String textToShow = "";
  String privateDataResult = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("AQAR"),
      ),
      body: FutureBuilder(
        future: verifyToken(context, ref),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          isLoggedIn = ref.read(authProvider).loggedIn();
          textToShow = "You Are ${isLoggedIn ? "Logged In" : "Logged Out"}";
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(textToShow),
                TextButton(
                    onPressed: () async {
                      dynamic result;
                      setState(() {
                        isLoading = true;
                      });

                      if (isLoggedIn) {
                        result = await ref.read(authProvider).Logout();
                        Navigator.popAndPushNamed(context, "/login");
                      } else {
                        result = await ref
                            .read(authProvider)
                            .Login("mehdi@test.com", "123");
                      }
                      setState(() {
                        isLoading = false;
                        if (result.runtimeType == DioError) {
                          textToShow = "Error On Login";
                        } else {
                          ref.read(authProvider).isLoggedIn =
                              !ref.read(authProvider).isLoggedIn;
                          textToShow =
                              "You Are ${ref.read(authProvider).isLoggedIn ? "Logged In" : "Logged Out"}";
                        }
                      });
                    },
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Text(isLoggedIn ? "Déconexion" : "Se Connecter")),
                TextButton(
                    onPressed: () async {
                      dynamic result =
                          await ref.read(authProvider).TestLoggedData();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result.toString())));
                    },
                    child: Text("Private Data")),
                TextButton(
                    onPressed: () async {
                      await ref.read(authProvider).prefs?.remove("firstTime");
                      Navigator.popAndPushNamed(context, "/");
                    },
                    child: Text("Reload First Screen"))
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //dynamic result = await ref.watch(authProvider).TestLoggedData();
          ref.read(themeProvider.notifier).switchTheme();
        },
        child: const Text("Theme"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Future<String?> verifyToken(BuildContext context, WidgetRef ref) async {
  ref.watch(authProvider).prefs = await SharedPreferences.getInstance();
  String? token = ref.watch(authProvider).prefs!.getString("token");
  return token;
}


/*
   
      */