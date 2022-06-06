// ignore_for_file: prefer_const_constructors_in_immutables, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace
import 'dart:developer';

import 'package:aqar_mobile/Controllers/RegisterFormController.dart';
import 'package:aqar_mobile/Controllers/StorageController.dart';
import 'package:aqar_mobile/Widgets/RegisterFirst.dart';
import 'package:aqar_mobile/Widgets/RegisterSecond.dart';
import 'package:aqar_mobile/Widgets/RegisterThird.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Controllers/AuthController.dart';

class SignUpPage extends ConsumerStatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
          height: size.height,
          width: size.width,
          child: Column(children: [
            Container(
              height: 30,
              width: size.width,
              margin: EdgeInsets.only(left: 20),
              child: Row(children: [
                controller.index > 0
                    ? IconButton(
                        icon: Icon(Icons.arrow_back_ios, size: 30),
                        onPressed: () {
                          setState(() {
                            controller.animateTo(controller.index - 1);
                          });
                        })
                    : SizedBox.shrink(),
              ]),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                height: size.height * 0.65,
                width: size.width,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    RegisterFirst(),
                    RegisterSecond(),
                    RegisterThird()
                  ],
                  controller: controller,
                )),
            Container(
              height: 100,
              width: size.width,
              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Column(
                children: [
                  Container(
                      width: double.infinity,
                      height: 69,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60)),
                      child: TextButton(
                          onPressed: () {
                            if (controller.index == 0) {
                              if (ref
                                  .read(registerProvider)
                                  .validateEmailForm()) {
                                setState(() {
                                  controller.animateTo(controller.index + 1);
                                });
                              } else {
                                setState(() {});
                              }
                              //
                            } else if (controller.index == 1) {
                              if (ref
                                  .read(registerProvider)
                                  .validatePhoneForm()) {
                                setState(() {
                                  controller.animateTo(controller.index + 1);
                                });
                              } else {
                                setState(() {});
                              }
                            } else {
                              if (ref
                                  .read(registerProvider)
                                  .validateLastForm()) {
                                setState(() {
                                  isLoading = true;
                                });
                                ref
                                    .read(authProvider)
                                    .registerUser(
                                        ref.read(registerProvider).toJson(),
                                        ref.read(storageProvider).storage)
                                    .then((value) {
                                  setState(() {
                                    isLoading = false;
                                    log(value.toString());
                                    if (value == DioError) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text("Error on Login")));
                                      return;
                                    } else {
                                      Navigator.popAndPushNamed(
                                          context, "/test");
                                      return;
                                    }
                                  });
                                });
                              }
                            }
                          },
                          child: isLoading
                              ? CircularProgressIndicator()
                              : Text(
                                  controller.index == 2 ? "Finish" : "Next",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                ))),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 20,
                    width: double.infinity,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already Have An Account ?"),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              print("register page");
                              Navigator.popAndPushNamed(context, "/login");
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
