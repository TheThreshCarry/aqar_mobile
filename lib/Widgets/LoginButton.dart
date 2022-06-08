// ignore_for_file: prefer_const_constructors_in_immutables, file_names, prefer_const_constructors
import 'package:aqar_mobile/Controllers/AuthController.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginButton extends ConsumerStatefulWidget {
  LoginButton({Key? key}) : super(key: key);

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends ConsumerState<LoginButton> {
  bool isLoading = false;
  String textToShow = "";
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          bool isLoggedIn = ref.read(authProvider).isLoggedIn;
          dynamic result;
          setState(() {
            isLoading = true;
          });

          if (ref.read(authProvider).isLoggedIn) {
            result = await ref.watch(authProvider).Logout();
          } else {
            result =
                await ref.watch(authProvider).Login("mehdi@test.com", "123");
          }
          setState(() {
            isLoading = false;
            if (result.runtimeType == DioError) {
              textToShow = "Error On Login";
            } else {
              isLoggedIn = !isLoggedIn;
              textToShow = "You Are ${isLoggedIn ? "Logged In" : "Logged Out"}";
            }
          });
        },
        child: isLoading
            ? CircularProgressIndicator()
            : Text(ref.read(authProvider).isLoggedIn
                ? "Déconnexion"
                : "Se Connecter"));
  }
}
