// ignore_for_file: prefer_const_constructors

import 'package:aqar_mobile/Controllers/RegisterFormController.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Controllers/AuthController.dart';

class RegisterFirst extends ConsumerStatefulWidget {
  RegisterFirst({Key? key}) : super(key: key);

  @override
  _RegisterFirstState createState() => _RegisterFirstState();
}

class _RegisterFirstState extends ConsumerState<RegisterFirst> {
  final keyForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ref.read(registerProvider).formEmailKey = keyForm;
    Size size = MediaQuery.of(context).size;
    return Form(
      key: ref.read(registerProvider).formEmailKey,
      child: Container(
        height: size.height * 0.65,
        width: size.width,
        padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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

                      Navigator.popAndPushNamed(context, "/test");
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
                  style: TextStyle(color: Color(0xFFC7C7C7).withOpacity(0.69))),
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
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      style: const TextStyle(color: Color(0xFF282828)),
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
                            color: const Color(0xFF282828).withOpacity(0.3)),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        ref.watch(registerProvider).email = value;
                      },
                    ),
                  )
                ],
              )),
        ]),
      ),
    );
  }
}
