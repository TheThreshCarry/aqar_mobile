// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NeedToSignUp extends ConsumerStatefulWidget {
  NeedToSignUp({Key? key}) : super(key: key);

  @override
  _NeedToSignUpState createState() => _NeedToSignUpState();
}

class _NeedToSignUpState extends ConsumerState<NeedToSignUp> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: Center(
          child: TextButton(
        child: Text("Need To Login First"),
        onPressed: () {
          Navigator.pushNamed(context, "/login");
        },
      )),
    );
  }
}
