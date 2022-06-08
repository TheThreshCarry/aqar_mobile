// ignore_for_file: prefer_const_constructors_in_immutables, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace
import 'package:aqar_mobile/Controllers/AuthController.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInPage extends ConsumerStatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  String email = "";
  String password = "";
  bool showPassword = true;
  bool loadingEmailLogin = false;
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    () async {
      ref.read(authProvider).setupPrefs();
      String? token = ref.read(authProvider).verifyToken();
    }();
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: Form(
        key: formKey,
        child: Container(
          height: size.height,
          width: size.width,
          padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                height: 50,
                width: 50,
                child: Navigator.canPop(context)
                    ? IconButton(
                        icon: Icon(Icons.arrow_back),
                        iconSize: 32,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    : SizedBox()),
            SizedBox(
              height: 80,
            ),
            Text(
              "Welcome Back",
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 20),
            Text(
              "Login In Using ...",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: size.width * 0.33,
                  height: 70,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Color(0xFFF4F4F4))),
                    onPressed: () async {
                      print("Google Login");
                      try {
                        GoogleSignInAccount? data =
                            await ref.read(authProvider).googleSignIn();

                        Navigator.popAndPushNamed(context, "/home");
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/Materials/Images/Google_Logo.svg",
                            width: 35,
                            height: 35,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Google",
                            style: TextStyle(color: Color(0xFF282828)),
                          )
                        ]),
                  ),
                ),
                Container(
                  width: size.width * 0.33,
                  height: 70,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Color(0xFFF4F4F4))),
                    onPressed: () {
                      print("Facebook Login");
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/Materials/Images/Facebook_Logo.svg",
                            width: 35,
                            height: 35,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Facebook",
                              style: TextStyle(
                                color: Color(0xFF282828),
                              ))
                        ]),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: 1,
                    width: size.width * 0.35,
                    color: Color(0xFFC7C7C7).withOpacity(0.69)),
                Text("or",
                    style:
                        TextStyle(color: Color(0xFFC7C7C7).withOpacity(0.69))),
                Container(
                    height: 1,
                    width: size.width * 0.35,
                    color: Color(0xFFC7C7C7).withOpacity(0.69)),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFF4F4F4)),
                child: Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        style: TextStyle(color: Color(0xFF282828)),
                        validator: (value) {
                          final emailRegex = RegExp(
                              r'\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$');
                          if (value == null || value.isEmpty) {
                            return "this field is neccessary";
                          }
                          if (!emailRegex.hasMatch(value)) {
                            return "wrong email format";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Example@gmail.com",
                          hintStyle: TextStyle(
                              color: Color(0xFF282828).withOpacity(0.3)),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                    )
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFF4F4F4)),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outlined,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        obscureText: showPassword,
                        style: TextStyle(color: Color(0xFF282828)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "this field is neccessary";
                          }
                          /*if (value.length < 8) {
                            return "password need to be at least 8 Characters";
                          }*/
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "***********",
                            hintStyle: TextStyle(
                                color: Color(0xFF282828).withOpacity(0.3)),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(showPassword
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye),
                              color: Color(0xFF282828),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            )),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                    )
                  ],
                )),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 20,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                GestureDetector(
                  onTap: () {
                    print("go to forgot password");
                  },
                  child: Text(
                    "Forgot Password ?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                )
              ]),
            ),
            SizedBox(height: 60),
            Container(
                width: double.infinity,
                height: 69,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(60)),
                child: TextButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      if (!loadingEmailLogin) {
                        print("Login Email and Password");
                        setState(() {
                          loadingEmailLogin = true;
                        });
                        dynamic result =
                            await ref.read(authProvider).Login(email, password);
                        if (result.runtimeType == DioError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error on Login")));
                          setState(() {
                            loadingEmailLogin = false;
                          });
                          return;
                        } else {
                          Navigator.popAndPushNamed(context, "/");
                          setState(() {
                            loadingEmailLogin = false;
                          });
                          return;
                        }
                      }
                    },
                    child: loadingEmailLogin
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Enter",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ))),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 20,
              width: double.infinity,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Don't Have An Account ?"),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    print("register page");
                    Navigator.popAndPushNamed(context, "/register");
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ]),
            )
          ]),
        ),
      ),
    ));
  }
}
